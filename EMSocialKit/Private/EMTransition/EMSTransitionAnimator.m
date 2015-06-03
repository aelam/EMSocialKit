//
//  EMTransitionAnimator.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/19/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMSTransitionAnimator.h"

@implementation EMSTransitionAnimator

+ (instancetype)animator {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.1;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.duration;
}


//Define the transition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}


@end
