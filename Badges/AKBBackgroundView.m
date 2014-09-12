//
//  BTBackgroundView.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/29/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBBackgroundView.h"

void drawPattern(void *info, CGContextRef context)
{
    UIColor *lineColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0];
    UIColor *shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor.CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 20, 20);
    CGContextStrokePath(context);
}

@implementation AKBBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.20 alpha:1.0];
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternCallbacks callbacks = {0, &drawPattern, NULL};
    
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           rect,
                                           CGAffineTransformIdentity,
                                           20,
                                           20,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGContextFillRect(context, rect);
    CGPatternRelease(pattern);
    CGContextRestoreGState(context);
}

@end
