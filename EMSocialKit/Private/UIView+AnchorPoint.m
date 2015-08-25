//
//  UIView+AnchorPoint.m
//  Pods
//
//  Created by ryan on 15/8/19.
//
//

#import "UIView+AnchorPoint.h"

@implementation UIView (AnchorPoint)

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}

@end
