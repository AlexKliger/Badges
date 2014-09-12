//
//  BTDay.h
//  BadgeTracker
//
//  Created by Alex Kliger on 8/18/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKBDay : NSObject <NSCoding>

typedef NS_ENUM(NSInteger, AKBDayState) {
    AKBDayStateMissed,
    AKBDayStateComplete,
    AKBDayStateInactive
};

@property (nonatomic) AKBDayState state;
@property (strong, nonatomic) NSDate *date;

- (id)initWithDate:(NSDate *)date state:(AKBDayState)state;

@end
