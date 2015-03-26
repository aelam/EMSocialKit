//
//  EMLogin.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMLoginApp.h"
#import "EMSocialSDK.h"
#import "EMLoginApp-Private.h"

@interface EMLoginApp ()

@end

@implementation EMLoginApp

- (NSString *)appId {
    return nil;
}

- (NSString *)loginType {
    return NSStringFromClass([self class]);
}

- (BOOL)needsHandleOpenURL {
    return YES;
}

- (BOOL)isAppInstalled {
    return NO;
}

- (void)performLogin {
    if ([self needsHandleOpenURL]) {
        [self _addObservers];
    }
}

- (void)handledResponse:(id)response error:(NSError *)error
{
    [self _removeObservers];
    EMSocialLoginCompletionHandler loginCompletionHandler = [EMSocialSDK sharedSDK].loginCompletionHandler;
    if (loginCompletionHandler) {
        loginCompletionHandler(YES, response, error);
    }
}


@end
