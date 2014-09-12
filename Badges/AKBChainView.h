//
//  BTChainView.h
//  BadgeTracker
//
//  Created by Alex Kliger on 8/22/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKBDay;

@interface AKBChainView : UIView

- (id)initWithFrame:(CGRect)frame day:(AKBDay *)day;

@end