//
//  BTDataManager.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/11/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBBadge.h"
#import "AKBDataManager.h"

@implementation AKBDataManager
{
    NSMutableArray *_badges;
}

+ (AKBDataManager *)sharedInstance
{
    static AKBDataManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AKBDataManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _badges = [NSMutableArray array];
        NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/badges.bin"]];
        NSArray *rawArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (AKBBadge *badge in rawArray) {
            [_badges addObject:badge];
        }
        
        [self initStaticBadges];
    }
    return self;
}

- (void)initStaticBadges
{
    AKBBadge *badge = [[AKBBadge alloc] initWithTitle:@"Junk food"];
    
    NSTimeInterval secondsInDay = 86400;
    
    for (int i = 0; i < 23; i++) {
        if (i <= 3) { // Four day streak
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateComplete];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i == 4) { // Missed day
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateMissed];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i > 4 && i <= 8) { // Four day streak
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateComplete];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i == 9) { // Missed day
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateMissed];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i > 9 && i <= 12) { // Three day streak
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateComplete];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i == 13) { // Missed day
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateMissed];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i > 13 && i <= 16) { // Three day streak
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateComplete];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i == 17) { // Missed day
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateMissed];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i > 17 && i <= 20) { // Three day streak
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateComplete];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i == 21) { // Missed day
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateMissed];
            [badge.allDays insertObject:day atIndex:0];
        } else if (i == 22) { // One day streak
            AKBDay *day = [[AKBDay alloc] initWithDate:[NSDate dateWithTimeInterval:(-secondsInDay * i) sinceDate:[NSDate date]] state:AKBDayStateComplete];
            [badge.allDays insertObject:day atIndex:0];
        }
    }
    
    [_badges addObject:badge];
}

- (NSMutableArray *)getBadges
{
    return _badges;
}

- (void)addBadge:(AKBBadge *)badge
{
    [_badges addObject:badge];
}

- (void)removeBadge:(AKBBadge *)badge
{
    [_badges removeObject:badge];
}

- (void)removeBadgeAtIndex:(NSUInteger)index
{
    [_badges removeObjectAtIndex:index];
}

- (void)saveBadges
{
    NSString *fileName = [NSHomeDirectory() stringByAppendingString:@"/Documents/badges.bin"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_badges];
    [data writeToFile:fileName atomically:YES];
}

@end
