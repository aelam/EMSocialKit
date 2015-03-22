//
//  EMLoginWeibo.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMLogin.h"

FOUNDATION_EXPORT NSString *const EMLoginWeiboAccessTokenKey;
FOUNDATION_EXPORT NSString *const EMLoginWeiboUserIdKey;
FOUNDATION_EXPORT NSString *const EMLoginWeiboStatusCodeKey;
FOUNDATION_EXPORT NSString *const EMLoginWeiboStatusMessageKey;

FOUNDATION_EXPORT NSString *const EMLoginTypeWeibo;

@interface EMLoginWeibo : EMLogin

@end
