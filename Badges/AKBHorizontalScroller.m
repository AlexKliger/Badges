//
//  BTHorizontalScroller.m
//  BadgeTracker
//
//  Created by Alex Kliger on 9/3/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBHorizontalScroller.h"

@implementation AKBHorizontalScroller
{
    CGFloat _previousOffset;
}

#pragma mark - Page scroller lifecycle methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(horizontalScrollerTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        self.pagingEnabled = YES;
    }
    return self;
}

- (void)reloadData
{
    if (self.dataSource == nil) {
        return;
    }
    
    // Remove all views from the scroll view.
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // Retrieve the new views.
    CGFloat xVal = 0;
    for (int i = 0; i < [self.dataSource numberOfViewsForHorizontalScroller:self]; i++) {
        UIView *newView = [self.dataSource horizontalScroller:self viewForIndex:i];
        newView.frame = CGRectMake(xVal, 0, newView.bounds.size.width, newView.bounds.size.height);
        [self addSubview:newView];
        xVal += newView.bounds.size.width;
    }
    
    [self setContentSize:CGSizeMake(xVal, self.bounds.size.height)];
    
    if ([self.dataSource respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)]) {
        NSInteger initialIndex = [self.dataSource initialViewIndexForHorizontalScroller:self];
        CGFloat xOffset = MIN(self.bounds.size.width * initialIndex, self.contentSize.width - self.bounds.size.width);
        [self setContentOffset:CGPointMake(xOffset, 0) animated:NO];
    } else if ([self.dataSource respondsToSelector:@selector(initialXOffsetForHorizontalScroller:)]) {
        CGFloat xOffset = MIN([self.dataSource initialXOffsetForHorizontalScroller:self], self.contentSize.width - self.bounds.size.width);
        [self setContentOffset:CGPointMake(xOffset, 0) animated:NO];
    }
}

- (void)didMoveToSuperview
{
    [self reloadData];
}

#pragma mark - Gesture methods

- (void)horizontalScrollerTapped:(UITapGestureRecognizer *)gesture;
{
    CGPoint location = [gesture locationInView:gesture.view];
    
    // Hit-test the subviews in the scroller.
    for (int i = 0; i < [self.dataSource numberOfViewsForHorizontalScroller:self]; i++) {
        UIView *view = [self.subviews objectAtIndex:i];
        if (CGRectContainsPoint(view.frame, location)) {
            if ([self.delegate respondsToSelector:@selector(horizontalScroller:clickedViewAtIndex:)]) {
                [self.delegate horizontalScroller:self clickedViewAtIndex:i];
            }
        }
    }
}

#pragma mark - Accessor methods
- (int)currentIndex
{
    int currentIndex = self.contentOffset.x / self.bounds.size.width;
    return currentIndex;
}

- (void)setCurrentIndex:(int)currentIndex animated:(BOOL)animated
{
    CGFloat xOffset = MIN(self.bounds.size.width * currentIndex, self.contentSize.width - self.bounds.size.width);
    
    [self setContentOffset:CGPointMake(xOffset, 0) animated:animated];
}

- (void)setCurrentIndex:(int)currentIndex
{
    [self setCurrentIndex:currentIndex animated:NO];
}

@end
