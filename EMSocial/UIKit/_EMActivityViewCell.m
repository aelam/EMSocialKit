//
//  _EMActivityViewCell.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/19/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "_EMActivityViewCell.h"

@implementation _EMActivityViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.activityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
        self.activityImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.activityImageView];
        
        self.activityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        self.activityTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.activityTitleLabel];
        
    }
    return self;
}

@end
