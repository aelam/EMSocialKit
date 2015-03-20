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

@interface EMSocialSDK () <WXApiDelegate,WeiboSDKDelegate>

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

+ (void)registerActivityViewController:(EMActivityViewController *)controller applicationActivities:(NSArray *)applicationActivities {
    [EMSocialSDK sharedSDK].activityViewController = controller;
    [EMSocialSDK sharedSDK].applicationActivities = applicationActivities;
}

+ (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)application delegate:(id)delegate {
    BOOL rs = NO;
    rs = [WXApi handleOpenURL:URL delegate:delegate];
    if (!rs) {
        rs = [WeiboSDK handleOpenURL:URL delegate:delegate];
    }
    
    return YES;
}


#pragma mark - WX
- (void)onReq:(BaseReq*)req {
    
}



/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp {
    
}


#pragma mark - WB
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
}


@end
