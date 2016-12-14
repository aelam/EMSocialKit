//
//  EMActivityWeChat.h
//

#import <UIKit/UIKit.h>
#import "EMBridgeActivity.h"

typedef NS_ENUM(NSInteger, EMWXScene) {
    EMWXSceneSession = 0,
    EMWXSceneTimeline = 1,
    EMWXSceneFavorite = 2
};

typedef NS_ENUM(NSInteger, EMActivityWeChatStatusCode) {
    EMActivityWeChatStatusCodeSuccess    = 0,    /**< 成功    */
    EMActivityWeChatStatusCodeCommon     = -1,   /**< 普通错误类型    */
    EMActivityWeChatStatusCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    EMActivityWeChatStatusCodeSentFail   = -3,   /**< 发送失败    */
    EMActivityWeChatStatusCodeAuthDeny   = -4,   /**< 授权失败    */
    EMActivityWeChatStatusCodeUnsupport  = -5,   /**< 微信不支持    */
    EMActivityWeChatStatusCodeAppNotInstall= -6, /**< 未安装    */
};

UIKIT_EXTERN NSString *const EMActivityWeChatStatusCodeKey;
UIKIT_EXTERN NSString *const EMActivityWeChatStatusMessageKey;
UIKIT_EXTERN NSString *const EMActivityWeChatSummaryKey;
UIKIT_EXTERN NSString *const EMActivityWeChatAuthCodeKey;

UIKIT_EXTERN NSString *const EMActivityWeChatAccessTokenKey;
UIKIT_EXTERN NSString *const EMActivityWeChatRefreshTokenKey;
UIKIT_EXTERN NSString *const EMActivityWeChatExpirationDateKey;

UIKIT_EXTERN NSString *const EMActivityWeChatUserIdKey;
UIKIT_EXTERN NSString *const EMActivityWeChatOpenIdKey;
UIKIT_EXTERN NSString *const EMActivityWeChatUnionIdKey;
UIKIT_EXTERN NSString *const EMActivityWeChatNameKey;
UIKIT_EXTERN NSString *const EMActivityWeChatProfileImageURLKey;


UIKIT_EXTERN NSString *const EMActivityWeChatThumbImageKey;

@interface EMActivityWeChat : EMBridgeActivity

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareStringTitle;
@property (nonatomic, strong) NSURL *shareURL;
@property (nonatomic, strong) UIImage *shareThumbImage;
@property (nonatomic, strong) NSString *shareStringDesc;

@property (nonatomic, assign) EMWXScene scene;

@end

