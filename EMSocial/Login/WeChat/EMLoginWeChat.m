//
//  EMLoginWeChat.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/26/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMLoginWeChat.h"
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "EMSocialSDK.h"

NSString *const EMLoginWeChatAuthCodeKey = @"EMLoginWeChatAuthCodeKey";

@interface EMLoginWeChat () <WXApiDelegate>

@property (nonatomic, strong) NSString *state;

@end

@implementation EMLoginWeChat

- (NSString *)appId {
    return EMCONFIG(tencentWeixinAppId);
}

- (NSString *)scope {
    return @"snsapi_userinfo";
}

- (BOOL)isAppInstalled {
    return [WXApi isWXAppInstalled];
}

- (void)handleOpenURLNotification:(NSNotification *)notification {
    NSURL *url = [[notification userInfo] objectForKey:EMSocialOpenURLKey];
    [WXApi handleOpenURL:url delegate:self];
}

- (void)performLogin {
    [super performLogin];
    SendAuthReq *req = [SendAuthReq new];
    req.scope = [self scope];
    req.state = [NSString stringWithFormat:@"%ld", time(NULL)];
    self.state = req.state;
    [WXApi sendAuthReq:req viewController:nil delegate:self];
}

-(void) onReq:(BaseReq*)req {
    
}

-(void) onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        NSError *error = nil;
        if ([self.state isEqualToString:authResp.state]) {
            if (authResp.code) {
                userInfo[EMLoginWeChatAuthCodeKey] = authResp.code;
            } else {
                error = [NSError errorWithDomain:EMSocialSDKErrorDomain code:100 userInfo:@{NSLocalizedDescriptionKey:@"微信授权失败"}];
            }
        } else {
            // error
        }
        
        [self handledResponse:userInfo error:error];
    }
}

@end
