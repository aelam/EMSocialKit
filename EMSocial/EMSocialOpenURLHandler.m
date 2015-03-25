//
//  EMSocialOpenURLHandler.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/21.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMSocialOpenURLHandler.h"
#import "EMActivity.h"
#import "EMLogin.h"
#import "EMActivityViewController.h"

@interface EMSocialOpenURLHandler ()

@property (nonatomic, strong) EMActivity *watchingActivity;
@property (nonatomic, strong) EMLogin *watchingLogin;
@property (nonatomic, strong) EMActivityViewController *activityViewController;

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

//- (void)setWatchingLogin:(EMLogin *)aLogin {
//    _watchingLogin = aLogin;
//    if (_watchingLogin != nil) {
//        _watchingActivity = nil;
//    }
//}
//
//- (void)setWatchingActivity:(EMActivity *)watchingActivity {
//    _watchingActivity = watchingActivity;
//    if (_watchingActivity != nil) {
//        _watchingLogin = nil;
//    }
//}
//
//- (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)application {
//    if (self.watchingActivity && [self.watchingActivity respondsToSelector:@selector(canHandleOpenURL:)]) {
//        BOOL canHandle = [self.watchingActivity canHandleOpenURL:URL];
//        if (canHandle) {
//            [self.watchingActivity handleOpenURL:URL];
//            return YES;
//        }
//    } else if (self.watchingLogin && [self.watchingLogin respondsToSelector:@selector(canHandleOpenURL:)]) {
//            BOOL canHandle = [self.watchingLogin canHandleOpenURL:URL];
//            if (canHandle) {
//                [self.watchingLogin handleOpenURL:URL];
//                return YES;
//            }
//    }
//    
//    return NO;
//}


@end
