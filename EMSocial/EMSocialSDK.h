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

@interface EMSocialSDK : NSObject

+ (void)registerWeiboWithAppKey:(NSString *)appKey appSecret:(NSString *)secret redirectURI:(NSString *)redirectURI;
+ (void)registerWeChatWithAppId:(NSString *)appKey;
+ (void)registerQQWithAppKey:(NSString *)appKey;

+ (BOOL)handleOpenURL:(NSURL *)URL sourceApplication:(NSString *)application delegate:(id)delegate;


@end
