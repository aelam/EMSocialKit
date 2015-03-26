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

- (instancetype)init {
    if (self = [super init]) {
        self.redirectURI = @"http://weibo.com";
        self.scope = @"all";
    }
    return self;
}

- (NSString *)loginType {
    return EMLoginTypeWeibo;
}

- (void)handleOpenURLNotification:(NSNotification *)notification {
    NSURL *url = [[notification userInfo] objectForKey:EMActivityOpenURLKey];
    [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)performLogin {
    [self addObservers];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.redirectURI;// @"http://weibo.com";
    request.scope = self.scope;//@"all";
    [WeiboSDK sendRequest:request];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURLNotification:) name:EMActivityOpenURLNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
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
    
    [self removeObservers];
}


- (void)dealloc {
    [self removeObservers];
}

@end
