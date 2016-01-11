//
//  EMTransitionAnimator.h
//  EMSocialApp
//
//  Created by Ryan Wang on 3/19/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMSTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)animator;

@property (nonatomic, assign) BOOL presenting;
@property (nonatomic, assign) float duration; // default is 0.1s

@end
