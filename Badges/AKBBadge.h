//
//  BTBadge.h
//  BadgeTracker
//
//  Created by Alex Kliger on 8/11/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKBDay.h"

@interface AKBBadge : NSObject <NSCoding>

typedef NS_OPTIONS(NSUInteger, AKBBadgeActiveDays) {
    None         = 0,
    Sunday      = 1 << 0,
    Monday      = 1 << 1,
    Tuesday     = 1 << 2,
    Wednesday   = 1 << 3,
    Thursday    = 1 << 4,
    Friday      = 1 << 5,
    Saturday    = 1 << 6
};

@property (strong, nonatomic) NSString *title;

/**
 An array that holds each BTDay object since the creation of the badge. The last object in the array is the most recent day.
 */
@property (strong, nonatomic) NSMutableArray *allDays;

/**
 A bitmask that represents whether or not a badge should create an active BTDay object for a given day of the week. The default bitmask contains each day of the week.
 */
@property (nonatomic) AKBBadgeActiveDays activeDays;

/**
 Containes a Boolean indicating whether the badge was reset and should add a BTDay object with its state set to 'missed' the next time it updates. The default value is 'NO'.
 */
@property (readonly, nonatomic) BOOL wasReset;

- (id)initWithTitle:(NSString *)title;
- (void)addNewDay;
- (void)toggleReset;
- (NSMutableArray *)currentStreak;
- (NSMutableArray *)allStreaks;

@end
