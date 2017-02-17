//
//  EMQQActivity.h
//  Pods
//
//  Created by Ryan Wang on 6/8/15.
//
//

#import "EMBridgeActivity.h"

UIKIT_EXTERN NSString *const UIActivityTypePostToQQ;

UIKIT_EXTERN NSString *const EMActivityQQAccessTokenKey;
UIKIT_EXTERN NSString *const EMActivityQQRefreshTokenKey;
UIKIT_EXTERN NSString *const EMActivityQQExpirationDateKey;

UIKIT_EXTERN NSString *const EMActivityQQUserIdKey;         // openId
UIKIT_EXTERN NSString *const EMActivityQQNameKey;           // QQ昵称
UIKIT_EXTERN NSString *const EMActivityQQProfileImageURLKey;// QQ头像

UIKIT_EXTERN NSString *const EMActivityQQExpirationDateKey; // expirationDate
UIKIT_EXTERN NSString *const EMActivityQQStatusCodeKey;
UIKIT_EXTERN NSString *const EMActivityQQStatusMessageKey;


typedef NS_ENUM(NSInteger, EMActivityQQStatusCode)
{
    EMActivityQQStatusCodeSuccess               = 0,//成功
    EMActivityQQStatusCodeSentFail              = -2,//发送失败
    EMActivityQQStatusCodeAuthDeny              = -3,//授权失败
    EMActivityQQStatusCodeUserCancel            = -4,//用户取消发送
//    EMActivityQQStatusCodeUserCancelInstall     = -4,//用户取消
    EMActivityQQStatusCodePayFail               = -5,//支付失败
    EMActivityQQStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
    EMActivityQQStatusCodeUnsupport             = -99,//不支持的请求
    EMActivityQQStatusCodeUnknown               = -100,
    EMActivityQQStatusCodeNetworkError          = -101,//网络错误
    EMActivityQQStatusCodeAppNotInstall         = -102
};



@interface EMActivityQQ : EMBridgeActivity

- (BOOL)handleLoginOpenURL:(NSURL *)url;

@end
