//
//  EMSocialEMoneyConfigurator.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/26/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMSocialEMoneyConfigurator.h"

@implementation EMSocialEMoneyConfigurator

- (NSString*)appURL {
    return @"http://emoney.cn";
}

- (NSString*)sinaWeiboConsumerKey {
    return @"1779442884";
}

- (NSString*)sinaWeiboConsumerSecret {
    return @"";
}

// You need to set this if using OAuth (MUST be set and SAME AS "Callback Url" of "OAuth 2.0 Auth Settings" on Sina Weibo open plaform.
// Url like this: http://open.weibo.com/apps/{app_key}/info/advanced
- (NSString*)sinaWeiboCallbackUrl {
    return @"http://cell.emoney.cn";
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
    return @"wx85e5bbec559cd907";
}

- (NSString*)tencentWeixinAppKey {
    return @"637c8424532704e01532cbb3634f3031";
}

- (NSString*)tencentAppId {
    return @"1103441607";
}

- (NSString*)tencentAppKey {
    return @"Me24nvcpb1xRTs8j";
}

- (NSString *)tencentQQAppId {
    return @"1103441607";
}

@end
