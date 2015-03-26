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
#import "EMActivityWeibo.h"
#import "EMActivityWeChatTimeline.h"
#import "EMActivityWeChatSession.h"

#import "EMLoginApp.h"
#import "EMLoginWeibo.h"
#import "EMLoginWeChat.h"

FOUNDATION_EXPORT NSString *const EMSocialSDKErrorDomain;
FOUNDATION_EXPORT NSString *const EMSocialOpenURLNotification;
FOUNDATION_EXPORT NSString *const EMSocialOpenURLKey;



typedef void (^EMSocialLoginCompletionHandler)(BOOL completed, NSDictionary *returnedInfo, NSError *activityError);
typedef void (^EMSocialShareCompletionHandler)(BOOL completed, NSDictionary *returnedInfo, NSError *activityError);


@class EMLoginApp;
@class EMActivity;
@class EMActivityViewController;
@class EMSocialDefaultConfigurator;

@interface EMSocialSDK : NSObject


+ (instancetype)sharedSDK;
+ (instancetype)sharedSDKWithConfigurator:(EMSocialDefaultConfigurator *)configor;

- (id)configurationValue:(NSString*)selector withObject:(id)object;

///////////////////////////////////////////////////////////////////////////

- (void)registerSocialApps;

- (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)application;

// Share
@property (nonatomic, strong) EMActivityViewController *activityViewController;
@property(nonatomic,copy, readonly) EMActivityShareCompletionHandler shareCompletionHandler;


/**
 *
 * @param content : @[@"plain text", [UIImage imageName:@"shareimage"], [NSURL URLWithString:@"http://baidu.com"]]
 * @param controller: 用于present出社交选择器
 *
 */
- (void)shareContent:(NSArray *)content rootViewController:(UIViewController *)controller completionHandler:(EMActivityShareCompletionHandler)shareCompletionHandler;

/**
 *
 * @param content : @[@"plain text", [UIImage imageName:@"shareimage"], [NSURL URLWithString:@"http://baidu.com"]]
 * @param activity: 指定社交应用直接分享
 *
 */
- (void)shareContent:(NSArray *)content activity:(EMActivity *)activity completionHandler:(EMActivityShareCompletionHandler)shareCompletionHandler;


///////////////////////////////////////////////////////////////////////////
// Login
@property (nonatomic, copy, readonly) EMSocialLoginCompletionHandler loginCompletionHandler;

- (void)loginWithSession:(EMLoginApp *)session completionHandler:(EMSocialLoginCompletionHandler) completion;


///////////////////////////////////////////////////////////////////////////


#define EMCONFIG(_CONFIG_KEY) [[EMSocialSDK sharedSDK] configurationValue:@#_CONFIG_KEY withObject:nil]
#define EMCONFIG_WITH_ARGUMENT(_CONFIG_KEY, _CONFIG_ARG) [[EMSocialSDK sharedSDK] configurationValue:@#_CONFIG_KEY withObject:_CONFIG_ARG]

@end
