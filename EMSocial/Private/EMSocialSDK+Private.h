//
//  EMSocialSDK+Private.h
//  EMStock
//
//  Created by Ryan Wang on 3/20/15.
//  Copyright (c) 2015 flora. All rights reserved.
//

#import "EMSocialSDK.h"

@interface EMSocialSDK (Private)

@property (nonatomic, strong) NSString *weiboAppKey;
@property (nonatomic, strong) NSString *weiboAppSecret;
@property (nonatomic, strong) NSString *weiboRedirectURI;

@property (nonatomic, strong) NSString *wechatAppId;
@property (nonatomic, strong) NSString *qqAppKey;

@property (nonatomic, strong) NSArray *applicationActivities;
@property (nonatomic, strong) EMActivityViewController *activityViewController;

+ (instancetype)sharedSDK;

@end
