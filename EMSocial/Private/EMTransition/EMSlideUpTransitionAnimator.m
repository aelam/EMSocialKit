//
//  EMSlideUpTransitionAnimator.m
//  TB_CustomTransitionIOS7
//
//  Created by Yari Dareglia on 10/22/13.
//  Copyright (c) 2013 Bitwaker. All rights reserved.
//

#import "EMSlideUpTransitionAnimator.h"

@implementation EMSlideUpTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning -

//Define the transition duration
//-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
//    return 0.2;
//}


//Define the transition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    //STEP 1
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    containerView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    
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
             usingSpringWithDamping:.8
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            fromView.frame = offscreenRect;
        } completion: ^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
    else if (self.presenting) {
        
        //2.Insert the toVC view...........................
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];

        CGRect fromVCRect = fromView.frame;
        CGRect toVCRect = fromView.frame;
        toVCRect.origin.y = fromVCRect.size.height;
        
        toView.frame = CGRectMake(0, initialFrameFrom.size.height, toView.frame.size.width, toView.frame.size.height);
        containerView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];

        //3.Perform the animation...............................
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:.8
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
         
                         animations:^{
                             toView.frame = CGRectMake(0, initialFrameFrom.size.height - toView.frame.size.height, toView.frame.size.width, toView.frame.size.height);
                             containerView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];

                         } completion:^(BOOL finished) {
                             //When the animation is completed call completeTransition
                             [transitionContext completeTransition:YES];
                             
                         }];
    }

}


@end
