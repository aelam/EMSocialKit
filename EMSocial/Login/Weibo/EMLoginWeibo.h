//
//  EMLoginWeibo.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMLoginApp.h"

FOUNDATION_EXPORT NSString *const EMLoginWeiboAccessTokenKey;
FOUNDATION_EXPORT NSString *const EMLoginWeiboUserIdKey;
FOUNDATION_EXPORT NSString *const EMLoginWeiboStatusCodeKey;
FOUNDATION_EXPORT NSString *const EMLoginWeiboStatusMessageKey;


@interface EMLoginWeibo : EMLoginApp

- (NSString *)appSecret;
- (NSString *)redirectURI;
- (NSString *)scope;

@end
