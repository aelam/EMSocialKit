//
//  EMSocialSDK.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/20/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMSocialSDK.h"
#import "WeiboSDK.h"
#import "WXApi.h"
//#import <TencentOpenAPI/QQApi.h>
#import "EMActivityViewController.h"

@interface EMSocialSDK ()

@property (nonatomic, strong) NSString *weiboAppKey;
@property (nonatomic, strong) NSString *weiboAppSecret;
@property (nonatomic, strong) NSString *weiboRedirectURI;

@property (nonatomic, strong) NSString *wechatAppId;
@property (nonatomic, strong) NSString *qqAppKey;

@property (nonatomic, strong) NSArray *applicationActivities;
@property (nonatomic, strong) EMActivityViewController *activityViewController;

@end

@implementation EMSocialSDK

+ (instancetype)sharedSDK {
    static EMSocialSDK *sdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk = [[EMSocialSDK alloc] init];
    });
    return sdk;
}

+ (void)registerWeiboWithAppKey:(NSString *)appKey appSecret:(NSString *)secret redirectURI:(NSString *)redirectURI {
    [EMSocialSDK sharedSDK].weiboAppKey = appKey;
    [EMSocialSDK sharedSDK].weiboAppSecret = secret;
    [EMSocialSDK sharedSDK].weiboRedirectURI = redirectURI;
    [WeiboSDK registerApp:appKey];
}

+ (void)registerWeChatWithAppId:(NSString *)appId {
    [EMSocialSDK sharedSDK].wechatAppId = appId;
    [WXApi registerApp:appId];
}

+ (void)registerQQWithAppKey:(NSString *)appKey {
//    [QQApi ]
}

@end
