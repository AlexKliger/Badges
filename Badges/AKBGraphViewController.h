//
//  BTGraphViewController.h
//  BadgeTracker
//
//  Created by Alex Kliger on 8/22/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKBBadge;
@protocol AKBGraphViewControllerDelegate;

@interface AKBGraphViewController : UIViewController

@property (weak, nonatomic) AKBBadge *badge;
@property (weak, nonatomic) id<AKBGraphViewControllerDelegate>delegate;

@end

@protocol AKBGraphViewControllerDelegate <NSObject>

- (void)graphViewControllerDidDismiss:(AKBGraphViewController *)graphController;

@end