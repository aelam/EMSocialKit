//
//  EMActivityWeChat.h
//  ActivityTest
//
//  Created by nickcheng on 15/1/8.
//  Copyright (c) 2015年 nickcheng.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMBridgeActivity.h"
#import "WXApi.h"
//#import "EMSocialSDK.h"

@class EMSocialSDK;

//@interface EMSocialSDK (WeChat)
//
//- (void)registerWeChat;
//
//@end

typedef NS_ENUM(NSInteger, EMActivityWeChatStatusCode) {
    EMActivityWeChatStatusCodeSuccess    = 0,    /**< 成功    */
    EMActivityWeChatStatusCodeCommon     = -1,   /**< 普通错误类型    */
    EMActivityWeChatStatusCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    EMActivityWeChatStatusCodeSentFail   = -3,   /**< 发送失败    */
    EMActivityWeChatStatusCodeAuthDeny   = -4,   /**< 授权失败    */
    EMActivityWeChatStatusCodeUnsupport  = -5,   /**< 微信不支持    */
};

UIKIT_EXTERN NSString *const EMActivityWeChatStatusCodeKey;
UIKIT_EXTERN NSString *const EMActivityWeChatSummaryKey;
UIKIT_EXTERN NSString *const EMActivityWeChatAuthCodeKey;


@interface EMActivityWeChat : EMBridgeActivity

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareStringTitle;
@property (nonatomic, strong) NSURL *shareURL;
@property (nonatomic, strong) UIImage *shareThumbImage;
@property (nonatomic, strong) NSString *shareStringDesc;

@property (nonatomic, assign) enum WXScene scene;

@end

