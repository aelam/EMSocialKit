//
//  EMQQActivity.m
//  Pods
//
//  Created by Ryan Wang on 6/8/15.
//
//

#import "EMActivityQQ.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "EMSocialSDK.h"
#import <UIImage-ResizeMagick/UIImage+ResizeMagick.h>

NSString *const UIActivityTypePostToQQ      = @"UIActivityTypePostToQQ";

NSString *const EMActivityQQAccessTokenKey  = @"EMActivityQQAccessTokenKey";
NSString *const EMActivityQQRefreshTokenKey = @"EMActivityQQRefreshTokenKey";
NSString *const EMActivityQQExpirationDateKey= @"EMActivityQQExpirationDateKey";

NSString *const EMActivityQQUserIdKey       = @"EMActivityQQUserIdKey";
NSString *const EMActivityQQNameKey         = @"EMActivityQQNameKey";           // QQ昵称
NSString *const EMActivityQQProfileImageURLKey= @"EMActivityQQProfileImageURLKey";// QQ头像

NSString *const EMActivityQQStatusCodeKey   = @"EMActivityQQStatusCodeKey";
NSString *const EMActivityQQStatusMessageKey= @"EMActivityQQStatusMessageKey";


@interface EMActivityQQ() <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong) UIImage *shareImage;  // only support one image
@property (nonatomic, strong) UIImage *thumbImage;  // only support one image
@property (nonatomic, strong) NSURL *shareURL;
@property (nonatomic, strong) NSString *shareStringTitle;
@property (nonatomic, strong) NSString *shareStringDesc;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) NSMutableDictionary *emAuthInfo; //用于保存登陆信息，然后请求用户信息之后返回

@end


@implementation EMActivityQQ



- (NSString *)activityType {
    return UIActivityTypePostToQQ;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"EMSocialKit.bundle/qq"];
}

- (NSString *)activityTitle {
    return @"QQ";
}

////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)permissions {
    return @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
}


+ (void)registerApp {
}


- (BOOL)isAppInstalled {
    return [TencentOAuth iphoneQQInstalled];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if ([TencentOAuth iphoneQQSupportSSOLogin]) {
        for (id activityItem in activityItems) {
            if ([activityItem isKindOfClass:[UIImage class]]) {
                return YES;
            } else if ([activityItem isKindOfClass:[NSData class]]) {
                return YES;
            } else if ([activityItem isKindOfClass:[NSURL class]]) {
                return YES;
            } else if ([activityItem isKindOfClass:[NSString class]]) {
                return YES;
            } else if ([activityItem isKindOfClass:[NSDictionary class]]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[UIImage class]] && !self.shareImage) {
            self.shareImage = activityItem;
        } else if ([activityItem isKindOfClass:[NSData class]] && !self.shareImage) {
            self.shareImage = [UIImage imageWithData:activityItem];
        } else if ([activityItem isKindOfClass:[NSURL class]] && !self.shareURL) {
            self.shareURL = activityItem;
        } else if ([activityItem isKindOfClass:[NSString class]] && !self.shareStringTitle) {
            self.shareStringTitle = activityItem;
        } else if ([activityItem isKindOfClass:[NSString class]] && !self.shareStringDesc) {
            self.shareStringDesc = activityItem;
        } else if ([activityItem isKindOfClass:[NSDictionary class]]) {
            self.thumbImage = activityItem[@"thumbimage"];
        }
    }
}

- (void)performActivity {
    
    self.isLogin = NO;
    [super performActivity];
    
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:EMCONFIG(tencentAppId) andDelegate:self];
    if (self.shareURL) {
        UIImage *image = self.shareImage;
        if (image == nil) {
            image = self.thumbImage;
        }
        
//        UIImage *previewImage = [image resizedImageWithMaximumSize:CGSizeMake(300, 300)];
        
        QQApiURLObject *newsObj = [QQApiURLObject objectWithURL:self.shareURL title:self.shareStringTitle description:self.shareStringDesc previewImageData:UIImageJPEGRepresentation(image, 0.5)  targetContentType:QQApiURLTargetTypeNews];
        [newsObj setCflag:kQQAPICtrlFlagQQShare];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        [QQApiInterface sendReq:req];
    } else if (self.shareImage) {
        UIImage *previewImage = [self.shareImage resizedImageWithMaximumSize:CGSizeMake(200, 200)];
        UIImage *image = [self.shareImage resizedImageByWidth:640];
        
        NSData *previewImageData = UIImageJPEGRepresentation(previewImage, 1);
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        QQApiImageObject *newsObj = [QQApiImageObject objectWithData:imageData previewImageData:previewImageData title:self.shareStringTitle description:self.shareStringDesc];
        [newsObj setCflag:kQQAPICtrlFlagQQShare];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        [QQApiInterface sendReq:req];
    } else {
        QQApiObject *newsObj = [[QQApiObject alloc] init];
        newsObj.title = self.shareStringTitle;
        newsObj.description = self.shareStringDesc;
        [newsObj setCflag:kQQAPICtrlFlagQQShare];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        [QQApiInterface sendReq:req];
    }
    
    [self activityDidFinish:YES];
}


