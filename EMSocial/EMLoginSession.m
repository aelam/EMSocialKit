//
//  EMLogin.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMLoginSession.h"
#import "EMSocialSDK.h"

@interface EMLoginSession ()

@end

@implementation EMLoginSession

- (NSString *)loginType {
    return nil;
}

- (BOOL)canHandleOpenURL:(NSURL *)url {
    return NO;
}

- (void)handleOpenURL:(NSURL *)url {

}

- (void)performLogin {
    
}

- (void)handledActivityResponse:(id)response activityError:(NSError *)error {
    EMSocialLoginCompletionHandler loginCompletionHandler = [EMSocialSDK sharedSDK].loginCompletionHandler;
    if (loginCompletionHandler) {
        loginCompletionHandler(YES, response, error);
    }
}


@end
