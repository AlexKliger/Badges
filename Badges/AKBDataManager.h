//
//  BTDataManager.h
//  BadgeTracker
//
//  Created by Alex Kliger on 8/11/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBBadge.h"
#import <Foundation/Foundation.h>

@class AKBBadge;

@interface AKBDataManager : NSObject

+ (AKBDataManager *)sharedInstance;

- (NSMutableArray *)getBadges;
- (void)addBadge:(AKBBadge *)badge;
- (void)removeBadge:(AKBBadge *)badge;
- (void)removeBadgeAtIndex:(NSUInteger)index;
- (void)saveBadges;

@end
