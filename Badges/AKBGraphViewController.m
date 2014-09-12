//
//  BTGraphViewController.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/22/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

// Controllers
#import "AKBGraphViewController.h"
#import "AKBBarGraphChildController.h"
#import "AKBScatterGraphChildController.h"
// Views
#import "AKBBackgroundView.h"
#import "AKBHorizontalScroller.h"
#import "AKBChainView.h"
// Models
#import "AKBDataManager.h"

@interface AKBGraphViewController ()
{
    __weak AKBHorizontalScroller *_chainScroller;
    __weak AKBDay *_selectedDay;
}
@end

@implementation AKBGraphViewController

#pragma mark - View controller lifecycle methods
- (id)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissGraphViewController)];
        [self.view addGestureRecognizer:tapRecognizer];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.badge.title;
    self.navigationItem.hidesBackButton = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [self initChildControllers];
}

#pragma mark - Subview initialization methods
- (void)initChildControllers
{
    // Set up the bar graph child view controller
    AKBBarGraphChildController *barGraphController = [[AKBBarGraphChildController alloc] initWithBadge:self.badge];
    [self addChildViewController:barGraphController];
    barGraphController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2);
    [self.view addSubview:barGraphController.view];
    // Set up the scatter graph child view controller
    AKBScatterGraphChildController *scatterGraphController = [[AKBScatterGraphChildController alloc] initWithBadge:_badge];
    [self addChildViewController:scatterGraphController];
    scatterGraphController.view.frame = CGRectMake(0, CGRectGetMaxY(barGraphController.view.frame), self.view.bounds.size.width, self.view.bounds.size.height/2);
    [self.view addSubview:scatterGraphController.view];
}

#pragma mark - Gesture methods
- (void)dismissGraphViewController
{
    [self.delegate graphViewControllerDidDismiss:self];
    
    // Create a custom transition animaiton.
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    completion:nil];
}

@end
