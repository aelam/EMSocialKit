//
//  EMLoginWeibo.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMLoginWeibo.h"
#import "WeiboSDK.h"

NSString *const EMLoginWeiboAccessTokenKey   = @"EMLoginWeiboAccessTokenKey";
NSString *const EMLoginWeiboUserIdKey        = @"EMLoginWeiboUserIdKey";
NSString *const EMLoginWeiboStatusCodeKey    = @"EMLoginWeiboStatusCodeKey";
NSString *const EMLoginWeiboStatusMessageKey = @"EMLoginWeiboStatusMessageKey";

NSString *const EMLoginTypeWeibo =  @"EMLoginTypeWeibo";


@interface EMLoginWeibo () <WeiboSDKDelegate>

@end

@implementation EMLoginWeibo

- (NSString *)loginType {
    return @"EMLoginTypeWeibo";
}


- (BOOL)canHandleOpenURL:(NSURL *)url {
    BOOL can = [[url scheme] hasPrefix:@"wb"] || [[url scheme] containsString:@"sso"]; //[WeiboSDK handleOpenURL:url delegate:nil];
    if (can && ![[url absoluteString] containsString:@"pay"]) {
        return YES;
    }
    return NO;
}

- (void)handleOpenURL:(NSURL *)url {
    [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)performLogin {
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
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
//        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
//        
//        [userInfo setObject:accessToken forKey:EMLoginWeiboAccessTokenKey];
//        [userInfo setObject:userID forKey:EMLoginWeiboUserIdKey];
//    }
//    else

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



@end
