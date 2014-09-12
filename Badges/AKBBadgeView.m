//
//  BTBadgeView.m
//  BadgeTracker
//
//  Created by Alex Kliger on 9/4/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBBadgeView.h"
#import "AKBBadge.h"

@implementation AKBBadgeView
{
    __weak AKBBadge *_badge;
    
    __weak UILabel *_streakLabel;
}

- (id)initWithBadge:(AKBBadge *)badge
{
    self = [super init];
    if (self) {
        _badge = badge;
        self.opaque = NO;
    }
    return self;
}

- (void)didMoveToSuperview
{
    [self initStreakLabel];
}

- (void)initStreakLabel
{
    UILabel *streakLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _streakLabel = streakLabel;
    _streakLabel.textAlignment = NSTextAlignmentCenter;
    _streakLabel.font = [UIFont systemFontOfSize:60];
    _streakLabel.text = [NSString stringWithFormat:@"%i", [[_badge currentStreak] count]];
    [self addSubview:_streakLabel];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat rectSide = MIN(rect.size.width, rect.size.height);
    
    CGRect badgeRect = CGRectMake((rect.size.width - rectSide) / 2, (rect.size.height - rectSide) / 2, rectSide, rectSide);
    badgeRect = CGRectInset(badgeRect, 8, 8);
    UIColor *badgeColor = [UIColor yellowColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, badgeColor.CGColor);
    CGContextSetShadow(context, CGSizeMake(-3, 6), 0);
    CGContextFillEllipseInRect(context, badgeRect);
    CGContextRestoreGState(context);
}

@end
