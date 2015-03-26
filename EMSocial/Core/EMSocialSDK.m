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
#import "EMActivityViewController.h"
#import "EMActivity.h"
#import "EMLoginApp.h"
#import "EMActivityWeibo.h"
#import "EMSocialSDK-Apps.h"


NSString *const EMSocialSDKErrorDomain = @"com.emoney.emsocialsdk";

@interface EMSocialSDK ()

@property (nonatomic, strong, readwrite) EMLoginApp *loginSession;
@property (nonatomic, copy, readwrite) EMSocialLoginCompletionHandler loginCompletionHandler;

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

#pragma mark - Register
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


- (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:EMActivityOpenURLNotification object:nil userInfo:@{EMActivityOpenURLKey:URL}];
    return YES;
}

- (void)shareWithContent:(NSArray *)content rootViewController:(UIViewController *)controller completionHandler:(EMActivityShareCompletionHandler)shareCompletionHandler {
    NSArray *activies = @[[[EMActivityWeibo alloc]init],
                          [[EMActivityWeChatTimeline alloc]init],
                          [[EMActivityWeChatSession alloc]init]
                         ];
    EMActivityViewController *activityViewController = [[EMActivityViewController alloc] initWithActivityItems:content applicationActivities:activies];
    
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        if (shareCompletionHandler) {
            shareCompletionHandler(activityType,  completed, returnedInfo, activityError);
        }
    };
    
    [controller presentViewController:activityViewController animated:YES completion:^{
        NSLog(@"DONE");
    }];

}

// Login
- (void)loginWithSession:(EMLoginApp *)session completionHandler:(EMSocialLoginCompletionHandler) completion{
    self.loginSession = session;
    self.loginCompletionHandler = completion;
    [self.loginSession performLogin];
}

@end
