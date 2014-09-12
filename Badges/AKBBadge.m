//
//  BTBadge.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/11/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBBadge.h"

#define kSunday 1
#define kMonday 2
#define kTuesday 3
#define kWednesday 4
#define kThursday 5
#define kFriday 6
#define kSaturday 7


@implementation AKBBadge

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _title = title;
        _allDays = [NSMutableArray array];
        _activeDays = (Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday);
        _wasReset = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _allDays = [aDecoder decodeObjectForKey:@"allDays"];
        _activeDays = [self activeDaysBitMaskFromArray:[aDecoder decodeObjectForKey:@"activeDays"]];
        _wasReset = [[aDecoder decodeObjectForKey:@"wasReset"] boolValue];
    }
    return self;
}

- (void)addNewDay
{
    NSDate *todaysDate = [NSDate date];
    AKBDay *newDay;
    
    AKBDayState state;
    // If the badge was reset, set the state to a missed day.
    if (self.wasReset) {
        _wasReset = NO;
        state = AKBDayStateMissed;
    } else {
        state = AKBDayStateComplete;
    }
    
    // Determine the current day, test whether or not it is active, then create a day object with the appropriate state.
    switch ([self dayFromDate:todaysDate]) {
        case kSunday:
            if (self.activeDays & Sunday) {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:state];
            } else {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:AKBDayStateInactive];
            }
            break;
        case kMonday:
            if (self.activeDays & Monday) {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:state];
            } else {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:AKBDayStateInactive];
            }
            break;
        case kTuesday:
            if (self.activeDays & Tuesday) {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:state];
            } else {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:AKBDayStateInactive];
            }
            break;
        case kWednesday:
            if (self.activeDays & Wednesday) {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:state];
            } else {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:AKBDayStateInactive];
            }
            break;
        case kThursday:
            if (self.activeDays & Thursday) {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:state];
            } else {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:AKBDayStateInactive];
            }
            break;
        case kFriday:
            if (self.activeDays & Friday) {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:state];
            } else {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:AKBDayStateInactive];
            }
            break;
        case kSaturday:
            if (self.activeDays & Saturday) {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:state];
            } else {
                newDay = [[AKBDay alloc] initWithDate:todaysDate state:AKBDayStateInactive];
            }
            break;
        default:
            break;
    }
    
    [self.allDays addObject:newDay];    
}

- (void)toggleReset
{
    // Set the wasReset Boolean to the opposite of its current value.
    _wasReset = !_wasReset;
}

- (NSInteger)dayFromDate:(NSDate *)date
{
    // Extract the day from the date.
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger currentDay = [components weekday];
    return currentDay;
}

- (NSMutableArray *)currentStreak
{
    // Dynamically generate the current streak
    NSMutableArray *currentStreak = [NSMutableArray array];
    
    // If the badge was reset, return an empty array.
    if (self.wasReset) {
        return currentStreak;
    }
    
    for (AKBDay *day in [self.allDays reverseObjectEnumerator]) { // Since the most recent day in the allDays array is the last object, reverse the object enumerator.
        if (day.state == AKBDayStateComplete) {
            [currentStreak addObject:day];
        } else if (day.state == AKBDayStateMissed) {
            return currentStreak;
        }
    }
    
    return currentStreak;
}

- (NSMutableArray *)allStreaks;
{
    // Dynamically generate all of the streaks.
    NSMutableArray *allStreaks = [NSMutableArray array];
    NSMutableArray *streak = [NSMutableArray array];
    
    for (AKBDay *day in self.allDays) {
        if (day.state == AKBDayStateComplete) { // Determine if the day was completed or missed.
            [streak addObject:day]; // If the day was completed, add it to the streak.
            if (streak.count == 1) { // If this is the first day of a streak, add it to the allStreaks array.
                [allStreaks addObject:streak];
            }
        } else if (day.state == AKBDayStateMissed) { // If the day was missed, skip over it and begin a new streak.
            streak = [NSMutableArray array];
        }
    }
    return allStreaks;
}



