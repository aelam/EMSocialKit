//
//  EMActivity.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMActivity.h"
#import "_EMActivityViewController.h"
#import "EMSocialSDK.h"

@class EMActivityViewController;

NSString *const UIActivityTypePostToWeChatSession = @"UIActivityTypePostToWeChatSession";
NSString *const UIActivityTypePostToWeChatTimeline = @"UIActivityTypePostToWeChatTimeline";
NSString *const UIActivityTypePostToSinaWeibo = @"UIActivityTypePostToSinaWeibo";


@interface EMActivity ()

@property (nonatomic, strong, readwrite) EMActivityViewController *activityViewController;

@end


@implementation EMActivity {
    BOOL _isLogin;
}

@synthesize activityViewController;

+ (void)registerApp {
    
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (NSString *)activityType {
    return nil;
};

- (NSString *)activityTitle {
    return nil;
}

- (UIImage *)activityImage {
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {}

- (void)performActivity {
    
}

- (void)activityDidFinish:(BOOL)completed {
    
}

- (void)handleOpenURLNotification:(NSNotification *)notification {
    NSURL *url = [[notification userInfo] objectForKey:EMSocialOpenURLKey];
    [self handleOpenURL:url];
}

- (void)handleOpenURL:(NSURL *)url {
}

- (void)handledShareResponse:(id)response error:(NSError *)error {
    if(self.completionHandler) {
        self.completionHandler(YES, response, error);
    }
    
    EMActivityViewController *activityViewController_ = [EMSocialSDK sharedSDK].activityViewController;
    [activityViewController_ _handleAcitivityType:self.activityTitle completed:YES returnInfo:response activityError:error];
}

- (void)handledLoginResponse:(id)response error:(NSError *)error {
    EMSocialLoginCompletionHandler loginCompletionHandler = [EMSocialSDK sharedSDK].loginCompletionHandler;
    if (loginCompletionHandler) {
        loginCompletionHandler(YES, response, error);
    }
}


- (BOOL)canPerformLogin {
    return NO;
}

- (void)performLogin {
    [self observerForOpenURLNotification];
}

- (void)observerForOpenURLNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURLNotification:) name:EMSocialOpenURLNotification object:nil];
}

- (void)removeObserverForOpenURLNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EMSocialOpenURLNotification object:nil];
}

- (void)dealloc {
    [self removeObserverForOpenURLNotification];
}

@end
