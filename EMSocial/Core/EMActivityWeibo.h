//
//  EMActivityWeibo.h
//  ActivityTest
//
//  Created by nickcheng on 15/1/5.
//  Copyright (c) 2015年 nickcheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBridgeActivity.h"

UIKIT_EXTERN NSString *const UIActivityTypePostToSinaWeibo;

@interface EMActivityWeibo : EMBridgeActivity

+ (void)registerAppKey:(NSString *)appKey;

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareString;

@property (nonatomic, strong) NSString *authRedirectURI;
@property (nonatomic, strong) NSString *authScope;
@property (nonatomic, strong) NSString *authAccessToken;

// config by subclass
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecrect;
@property (nonatomic, strong) NSString *ssoCallbackScheme;


@end