- (BOOL)canPerformLogin {
    return YES;
}

- (void)performLogin {
    self.isLogin = YES;

    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:EMCONFIG(tencentAppId) andDelegate:self];
    [self.tencentOAuth authorize:self.permissions inSafari:NO];
}



- (BOOL)handleOpenURL:(NSURL *)url {
    if (self.isLogin) {
        return [TencentOAuth HandleOpenURL:url];
    } else {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }
}


- (void)tencentDidLogin {
    
    NSString *openId = _tencentOAuth.openId;
    NSString *accessToken = _tencentOAuth.accessToken;
    NSDate  *expirationDate = _tencentOAuth.expirationDate;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (openId) {
        userInfo[EMActivityQQUserIdKey] = openId;
    }
    
    if (accessToken) {
        userInfo[EMActivityQQAccessTokenKey] = accessToken;
    }
    
    if (expirationDate) {
        userInfo[EMActivityQQExpirationDateKey] = expirationDate;
    }
    
    userInfo[EMActivityQQStatusCodeKey] = @(EMActivityQQStatusCodeSuccess);
    userInfo[EMActivityQQStatusMessageKey] = [self errorMessages][@(EMActivityQQStatusCodeSuccess)];
    
    self.emAuthInfo = userInfo;
    [self.tencentOAuth getUserInfo];
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    [self emQQDidLogIn:nil];
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[EMActivityQQStatusCodeKey] = @(EMActivityQQStatusCodeNetworkError);
    userInfo[EMActivityQQStatusMessageKey] = [self errorMessages][@(EMActivityQQStatusCodeNetworkError)];
    
    if (self.isLogin) {
        [self handledLoginResponse:userInfo error:nil];
    } else {
        [self handledShareResponse:userInfo error:nil];
    }
}


// MARK: TencentDelegate
- (void)tencentDidLogout {
    
}

/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions {
    return YES;
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
//- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth {
//    return YES;
//}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth {
    
}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason {
    
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response {
    NSMutableDictionary *userInfo = self.emAuthInfo;
    NSString *QQName = [response.jsonResponse objectForKey:@"nickname"];
    if ([QQName isKindOfClass:[NSString class]]) {
        userInfo[EMActivityQQNameKey] = QQName;
    }

    NSString *profileImageURL = [response.jsonResponse objectForKey:@"figureurl_2"];
    if ([profileImageURL isKindOfClass:[NSString class]]) {
        userInfo[EMActivityQQProfileImageURLKey] = profileImageURL;
    }

    
    
    [self emQQDidLogIn:self.emAuthInfo];
}

- (void)responseDidReceived:(APIResponse*)response forMessage:(NSString *)message {
    
}

- (void)cgiRequest:(TCAPIRequest *)request didResponse:(APIResponse *)response {
    
}


- (BOOL)onTencentReq:(TencentApiReq *)req {
    return YES;
}


// 这个返回包含了请求username的信息
- (void)emQQDidLogIn:(NSDictionary *)userInfo {
    
    if (userInfo == nil) {
        NSMutableDictionary *newUserInfo = [NSMutableDictionary dictionary];
        newUserInfo[EMActivityQQStatusCodeKey] = @(EMActivityQQStatusCodeUserCancel);
        newUserInfo[EMActivityQQStatusMessageKey] = [self errorMessages][@(EMActivityQQStatusCodeUserCancel)];
        userInfo = newUserInfo;
    }
    
    if (self.isLogin) {
        [self handledLoginResponse:userInfo error:nil];
    } else {
        [self handledShareResponse:userInfo error:nil];
    }
}

// MARK:  用来处理分享消息
- (void)onReq:(QQBaseReq *)req {
    
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:resp.result forKey:EMActivityQQStatusCodeKey];
    NSString *message = nil;// = resp.errorDescription; //默认错误描述是英文
    if (message == nil) {
        message = [[self errorMessages] objectForKey:@([resp.result integerValue])];
    }
    if (message) {
        [userInfo setObject:message forKey:EMActivityQQStatusMessageKey];
    }
    
    [self handledShareResponse:userInfo error:nil];
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}


- (NSDictionary *)errorMessages{
    return
    @{
      @(EMActivityQQStatusCodeSuccess):          @"分享成功",
      @(EMActivityQQStatusCodeUserCancel):       @"用户取消发送",
      @(EMActivityQQStatusCodeSentFail):         @"发送失败",
      @(EMActivityQQStatusCodeAuthDeny):         @"授权失败",
      //      @(EMActivityQQStatusCodeUserCancelInstall):@"用户取消安装QQ客户端",
      @(EMActivityQQStatusCodePayFail):          @"支付失败",
      @(EMActivityQQStatusCodeShareInSDKFailed): @"分享失败",
      @(EMActivityQQStatusCodeUnsupport):        @"不支持的请求",
      @(EMActivityQQStatusCodeNetworkError):     @"网络错误",
      @(EMActivityQQStatusCodeUnknown):          @"未知错误",
      };
}


@end