#pragma mark - NSCoding protocol methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.allDays forKey:@"allDays"];
    [aCoder encodeObject:[self activeDaysBitMaskToArray] forKey:@"activeDays"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.wasReset] forKey:@"wasReset"];
}

#pragma mark - Convenience methods
- (NSMutableArray *)activeDaysBitMaskToArray
{
    // Convert the active days enum bit mask to an array for storage.
    NSMutableArray *activeDays = [NSMutableArray array];
    //NSNumber *activeState;
    
    if (self.activeDays & Sunday) {
        NSNumber *activeState = [NSNumber numberWithBool:YES];
        [activeDays addObject:activeState];
    } else {
        NSNumber *activeState = [NSNumber numberWithBool:NO];
        [activeDays addObject:activeState];
    }
    
    if (self.activeDays & Monday) {
        NSNumber *activeState = [NSNumber numberWithBool:YES];
        [activeDays addObject:activeState];
    } else {
        NSNumber *activeState = [NSNumber numberWithBool:NO];
        [activeDays addObject:activeState];
    }
    
    if (self.activeDays & Tuesday) {
        NSNumber *activeState = [NSNumber numberWithBool:YES];
        [activeDays addObject:activeState];
    } else {
        NSNumber *activeState = [NSNumber numberWithBool:NO];
        [activeDays addObject:activeState];
    }
    
    if (self.activeDays & Wednesday) {
        NSNumber *activeState = [NSNumber numberWithBool:YES];
        [activeDays addObject:activeState];
    } else {
        NSNumber *activeState = [NSNumber numberWithBool:NO];
        [activeDays addObject:activeState];
    }
    
    if (self.activeDays & Thursday) {
        NSNumber *activeState = [NSNumber numberWithBool:YES];
        [activeDays addObject:activeState];
    } else {
        NSNumber *activeState = [NSNumber numberWithBool:NO];
        [activeDays addObject:activeState];
    }
    
    if (self.activeDays & Friday) {
        NSNumber *activeState = [NSNumber numberWithBool:YES];
        [activeDays addObject:activeState];
    } else {
        NSNumber *activeState = [NSNumber numberWithBool:NO];
        [activeDays addObject:activeState];
    }
    
    if (self.activeDays & Saturday) {
        NSNumber *activeState = [NSNumber numberWithBool:YES];
        [activeDays addObject:activeState];
    } else {
        NSNumber *activeState = [NSNumber numberWithBool:NO];
        [activeDays addObject:activeState];
    }
        
    return activeDays;
}

- (AKBBadgeActiveDays)activeDaysBitMaskFromArray:(NSMutableArray *)activeDaysArray;
{
    // Convert the unarchived active days array to a bitmask.
    AKBBadgeActiveDays activeDays;
    
    for (int i = 0; i < 7; i++) {
        NSNumber *activeState = [activeDaysArray objectAtIndex:i];
        switch (i) {
            case 0:
                if ([activeState boolValue]) {
                    activeDays = activeDays | Sunday;
                }
                break;
            case 1:
                if ([activeState boolValue]) {
                    activeDays = activeDays | Monday;
                }
                break;
            case 2:
                if ([activeState boolValue]) {
                    activeDays = activeDays | Tuesday;
                }
                break;
            case 3:
                if ([activeState boolValue]) {
                    activeDays = activeDays | Wednesday;
                }
                break;
            case 4:
                if ([activeState boolValue]) {
                    activeDays = activeDays | Thursday;
                }
                break;
            case 5:
                if ([activeState boolValue]) {
                    activeDays = activeDays | Friday;
                }
                break;
            case 6:
                if ([activeState boolValue]) {
                    activeDays = activeDays | Saturday;
                }
                break;
            default:
                break;
        }
    }
    
    return activeDays;
}

@end
