//
//  BTChainView.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/22/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBChainView.h"
#import "AKBBackgroundView.h"
#import "AKBDay.h"

@implementation AKBChainView
{
    __weak AKBDay *_day;
    
    __weak UILabel *_dateLabel;
}

- (id)initWithFrame:(CGRect)frame day:(AKBDay *)day
{
    self = [super initWithFrame:frame];
    if (self) {
        _day = day;
        self.opaque = NO;
        [self initDateLabel];
    }
    return self;
}

- (void)initDateLabel
{
    // Set up the date formatter.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:_day.date];
    
    // Set up the date label.
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 3)];
    _dateLabel = dateLabel;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.text = dateString;
    [self addSubview:_dateLabel];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw the background gradient.
    UIColor *startColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    UIColor *endColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    // Draw the chain circle.
    CGRect circleRect = rect;
    circleRect.size.height = circleRect.size.height - CGRectGetHeight(_dateLabel.frame);
    circleRect.size.width = circleRect.size.height;
    circleRect.origin.x = (rect.size.width - circleRect.size.width) / 2;
    circleRect.origin.y = CGRectGetMaxY(_dateLabel.frame);
    
    UIColor *color;
    
    switch (_day.state) {
        case AKBDayStateMissed:
            color = [UIColor blackColor];
            break;
        case AKBDayStateComplete:
            color = [UIColor yellowColor];
            break;
        case AKBDayStateInactive:
            color = [UIColor grayColor];
            break;
        default:
            break;
    }
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, circleRect);
    CGContextRestoreGState(context);
}

@end
