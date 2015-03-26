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
#import "EMSocialSDK.h"
#import "EMSocialSDK+Weibo.h"

NSString *const EMLoginWeiboAccessTokenKey   = @"EMLoginWeiboAccessTokenKey";
NSString *const EMLoginWeiboUserIdKey        = @"EMLoginWeiboUserIdKey";
NSString *const EMLoginWeiboStatusCodeKey    = @"EMLoginWeiboStatusCodeKey";
NSString *const EMLoginWeiboStatusMessageKey = @"EMLoginWeiboStatusMessageKey";


@interface EMLoginWeibo () <WeiboSDKDelegate>

@end

@implementation EMLoginWeibo

- (NSString *)redirectURI {
    return [EMSocialSDK sharedSDK].weiboRedirectURI;
}

- (NSString *)appId {
    return [EMSocialSDK sharedSDK].weiboAppKey;
}

- (NSString *)appSecret {
    return [EMSocialSDK sharedSDK].weiboAppSecret;
}

- (NSString *)scope {
    return [EMSocialSDK sharedSDK].weiboScope;
}

- (BOOL)isAppInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)handleOpenURLNotification:(NSNotification *)notification {
    NSURL *url = [[notification userInfo] objectForKey:EMActivityOpenURLKey];
    [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)performLogin {
    [super performLogin];
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.redirectURI;// @"http://weibo.com";
    request.scope = self.scope;//@"all";
    [WeiboSDK sendRequest:request];
}

#pragma mark - WBSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSError *error = nil;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString* accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString* userID = [(WBAuthorizeResponse *)response userID];
        if (accessToken) {
            [userInfo setObject:accessToken forKey:EMLoginWeiboAccessTokenKey];
        }
        if (userID) {
            [userInfo setObject:userID forKey:EMLoginWeiboUserIdKey];
        }
    } else {
        error =  [NSError errorWithDomain:EMSocialSDKErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:@"非认证请求"}];
    }
    [self handledResponse:userInfo error:nil];
}


- (void)dealloc {
}

@end
