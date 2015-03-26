//
//  EMSocialSDK.h
//  EMSocialApp
//
//  Created by Ryan Wang on 3/20/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMActivityViewController.h"
#import "EMActivityWeibo.h"
#import "EMActivityWeChatTimeline.h"
#import "EMActivityWeChatSession.h"
#import "EMSocialOpenURLHandler.h"

#import "EMLoginSession.h"
#import "EMLoginWeibo.h"


typedef void (^EMSocialLoginCompletionHandler)(BOOL completed, NSDictionary *returnedInfo, NSError *activityError);
typedef void (^EMSocialShareCompletionHandler)(BOOL completed, NSDictionary *returnedInfo, NSError *activityError);


@class EMLoginSession;
@class EMActivity;
@class EMActivityViewController;

@interface EMSocialSDK : NSObject

+ (instancetype)sharedSDK;

+ (void)registerWeiboWithAppKey:(NSString *)appKey appSecret:(NSString *)secret redirectURI:(NSString *)redirectURI;
+ (void)registerWeChatWithAppId:(NSString *)appKey;
+ (void)registerQQWithAppKey:(NSString *)appKey;

- (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)application;

// Share
@property (nonatomic, strong) EMActivityViewController *activityViewController;
@property(nonatomic,copy, readonly) EMActivityShareCompletionHandler shareCompletionHandler;

- (void)shareWithContent:(NSArray *)content rootViewController:(UIViewController *)controller completionHandler:(EMActivityShareCompletionHandler)shareCompletionHandler;


@property (nonatomic, copy, readonly) EMSocialLoginCompletionHandler loginCompletionHandler;

- (void)loginWithSession:(EMLoginSession *)session completionHandler:(EMSocialLoginCompletionHandler) completion;


@end
