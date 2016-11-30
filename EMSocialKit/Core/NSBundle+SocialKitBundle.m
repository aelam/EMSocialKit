//
//  NSBundle+SocialKitBundle.m
//  Pods
//
//  Created by ryan on 30/11/2016.
//
//

#import "NSBundle+SocialKitBundle.h"

@interface EMSocialDummy : NSObject
@end

@implementation EMSocialDummy
@end

@implementation NSBundle (SocialKitBundle)

+ (instancetype)socialBundle {
    return [NSBundle bundleForClass:[EMSocialDummy class]];
}

@end
