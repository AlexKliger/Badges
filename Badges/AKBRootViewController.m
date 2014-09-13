//
//  BTRootViewController.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/11/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

// Controllers
#import "AKBRootViewController.h"
#import "AKBBadgeDetailsViewController.h"
#import "AKBGraphViewController.h"
// Views
#import "AKBBackgroundView.h"
#import "AKBHorizontalScroller.h"
#import "AKBContainerView.h"
#import "AKBBadgeView.h"
// Models
#import "AKBDataManager.h"

#define kEditButton 0
#define kAddButton 1

@interface AKBRootViewController () <AKBHorizontalScrollerDataSource, AKBHorizontalScrollerDelegate, AKBBadgeDetailsViewControllerDelegate, AKBGraphViewControllerDelegate>
{
    __weak NSMutableArray *_badges;
    
    NSUInteger _startingIndex;
    NSMutableArray *_undoStack;
    NSTimer *_updateTimer; // The timer is simply for demonstration purposes, since the badges are intended to only update once per day.
    
    __weak AKBHorizontalScroller *_pageScroller;
    
    __weak NSMutableArray *_toolbarItems;
    __weak UIPageControl *_pageControl;
    UIBarButtonItem *_resetButton;
    UIBarButtonItem *_undoButton;
    
}
@end

@implementation AKBRootViewController

#pragma mark - View controller lifecyle methods
- (id)init
{
    self = [super init];
    if (self) {
        _badges = [[AKBDataManager sharedInstance] getBadges];
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(updateBadges) userInfo:nil repeats:YES]; // Set up a timer that adds a day to the badges for every given time interval
        _startingIndex = 0;
    }
    return self;
}

- (void)loadView
{
    // Load a custom background.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.view = [[AKBBackgroundView alloc] initWithFrame:screenRect];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.translucent = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    // Set up the interface
    [self initToolbarItems];
    [self initNavigationItem];
    [self initPageScroller];
    
    [self reloadInterface];
}

#pragma mark - Subview initialization methods
- (void)initNavigationItem
{
    // Set up the navigation item.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(presentBadgeDetailsViewController:)];
    self.navigationItem.leftBarButtonItem.tag = kEditButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentBadgeDetailsViewController:)];
    self.navigationItem.rightBarButtonItem.tag = kAddButton;
}

- (void)initToolbarItems
{
    // Set up the toolbar items
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _pageControl = pageControl;
    _pageControl.numberOfPages = _badges.count;
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *barPageControl = [[UIBarButtonItem alloc] initWithCustomView:pageControl];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _resetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(resetBadge)];
    _undoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(resetBadge)];
    _toolbarItems = [NSMutableArray arrayWithObjects:flexibleSpace, barPageControl, flexibleSpace, _resetButton, nil];
    self.toolbarItems = _toolbarItems;
}

- (void)initPageScroller
{
    // Set up the page scroller.
    AKBHorizontalScroller *pageScroller = [[AKBHorizontalScroller alloc] initWithFrame:self.view.bounds];
    _pageScroller = pageScroller;
    _pageScroller.dataSource = self;
    _pageScroller.delegate = self;
    [self.view addSubview:_pageScroller];
}

#pragma mark - Action methods
- (void)presentBadgeDetailsViewController:(UIBarButtonItem *)sender
{
    AKBBadgeDetailsViewController *detailsController = [[AKBBadgeDetailsViewController alloc] init];
    detailsController.delegate = self;
        
    // Depending on which button in the navigation bar was pressed, edit an existing badge or simply present the details controller to create a new one.
    if (sender.tag == kEditButton) {
        if (_badges.count == 0) {
            return;
        }
        AKBBadge *badge = [_badges objectAtIndex:_pageScroller.currentIndex];
        detailsController.badge = badge;
        detailsController.title = badge.title;
    } else if (sender.tag == kAddButton) {
        detailsController.title = @"New Badge";
    }
    
    [self.navigationController pushViewController:detailsController animated:YES];
}

- (void)resetBadge
{
    if (_badges.count == 0) {
        return;
    }
    
    AKBBadge *badge = [_badges objectAtIndex:_pageScroller.currentIndex];
    
    [badge toggleReset];
    
    [_pageScroller reloadData];
    [self reloadInterface];
}

- (void)updateBadges
{
    for (AKBBadge *badge in _badges) {
        [badge addNewDay];
    }
    
    [_pageScroller reloadData];
    [self reloadInterface];
    
    NSLog(@"Badges updated");
}

- (void)changePage:(UIPageControl *)pageControl
{
    [_pageScroller setCurrentIndex:pageControl.currentPage animated:YES];
}

