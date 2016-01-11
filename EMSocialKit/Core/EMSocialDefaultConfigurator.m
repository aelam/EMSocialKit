//
//  EMSocialDefaultConfigurator.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/26/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMSocialDefaultConfigurator.h"

@implementation EMSocialDefaultConfigurator

- (NSString*)appName {
    return [[[NSBundle mainBundle] infoDictionary]  objectForKey:(id)kCFBundleNameKey];
}

- (NSString*)appURL {
    return @"http://example.com";
}

- (NSString*)sinaWeiboConsumerKey {
    return @"";
}

- (NSString*)sinaWeiboConsumerSecret {
    return @"";
}


// You need to set this if using OAuth (MUST be set and SAME AS "Callback Url" of "OAuth 2.0 Auth Settings" on Sina Weibo open plaform.
// Url like this: http://open.weibo.com/apps/{app_key}/info/advanced
- (NSString*)sinaWeiboCallbackUrl {
    return @"";
}

// To use xAuth, set to 1
- (NSNumber*)sinaWeiboUseXAuth {
    return [NSNumber numberWithInt:0];
}

// Enter your sina weibo screen name (Only for xAuth)
- (NSString*)sinaWeiboScreenname {
    return @"";
}

//Enter your app's sina weibo account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)sinaWeiboUserID {
    return @"";
}

- (NSString*)tencentWeixinAppId {
    return @"";
}

- (NSString*)tencentWeixinAppKey {
    return @"";   
}

- (NSString*)tencentAppId {
    return @"";
}

- (NSString*)tencentAppKey {
    return @"";
}



@end
