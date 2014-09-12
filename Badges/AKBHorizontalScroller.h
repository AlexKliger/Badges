//
//  BTHorizontalScroller.h
//  BadgeTracker
//
//  Created by Alex Kliger on 9/3/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKBHorizontalScrollerDataSource;
@protocol AKBHorizontalScrollerDelegate;

@interface AKBHorizontalScroller : UIScrollView

@property (weak) id<AKBHorizontalScrollerDataSource>dataSource;
@property (nonatomic, assign) id<AKBHorizontalScrollerDelegate, UIScrollViewDelegate>delegate;
@property (nonatomic, readonly) int currentIndex;

- (void)reloadData;
- (void)setCurrentIndex:(int)currentIndex animated:(BOOL)animated;

@end

@protocol AKBHorizontalScrollerDataSource <NSObject>

@required
- (NSInteger)numberOfViewsForHorizontalScroller:(AKBHorizontalScroller *)horizontalScroller;
- (UIView *)horizontalScroller:(AKBHorizontalScroller *)horizontalScroller viewForIndex:(NSInteger)index;
@optional
- (NSInteger)initialViewIndexForHorizontalScroller:(AKBHorizontalScroller *)horizontalScroller;
- (CGFloat)initialXOffsetForHorizontalScroller:(AKBHorizontalScroller *)horizontalScroller;

@end

@protocol AKBHorizontalScrollerDelegate <UIScrollViewDelegate>

@optional
- (void)horizontalScroller:(AKBHorizontalScroller *)horizontalScroller clickedViewAtIndex:(int)index;

@end