#pragma mark - Convenience methods
- (void)reloadInterface
{
    AKBBadge *badge;
    
    if (_badges.count > 0) {
        badge = [_badges objectAtIndex:_pageScroller.currentIndex];
    }
    
    self.title = badge.title;
    _pageControl.numberOfPages = _badges.count;
    _pageControl.currentPage = _pageScroller.currentIndex;
    if (badge.wasReset) {
        [_toolbarItems replaceObjectAtIndex:[_toolbarItems indexOfObject:_toolbarItems.lastObject] withObject:_undoButton];
        [self.navigationController.toolbar setItems:_toolbarItems animated:YES];
    } else if (!badge.wasReset | (badge == nil)) {
        [_toolbarItems replaceObjectAtIndex:[_toolbarItems indexOfObject:_toolbarItems.lastObject] withObject:_resetButton];
        [self.navigationController.toolbar setItems:_toolbarItems animated:YES];
    }
}

#pragma mark - Horizontal scroller data source methods
- (NSInteger)numberOfViewsForHorizontalScroller:(AKBHorizontalScroller *)pageScroller
{
    return _badges.count;
}


- (NSInteger)initialViewIndexForHorizontalScroller:(AKBHorizontalScroller *)pageScroller
{
    return _startingIndex;
}

- (UIView *)horizontalScroller:(AKBHorizontalScroller *)horizontalScroller viewForIndex:(NSInteger)index
{
    if (((NSMutableArray *)[[AKBDataManager sharedInstance] getBadges]).count > 0) {
        AKBBadge *badge = [_badges objectAtIndex:index];
        
        // Set up the container view
        AKBContainerView *containerView = [[AKBContainerView alloc] initWithFrame:_pageScroller.bounds];
        // Set up the text labels
        containerView.topLabel.text = [NSString stringWithFormat:@"Current streak: %i day(s)", [badge currentStreak].count];
        containerView.bottomLabel.text = [NSString stringWithFormat:@"Total streaks: %i streak(s)", [badge allStreaks].count];
        // Set up the badge view
        AKBBadgeView *badgeView = [[AKBBadgeView alloc] initWithBadge:badge];
        containerView.contentView = badgeView;
        
        return containerView;
    } else { // Return an empty view if the badges array is empty
        UIView *aView = [[UIView alloc] init];
        return aView;
    }
}

#pragma mark - Horizontal scroller delegate methods
- (void)horizontalScroller:(AKBHorizontalScroller *)horizontalScroller clickedViewAtIndex:(int)index
{
    NSLog(@"Clicked view at index: %i", index);
    
    AKBGraphViewController *graphController = [[AKBGraphViewController alloc] init];
    graphController.delegate = self;
    graphController.badge = [_badges objectAtIndex:index];
    
    // Create a custom transition animation.
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [self.navigationController pushViewController:graphController animated:NO];
                    }
                    completion:nil];
}

#pragma mark - Horizontal scroller superclass delegate methods
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    AKBHorizontalScroller *pageScroller;
    
    if (scrollView == _pageScroller) {
        pageScroller = (AKBHorizontalScroller *)scrollView;
    }
    
    NSLog(@"Scrolled to view at index: %i", pageScroller.currentIndex);
    [self reloadInterface];
    _startingIndex = _pageScroller.currentIndex;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    AKBHorizontalScroller *pageScroller;
    
    if (scrollView == _pageScroller) {
        pageScroller = (AKBHorizontalScroller *)scrollView;
    }
    
    NSLog(@"Scroll view did end decelerating to index: %i", pageScroller.currentIndex);
    [self reloadInterface];
    _startingIndex = _pageScroller.currentIndex;
}

#pragma mark - Badge details view controller delegate methods
- (void)badgeDetailsViewControllerDidCancel:(AKBBadgeDetailsViewController *)detailsController
{
    NSLog(@"badgeDetailsViewControllerDidCancel, badge count:%i", _badges.count);
    // Update the interface.
    [self.navigationController setToolbarHidden:NO animated:NO];
    [_pageScroller reloadData];
    [self reloadInterface];
}

- (void)badgeDetailsViewControllerDidSave:(AKBBadgeDetailsViewController *)detailsController
{
    NSLog(@"badgeDetailsViewControllerDidSave, title: %@", detailsController.badge.title);
    
    // Set the starting index to the index of the saved badge.
    _startingIndex = [_badges indexOfObject:detailsController.badge];
    // Update the interface.
    [self.navigationController setToolbarHidden:NO animated:NO];
    [_pageScroller reloadData];
    [self reloadInterface];
}

- (void)badgeDetailsViewControllerDidDelete:(AKBBadgeDetailsViewController *)detailsController
{
    // Update the interface.
    [self.navigationController setToolbarHidden:NO animated:NO];
    [_pageScroller reloadData];
    [self reloadInterface];
}

#pragma mark - Graph view controller delegate methods
- (void)graphViewControllerDidDismiss:(AKBGraphViewController *)graphController
{
    [self.navigationController setToolbarHidden:NO animated:NO];
    // Update the interface.
    [_pageScroller reloadData];
    [self reloadInterface];
}

@end
