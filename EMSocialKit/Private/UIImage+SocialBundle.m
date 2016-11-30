//
//  UIImage+SocialBundle.m
//  Pods
//
//  Created by ryan on 30/11/2016.
//
//

#import "UIImage+SocialBundle.h"
#import "NSBundle+SocialKitBundle.h"

@implementation UIImage (SocialBundle)

+ (UIImage *)socialImageNamed:(NSString *)name {
    if ([[UIImage class] respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:name inBundle:[NSBundle socialBundle] compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageNamed:name];
    }
}

@end
