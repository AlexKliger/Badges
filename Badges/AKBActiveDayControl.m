//
//  BTActiveDayControl.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/27/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBActiveDayControl.h"

#define kSunday 0
#define kMonday 1
#define kTuesday 2
#define kWednesday 3
#define kThursday 4
#define kFriday 5
#define kSaturday 6

@implementation AKBActiveDayControl

- (id)initWithFrame:(CGRect)frame activeDays:(AKBBadgeActiveDays)activeDays
{
    self = [super initWithFrame:frame];
    if (self) {
        if (activeDays) {
            self.activeDays = activeDays;
        } else {
            self.activeDays = (Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday);
        }
        
        [self reloadButtons];
    }
    return self;
}

- (void)reloadButtons
{
    NSArray *weekdays = [NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat xVal = 0;
    for (int i = 0; i < 7; i++) {
        UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeSystem];
        dayButton.tag = i;
        dayButton.backgroundColor = [UIColor redColor];
        [dayButton setTitle:[weekdays objectAtIndex:i] forState:UIControlStateNormal];
        [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dayButton.frame = CGRectMake(xVal, 0, self.bounds.size.width / 7, self.bounds.size.height);
        [dayButton addTarget:self action:@selector(toggleActiveDay:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dayButton];
        xVal += dayButton.bounds.size.width;
    }
    
    if (self.activeDays & Sunday) {
        ((UIButton *)[self.subviews objectAtIndex:kSunday]).backgroundColor = [UIColor blueColor];
    }
    if (self.activeDays & Monday) {
        ((UIButton *)[self.subviews objectAtIndex:kMonday]).backgroundColor = [UIColor blueColor];
    }
    if (self.activeDays & Tuesday) {
        ((UIButton *)[self.subviews objectAtIndex:kTuesday]).backgroundColor = [UIColor blueColor];
    }
    if (self.activeDays & Wednesday) {
        ((UIButton *)[self.subviews objectAtIndex:kWednesday]).backgroundColor = [UIColor blueColor];
    }
    if (self.activeDays & Thursday) {
        ((UIButton *)[self.subviews objectAtIndex:kThursday]).backgroundColor = [UIColor blueColor];
    }
    if (self.activeDays & Friday) {
        ((UIButton *)[self.subviews objectAtIndex:kFriday]).backgroundColor = [UIColor blueColor];
    }
    if (self.activeDays & Saturday) {
        ((UIButton *)[self.subviews objectAtIndex:kSaturday]).backgroundColor = [UIColor blueColor];
    }
    
}

- (void)toggleActiveDay:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            if (self.activeDays & Sunday) {
                self.activeDays = self.activeDays & ~Sunday;
            } else {
                self.activeDays = self.activeDays | Sunday;
            }
            break;
        case 1:
            if (self.activeDays & Monday) {
                self.activeDays = self.activeDays & ~Monday;
            } else {
                self.activeDays = self.activeDays | Monday;
            }
            break;
        case 2:
            if (self.activeDays & Tuesday) {
                self.activeDays = self.activeDays & ~Tuesday;
            } else {
                self.activeDays = self.activeDays | Tuesday;
            }
            break;
        case 3:
            if (self.activeDays & Wednesday) {
                self.activeDays = self.activeDays & ~Wednesday;
            } else {
                self.activeDays = self.activeDays | Wednesday;
            }
            break;
        case 4:
            if (self.activeDays & Thursday) {
                self.activeDays = self.activeDays & ~Thursday;
            } else {
                self.activeDays = self.activeDays | Thursday;
            }
            break;
        case 5:
            if (self.activeDays & Friday) {
                self.activeDays = self.activeDays & ~Friday;
            } else {
                self.activeDays = self.activeDays | Friday;
            }
            break;
        case 6:
            if (self.activeDays & Saturday) {
                self.activeDays = self.activeDays & ~Saturday;
            } else {
                self.activeDays = self.activeDays | Saturday;
            }
            break;
        default:
            break;
    }
    
    [self reloadButtons];
}

@end
