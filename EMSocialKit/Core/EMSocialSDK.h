//
//  EMSocialSDK.h
//  EMSocialApp
//
//  Created by Ryan Wang on 3/20/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMSocialDefaultConfigurator.h"
#import "EMActivityViewController.h"
#import "EMActivityWeChat.h"
#import "EMActivityWeibo.h"
#import "EMActivityWeChatSession.h"
#import "EMActivityWeChatTimeline.h"
#import "EMActivityQQ.h"
#import "EMSTransitionAnimator.h"
#import "EMSSlideUpTransitionAnimator2.h"
#import "EMActivity.h"

FOUNDATION_EXPORT NSString *const EMSocialSDKErrorDomain;

@class EMActivity;
@class EMActivityViewController;
@class EMSocialDefaultConfigurator;

@interface EMSocialSDK : NSObject

@property(nonatomic, assign)EMActivityStyle activityStyle;
@property(nonatomic, strong)EMSTransitionAnimator *transitionAnimator;

+ (instancetype)sharedSDK;

/**
 * @discussion `EMSocialSDK` needs configure  first
 *   [EMSocialSDK sharedSDKWithConfigurator:[EMSocialEMoneyConfigurator new]];
 *   [[EMSocialSDK sharedSDK] registerBuiltInSocialApps];
 * @prama configor: subclass from `EMSocialDefaultConfigurator` and fill the ids and keys on your needs
 */
+ (instancetype)sharedSDKWithConfigurator:(EMSocialDefaultConfigurator *)configor;

- (id)configurationValue:(NSString*)selector withObject:(id)object;

///////////////////////////////////////////////////////////////////////////

- (void)registerBuiltInSocialApps;

/**
 *
 * @param URL : Handle URL responses from AppDelegate:HandleURL
 *
 */
- (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)application;

// Share
@property (nonatomic, strong) EMActivityViewController *activityViewController;
@property(nonatomic,copy, readonly) EMActivityShareCompletionHandler shareCompletionHandler;

/**
 *
 * @param items : @[@"plain text", [UIImage imageName:@"shareimage"], [NSURL URLWithString:@"http://baidu.com"]]
 * 微信的thumbData设置使用@{EMActivityWeChatThumbImageKey:[UIImage imageNamed:@"ThumbData"]}
 * @param controller: 用于present出社交选择器
 *
 */
- (void)shareActivityItems:(NSArray *)items rootViewController:(UIViewController *)controller completionHandler:(EMActivityShareCompletionHandler)shareCompletionHandler;

/**
 *
 * @param items : @[@"plain text", [UIImage imageName:@"shareimage"], [NSURL URLWithString:@"http://baidu.com"]]
 * 微信的thumbData设置使用@{EMActivityWeChatThumbImageKey:[UIImage imageNamed:@"ThumbData"]}
 * @param activity: 指定社交应用直接分享
 *
 */
- (void)shareActivityItems:(NSArray *)items activity:(EMActivity *)activity completionHandler:(EMActivityShareCompletionHandler)shareCompletionHandler;


///////////////////////////////////////////////////////////////////////////
// Login
@property (nonatomic, copy, readonly) EMActivityLoginCompletionHandler loginCompletionHandler;

- (void)loginWithActivity:(EMActivity *)activity completionHandler:(EMActivityLoginCompletionHandler) completion;

///////////////////////////////////////////////////////////////////////////


#define EMCONFIG(_CONFIG_KEY) [[EMSocialSDK sharedSDK] configurationValue:@#_CONFIG_KEY withObject:nil]
#define EMCONFIG_WITH_ARGUMENT(_CONFIG_KEY, _CONFIG_ARG) [[EMSocialSDK sharedSDK] configurationValue:@#_CONFIG_KEY withObject:_CONFIG_ARG]

@end
