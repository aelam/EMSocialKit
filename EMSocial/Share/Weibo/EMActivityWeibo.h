//
//  EMActivityWeibo.h
//

#import <UIKit/UIKit.h>
#import "EMBridgeActivity.h"
#import "EMSocialSDK.h"

typedef NS_ENUM(NSInteger, EMActivityWeiboStatusCode)
{
    EMActivityWeiboStatusCodeSuccess               = 0,//成功
    EMActivityWeiboStatusCodeUserCancel            = -1,//用户取消发送
    EMActivityWeiboStatusCodeSentFail              = -2,//发送失败
    EMActivityWeiboStatusCodeAuthDeny              = -3,//授权失败
    EMActivityWeiboStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
    EMActivityWeiboStatusCodePayFail               = -5,//支付失败
    EMActivityWeiboStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
    EMActivityWeiboStatusCodeUnsupport             = -99,//不支持的请求
    EMActivityWeiboStatusCodeUnknown               = -100,
};


UIKIT_EXTERN NSString *const UIActivityTypePostToSinaWeibo;

UIKIT_EXTERN NSString *const EMActivityWeiboAccessTokenKey;
UIKIT_EXTERN NSString *const EMActivityWeiboUserIdKey;
UIKIT_EXTERN NSString *const EMActivityWeiboStatusCodeKey;

@interface EMActivityWeibo : EMBridgeActivity

@property (nonatomic, strong) NSString *scope;
@property (nonatomic, strong) NSString *redirectURI;
@property (nonatomic, strong) NSString *accessToken;

@end
