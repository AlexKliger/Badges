//
//  BTActiveDayControl.h
//  BadgeTracker
//
//  Created by Alex Kliger on 8/27/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKBBadge.h"

@interface AKBActiveDayControl : UIView

- (id)initWithFrame:(CGRect)frame activeDays:(AKBBadgeActiveDays)activeDays;

@property (nonatomic) AKBBadgeActiveDays activeDays;

@end