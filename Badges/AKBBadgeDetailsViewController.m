//
//  BTBadgeDetailsViewController.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/14/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBBadgeDetailsViewController.h"
// Views
#import "AKBBackgroundView.h"
#import "AKBHorizontalScroller.h"
#import "AKBChainView.h"
#import "AKBActiveDayControl.h"
// Models
#import "AKBDataManager.h"

@interface AKBBadgeDetailsViewController () <AKBHorizontalScrollerDataSource, AKBHorizontalScrollerDelegate,UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    __weak UITextField *_titleTextField;
    __weak AKBActiveDayControl *_activeDayControl;
    __weak AKBHorizontalScroller *_chainScroller;
    __weak UIButton *_deleteButton;
    
    __weak AKBDay *_selectedDay;
    
    CGFloat _scrollerXOffset;
    NSMutableArray *_chainScrollerUndoStack;
}
@end

@implementation AKBBadgeDetailsViewController

#pragma mark - View controller lifecyle methods
- (id)init
{
    self = [super init];
    if (self) {
        _chainScrollerUndoStack = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadInterface) name:@"AKBBadgeDidAddNewDayNotification" object:nil];
    }
    return self;
}

- (void)loadView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.view = [[AKBBackgroundView alloc] initWithFrame:screenRect];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewWillLayoutSubviews
{
    [self initNavigationItem];
    [self initTextField];
    [self initActiveDayControl];
    [self initChainScroller];
    [self initDeleteButton];
}

#pragma mark - Subview initialization methods
- (void)initNavigationItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
}

- (void)initTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, 31)];
    _titleTextField = textField;
    _titleTextField.delegate = self;
    _titleTextField.placeholder = @"Enter Badge Title";
    _titleTextField.text = self.badge.title;
    _titleTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_titleTextField];
}

- (void)initActiveDayControl
{
    AKBActiveDayControl *activeDayControl = [[AKBActiveDayControl alloc] initWithFrame:CGRectMake(0, 125, self.view.bounds.size.width, 40) activeDays:_badge.activeDays];
    _activeDayControl = activeDayControl;
    [self.view addSubview:_activeDayControl];
}

- (void)initChainScroller
{
    AKBHorizontalScroller *scroller = [[AKBHorizontalScroller alloc] initWithFrame:CGRectMake(0, 225, self.view.bounds.size.width, 80)];
    _chainScroller = scroller;
    _chainScroller.dataSource = self;
    _chainScroller.delegate = self;
    _chainScroller.pagingEnabled = NO;
    [self.view addSubview:_chainScroller];
}

- (void)initDeleteButton
{
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteButton = deleteButton;
    _deleteButton.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _deleteButton.backgroundColor = [UIColor colorWithHue:9.2 saturation:.8 brightness:.9 alpha:1.0];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(initAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteButton];
}

- (void)initAlertView
{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete Badge!" message:@"Are you sure you want to delete this badge?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [deleteAlert show];
}

#pragma mark - Action methods
- (void)cancel
{
    for (NSInvocation *undoAction in _chainScrollerUndoStack) {
        [undoAction invoke];
    }
    
    [self.delegate badgeDetailsViewControllerDidCancel:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save
{
    // Check to see if we are adding a new badge, or editing a previously existing one.
    if (!self.badge) {
        AKBBadge *newBadge = [[AKBBadge alloc] initWithTitle:_titleTextField.text];
        self.badge = newBadge;
        newBadge.activeDays = _activeDayControl.activeDays;
        [[AKBDataManager sharedInstance] addBadge:newBadge];
    } else {
        if (![self.badge.title isEqualToString:_titleTextField.text]) {
            self.badge.title = _titleTextField.text;
        }
        self.badge.activeDays = _activeDayControl.activeDays;
    }
    
    [self.delegate badgeDetailsViewControllerDidSave:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)delete
{
    [[AKBDataManager sharedInstance] removeBadge:self.badge];
    
    [self.delegate badgeDetailsViewControllerDidDelete:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadInterface
{
    [_chainScroller reloadData];
}

#pragma mark - Horizontal scroller data source methods
- (NSInteger)numberOfViewsForHorizontalScroller:(AKBHorizontalScroller *)horizontalScroller
{
    return self.badge.allDays.count;
}

- (CGFloat)initialXOffsetForHorizontalScroller:(AKBHorizontalScroller *)horizontalScroller
{
    // The default offset value that scrolls to the end of the chain scroller if there isn't a preset offset from scrolling.
    if (!_scrollerXOffset) {
        _scrollerXOffset = horizontalScroller.contentSize.width - horizontalScroller.bounds.size.width;
    }
    
    return _scrollerXOffset;
}

- (UIView *)horizontalScroller:(AKBHorizontalScroller *)horizontalScroller viewForIndex:(NSInteger)index
{
    AKBDay *day = [self.badge.allDays objectAtIndex:index];
    
    AKBChainView *chainView = [[AKBChainView alloc] initWithFrame:CGRectMake(0, 0, _chainScroller.bounds.size.height, _chainScroller.bounds.size.height) day:day];
    
    return chainView;
}

#pragma mark - Horizontal scroller delegate methods
- (void)horizontalScroller:(AKBHorizontalScroller *)horizontalScroller clickedViewAtIndex:(NSInteger)index
{
    NSLog(@"Clicked view at index: %i", index);
    
    _selectedDay = [self.badge.allDays objectAtIndex:index];
    AKBDayState state = _selectedDay.state;
    
    // Create an invocation to add to the undo stack to potentially undo changes made through the chain scroller.
    NSMethodSignature *signature = [_selectedDay methodSignatureForSelector:@selector(setState:)];
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:signature];
    [undoAction setTarget:_selectedDay];
    [undoAction setSelector:@selector(setState:)];
    [undoAction setArgument:&state atIndex:2];
    [undoAction retainArguments];
    [_chainScrollerUndoStack addObject:undoAction];
    
    NSString *buttonTitle1;
    NSString *buttonTitle2;
    
    // Create the action sheet button titles depending on the current state of the selected day.
    if (_selectedDay.state == AKBDayStateMissed) {
        buttonTitle1 = @"Complete";
        buttonTitle2 = @"Inactive";
    } else if (_selectedDay.state == AKBDayStateComplete) {
        buttonTitle1 = @"Missed";
        buttonTitle2 = @"Inactive";
    } else if (_selectedDay.state == AKBDayStateInactive) {
        buttonTitle1 = @"Missed";
        buttonTitle2 = @"Complete";
    }
    
    UIActionSheet *dayStateSheet = [[UIActionSheet alloc] initWithTitle:@"Set day to..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:buttonTitle1, buttonTitle2, nil];
    [dayStateSheet showInView:_chainScroller];
}

#pragma mark - Horizontal scroller's superview delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Store the offset every time the horizontal scroller finishes scrolling to leave it fixed every time it reloads.
    _scrollerXOffset = scrollView.contentOffset.x;
}

#pragma mark - Alert view delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    } else if (buttonIndex == 1) {
        [self delete];
    }
}

#pragma mark - Action sheet delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Missed"]) {
        _selectedDay.state = AKBDayStateMissed;
    } else if ([buttonTitle isEqualToString:@"Complete"]) {
        _selectedDay.state = AKBDayStateComplete;
    } else if ([buttonTitle isEqualToString:@"Inactive"]) {
        _selectedDay.state = AKBDayStateInactive;
    }
    
    [_chainScroller reloadData];
}

#pragma mark - Text field delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
