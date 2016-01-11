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

- (BOOL)handleOpenURL:(NSURL *)url {
    return YES;
}

- (void)handledShareResponse:(id)response error:(NSError *)error {
    if(self.completionHandler) {
        self.completionHandler(self.activityType ,YES, response, error);
    }
}

- (void)handledLoginResponse:(id)response error:(NSError *)error {
    EMActivityLoginCompletionHandler loginCompletionHandler = [EMSocialSDK sharedSDK].loginCompletionHandler;
    if (loginCompletionHandler) {
        loginCompletionHandler(YES, response, error);
    }
}


- (BOOL)canPerformLogin {
    return NO;
}

- (void)performLogin {
}


- (void)dealloc {
}

@end
