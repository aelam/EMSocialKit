//
//  EMSlideUpTransitionAnimator.m
//  TB_CustomTransitionIOS7
//
//  Created by Yari Dareglia on 10/22/13.
//  Copyright (c) 2013 Bitwaker. All rights reserved.
//

#import "EMSSlideUpTransitionAnimator2.h"
#import "UIView+AnchorPoint.h"

@implementation EMSSlideUpTransitionAnimator2

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.3;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning -
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    //STEP 1
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    CGRect initialFrameFrom = [transitionContext initialFrameForViewController:fromVC];

    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    if (self.presenting == NO) {
        
        // dismiss
        
        CGRect offscreenRect = initialFrameFrom;
        offscreenRect.origin.y = containerView.frame.size.height;
        
        // Animate the view offscreen
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:9.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             fromView.frame = offscreenRect;
                             containerView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0];
                             toView.transform = CGAffineTransformIdentity;
                             [self removeShadowForView:fromView];
        } completion: ^(BOOL finished) {

            toView.anchorPoint = CGPointMake(0.5, 0.5);
            [fromView removeFromSuperview];
            [fromVC removeFromParentViewController];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
    else if (self.presenting) {
        fromVC.view.superview.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        //2.Insert the toVC view...........................
        [containerView insertSubview:toVC.view aboveSubview:fromVC.view];

        CGRect fromVCRect = fromView.frame;
        CGRect toVCRect = fromView.frame;
        toVCRect.origin.y = fromVCRect.size.height;
        toVCRect.size.width = fromVCRect.size.width;
      
        toView.frame = CGRectMake(0, initialFrameFrom.size.height, fromVCRect.size.width, toView.frame.size.height);

        //3.Perform the animation...............................
        fromView.anchorPoint = CGPointMake(0.5, 0);

        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:7.0
                            options:UIViewAnimationOptionCurveEaseIn
         
                         animations:^{
                             toView.frame = CGRectMake(0, initialFrameFrom.size.height - toView.frame.size.height, toView.frame.size.width, toView.frame.size.height);
                             [self addShadowForView:toView];
                             fromView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                             
                         }];
    }

}

- (void)removeShadowForView:(UIView *)toView {
    [toView.layer setShadowOpacity:0];
}

- (void)addShadowForView:(UIView *)toView {
    
    [toView.layer setShouldRasterize:TRUE];
    [toView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    [toView.layer setShadowOpacity:1.0];
    [toView.layer setShadowColor:[[UIColor colorWithWhite:0.2 alpha:1] CGColor]];
    [toView.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [toView.layer setShadowRadius:20.f];

}

@end
