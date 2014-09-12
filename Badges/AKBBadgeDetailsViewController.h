//
//  BTBadgeDetailsViewController.h
//  BadgeTracker
//
//  Created by Alex Kliger on 8/14/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKBBadge;
@protocol AKBBadgeDetailsViewControllerDelegate;

@interface AKBBadgeDetailsViewController : UIViewController

@property (weak) id<AKBBadgeDetailsViewControllerDelegate>delegate;
@property (weak, nonatomic) AKBBadge *badge;

@end

@protocol AKBBadgeDetailsViewControllerDelegate <NSObject>

- (void)badgeDetailsViewControllerDidCancel:(AKBBadgeDetailsViewController *)detailsController;
- (void)badgeDetailsViewControllerDidSave:(AKBBadgeDetailsViewController *)detailsController;
- (void)badgeDetailsViewControllerDidDelete:(AKBBadgeDetailsViewController *)detailsController;

@end