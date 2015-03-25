//
//  EMLoginWeibo.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMLoginWeibo.h"
#import "WeiboSDK.h"
#import "EMActivity.h"

NSString *const EMLoginWeiboAccessTokenKey   = @"EMLoginWeiboAccessTokenKey";
NSString *const EMLoginWeiboUserIdKey        = @"EMLoginWeiboUserIdKey";
NSString *const EMLoginWeiboStatusCodeKey    = @"EMLoginWeiboStatusCodeKey";
NSString *const EMLoginWeiboStatusMessageKey = @"EMLoginWeiboStatusMessageKey";

NSString *const EMLoginTypeWeibo =  @"EMLoginTypeWeibo";


@interface EMLoginWeibo () <WeiboSDKDelegate>

@end

@implementation EMLoginWeibo

- (NSString *)loginType {
    return EMLoginTypeWeibo;
}


- (void)handleOpenURLNotification:(NSNotification *)notification {
    NSURL *url = [[notification userInfo] objectForKey:EMActivityOpenURLKey];
    [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)performLogin {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURLNotification:) name:EMActivityOpenURLNotification object:nil];

    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://weibo.com";
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

#pragma mark - WBSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString* accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString* userID = [(WBAuthorizeResponse *)response userID];
        [userInfo setObject:accessToken forKey:EMLoginWeiboAccessTokenKey];
        [userInfo setObject:userID forKey:EMLoginWeiboUserIdKey];
        [self handledActivityResponse:userInfo activityError:nil];
    } else {
        // TODO
        [self handledActivityResponse:userInfo activityError:[NSError errorWithDomain:@"1" code:0 userInfo:@{NSLocalizedDescriptionKey:@"非认证请求"}]];
    }
    
}

- (void)handledActivityResponse:(id)response activityError:(NSError *)error {
    if (self.completionWithItemsHandler) {
        self.completionWithItemsHandler(YES, response, error);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
