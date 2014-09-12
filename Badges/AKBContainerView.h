//
//  BTContainerView.h
//  BadgeTracker
//
//  Created by Alex Kliger on 8/12/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKBContainerView : UIView

@property (weak, nonatomic) UILabel *topLabel, *bottomLabel;
@property (weak, nonatomic) UIView *contentView;

@end
