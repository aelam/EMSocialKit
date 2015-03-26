//
//  EMLoginQQ.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/26/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMLoginQQ.h"
#import <TencentOpenAPI/TencentOpenSDK.h>
#import "EMActivity.h"

@interface EMLoginQQ () <TencentSessionDelegate>

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
//self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQApiAppID andDelegate:self];

@end


@implementation EMLoginQQ

- (instancetype)initWithAppId:(NSString *)appId {
    if (self = [super init]) {
        self.appId = appId;
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
    }
    return self;
}

- (NSArray *)permissions {
    return @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
}

- (NSString *)loginType {
    return @"EMLoginQQ";
}

- (void)performLogin {
    [super performLogin];
    [self.tencentOAuth authorize:self.permissions inSafari:YES];
}

- (void)handleOpenURLNotification:(NSNotification *)notification {
    NSURL *url = [[notification userInfo] objectForKey:EMActivityOpenURLKey];

    QQApiMessage* msg = [QQApi handleOpenURL:url];
    if(msg)
    {
        switch (msg.type)
        {
            case QQApiMessageTypeSendMessageToQQResponse:
            {
                // simply a response
                QQApiResultObject* resultObject = (QQApiResultObject*)msg.object;
                
//                if (resultObject.error!=nil) {
//                    if ([url.absoluteString rangeOfString:@"error=0"].location!=NSNotFound) {
//                        if (social.bShareSuccessful) {
//                            social.bShareSuccessful();
//                        }
//                        social.bShareSuccessful = nil;
//                        social.bShareFailed = nil;
//                        return YES;
//                    }
//                }
//                
//                // failed
//                if (social.bShareFailed) {
//                    social.bShareFailed(errorWithDescription(@"分享失败！"));
//                }
//                social.bShareSuccessful = nil;
//                social.bShareFailed = nil;
//                break;
            }
            default:
                break;
        }
    }
    
    [self handledActivityResponse:nil activityError:nil];


}

- (void)handledActivityResponse:(id)response activityError:(NSError *)error {
    
}


@end
