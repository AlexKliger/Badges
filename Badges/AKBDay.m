//
//  BTDay.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/18/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBDay.h"

@implementation AKBDay

- (id)initWithDate:(NSDate *)date state:(AKBDayState)state
{
    self = [super init];
    if (self) {
        _state = state;
        _date = date;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _state = [[aDecoder decodeObjectForKey:@"state"] integerValue];
        _date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

#pragma mark - NSCoding protocol methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.state] forKey:@"state"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

@end
