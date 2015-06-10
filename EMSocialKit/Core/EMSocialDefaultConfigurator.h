//
//  EMSocialDefaultConfigurator.h
//  EMSocialApp
//
//  Created by Ryan Wang on 3/26/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMSocialDefaultConfigurator : NSObject

- (NSString*)appName;
- (NSString*)appURL;

- (NSString*)sinaWeiboConsumerKey;
- (NSString*)sinaWeiboConsumerSecret;
- (NSString*)sinaWeiboCallbackUrl;
- (NSString*)sinaWeiboScreenname;
- (NSString*)sinaWeiboUserID;

- (NSString*)tencentWeixinAppId;
- (NSString*)tencentWeixinAppKey;

- (NSString*)tencentAppId;
- (NSString*)tencentAppKey;


@end
