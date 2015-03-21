//
//  EMSocialOpenURLHandler.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/21.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMSocialOpenURLHandler.h"
#import "EMActivity.h"

@interface EMSocialOpenURLHandler ()

@property (nonatomic, strong) EMActivity *watchingActivity;

@end


@implementation EMSocialOpenURLHandler

+ (instancetype)sharedHandler {
    static EMSocialOpenURLHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[EMSocialOpenURLHandler alloc] init];
    });
    return handler;
}

- (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)application {
    if (self.watchingActivity && [self.watchingActivity respondsToSelector:@selector(canHandleActivityURL:)]) {
        BOOL canHandle = [self.watchingActivity canHandleActivityURL:URL];
        if (canHandle) {
            [self.watchingActivity handleActivityURL:URL];
            return YES;
        }
    }
    
    return NO;
}


@end
