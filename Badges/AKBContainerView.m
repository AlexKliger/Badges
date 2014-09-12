//
//  BTContainerView.m
//  BadgeTracker
//
//  Created by Alex Kliger on 8/12/14.
//  Copyright (c) 2014 Alex M. Kliger. All rights reserved.
//

#import "AKBContainerView.h"

@implementation AKBContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 2)];
        view1.layer.borderColor = [UIColor whiteColor].CGColor;
        view1.layer.borderWidth = 0.5;
        self.contentView = view1;
        [self addSubview:self.contentView];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentView.frame), self.bounds.size.width, self.bounds.size.height / 4)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.layer.borderColor = [UIColor whiteColor].CGColor;
        label1.layer.borderWidth = 0.5;
        [label1 setTextColor:[UIColor whiteColor]];
        self.topLabel = label1;
        [self addSubview:self.topLabel];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLabel.frame), self.bounds.size.width, self.bounds.size.height / 4)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.layer.borderColor = [UIColor whiteColor].CGColor;
        label2.layer.borderWidth = 0.5;
        [label2 setTextColor:[UIColor whiteColor]];
        self.bottomLabel = label2;
        [self addSubview:self.bottomLabel];
    }
    return self;
}

- (void)setContentView:(UIView *)contentView
{
    contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height / 2);
    contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    contentView.layer.borderWidth = 0.5;
    if (contentView != _contentView) {
        _contentView = contentView;
        [self addSubview:contentView];
    }
}

@end
