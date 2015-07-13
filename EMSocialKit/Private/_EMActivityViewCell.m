//
//  _EMActivityViewCell.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/19/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "_EMActivityViewCell.h"

#define ICON_WIDTH 50.f

@implementation _EMActivityViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.activityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICON_WIDTH, ICON_WIDTH)];
        CGRect rect = self.activityImageView.frame;
        rect.origin.x = self.bounds.size.width * 0.5 - ICON_WIDTH * 0.5;
        rect.origin.y = 10;
        self.activityImageView.frame = rect;
        self.activityImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.activityImageView];
        
        self.activityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 20)];
        self.activityTitleLabel.font = [UIFont systemFontOfSize:14];
        self.activityTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.activityTitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.activityImageView.frame;
    rect.origin.x = self.bounds.size.width * 0.5 - ICON_WIDTH * 0.5;
    rect.origin.y = 18;
    self.activityImageView.frame = rect;
}

@end
