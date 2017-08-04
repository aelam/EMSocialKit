//
//  EMQQActivity.m
//  Pods
//
//  Created by Ryan Wang on 6/8/15.
//
//

#import "EMActivityQQ.h"
#import "EMSocialSDK.h"

#import "NSDictionary+SK_toQuery.h"
#import "NSString+SK_URLParameters.h"
#import "UIImage+SocialBundle.h"
#import "UIImage+SK_Resize.h"
#import "EMSocialWebViewController.h"
#import "NSString+SK_URLEncode.h"

NSString *const UIActivityTypePostToQQ          = @"UIActivityTypePostToQQ";

NSString *const EMActivityQQAccessTokenKey      = @"accessToken";
NSString *const EMActivityQQRefreshTokenKey     = @"refreshToken";
NSString *const EMActivityQQExpirationDateKey   = @"expireDate";

NSString *const EMActivityQQUserIdKey           = @"userId";
NSString *const EMActivityQQNameKey             = @"name";           // QQ昵称
NSString *const EMActivityQQProfileImageURLKey  = @"profileImageURL";// QQ头像

NSString *const EMActivityQQStatusCodeKey       = @"EMActivityQQStatusCodeKey";
NSString *const EMActivityQQStatusMessageKey    = @"EMActivityQQStatusMessageKey";

static NSString *const kQQAuthorizeURL           = @"https://graph.qq.com/oauth2.0/authorize";
static NSString *const kQQAccessTokenURL           = @"https://graph.qq.com/oauth2.0/token";
static NSString *const kQQOpenIdURL           = @"https://graph.qq.com/oauth2.0/me";

static NSString *const kQQGetUserInfoURL        = @"https://graph.qq.com/user/get_user_info";
//static NSString *const kQQAccessTokenURL        = @"https://xui.ptlogin2.qq.com/cgi-bin/xlogin";
static NSString *const kQQRedirectURL           = @"auth://www.qq.com";

@interface EMActivityQQ() <UIWebViewDelegate>

@property (nonatomic, strong) UIImage *shareImage;  // only support one image
@property (nonatomic, strong) UIImage *thumbImage;  // only support one image
@property (nonatomic, strong) NSURL *shareURL;
@property (nonatomic, strong) NSString *shareStringTitle;
@property (nonatomic, strong) NSString *shareStringDesc;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) UINavigationController *webAuthNavigationController;

@end


@implementation EMActivityQQ



- (NSString *)activityType {
    return UIActivityTypePostToQQ;
}

- (UIImage *)activityImage {
    return [UIImage socialImageNamed:@"EMSocialKit.bundle/qq"];
}

- (NSString *)activityTitle {
    return @"QQ";
}

- (NSString *)scope {
    return @"get_user_info";
}

////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)permissions {
    return @[@"get_user_info"];
}

- (NSString *)_qqCallbackName {
    NSString *appId = EMCONFIG(tencentAppId);
    return [NSString stringWithFormat:@"QQ%08llx", [appId longLongValue]];
}

+ (void)registerApp {
}

+ (BOOL)isAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqapi://"]];
}

- (BOOL)isAppInstalled {
    return [[self class] isAppInstalled];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if (![self isAppInstalled]) {
        return NO;
    }
    
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

    if ([self handleAppNotInstall]) {
        return;
    }
    
#if 1
    NSString *bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    if (!bundleName) {
        bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    }

    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"version"] = @1;
    parameters[@"callback_type"] = @"scheme";
    parameters[@"generalpastboard"] = @1;
    parameters[@"thirdAppDisplayName"] = [[bundleName dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];;
    parameters[@"callback_name"] = [self _qqCallbackName];
    parameters[@"src_type"] = @"app";
    parameters[@"shareType"] = @0;
    parameters[@"cflag"] = @4;
    
    if (self.shareURL || self.shareImage) {
        parameters[@"objectlocation"] = @"pasteboard";
        if (self.shareStringTitle) {
            parameters[@"title"] = [[self.shareStringTitle dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        }
        if (self.shareStringDesc) {
            parameters[@"description"] = [[self.shareStringDesc dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        }
    }
    
    if (self.shareURL) {

        parameters[@"file_type"] = @"news";

        UIImage *image = self.thumbImage;
        if (image == nil) {
            image = self.shareImage;
        }

        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSDictionary *dic = @{@"previewimagedata":imageData};
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
            [[UIPasteboard generalPasteboard] setData:data forPasteboardType:@"com.tencent.mqq.api.apiLargeData"];
        }

        parameters[@"url"] = [[[self.shareURL absoluteString] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        
        
    } else if (self.shareImage) {
        parameters[@"objectlocation"] = @"pasteboard";
        
        if (self.shareStringTitle) {
            parameters[@"title"] = [[self.shareStringTitle dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        }
        
        if (self.shareStringDesc) {
            parameters[@"description"] = [[self.shareStringDesc dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        }

        parameters[@"file_type"] = @"img";
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (self.thumbImage) {
            NSData *thumbnail = UIImageJPEGRepresentation(self.thumbImage, 1);
            dic[@"previewimagedata"] = thumbnail;
        }
        dic[@"file_data"] = UIImageJPEGRepresentation(self.shareImage, 1);
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [[UIPasteboard generalPasteboard] setData:data forPasteboardType:@"com.tencent.mqq.api.apiLargeData"];

    } else {
        // 纯文本
        parameters[@"file_type"] = @"text";
        parameters[@"cflag"] = @0;

        NSString *des = self.shareStringTitle;
        if (des && self.shareStringDesc) {
            des = [des stringByAppendingFormat:@" %@", self.shareStringDesc];
        }
        parameters[@"file_data"] = [[des dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    }
    
    NSMutableString *qqURL = [NSMutableString stringWithFormat:@"mqqapi://share/to_fri?"];
    NSString *query = [parameters SK_toQuery];
    NSString *fullQQURL = [qqURL stringByAppendingString:query];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullQQURL]];
    
    
#else
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:EMCONFIG(tencentAppId) andDelegate:self];
    if (self.shareURL) {
        UIImage *image = self.shareImage;
        if (image == nil) {
            image = self.thumbImage;
        }
        
        QQApiURLObject *newsObj = [QQApiURLObject objectWithURL:self.shareURL title:self.shareStringTitle description:self.shareStringDesc previewImageData:UIImageJPEGRepresentation(image, 0.5)  targetContentType:QQApiURLTargetTypeNews];
        [newsObj setCflag:kQQAPICtrlFlagQQShare];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        [QQApiInterface sendReq:req];
    } else if (self.shareImage) {
        UIImage *previewImage = [self.shareImage SK_resizedImageWithMaximumSize:CGSizeMake(200, 200)];
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
#endif
    [self activityDidFinish:YES];
}


- (BOOL)canPerformLogin {
    return YES;
}

- (void)performLogin {
    self.isLogin = YES;
    
    if (![self isAppInstalled]) {
        [self performLoginInWeb];
        
        return;
    }
    
    NSString *bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
    if (!bundleName) {
        bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    }
    
    NSString *appId = EMCONFIG(tencentAppId);
    
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    paramaters[@"app_id"] = appId;
    paramaters[@"client_id"] = appId;
    paramaters[@"app_name"] = bundleName;
    paramaters[@"response_type"] = @"token";
    paramaters[@"scope"] = [self scope];
    paramaters[@"sdkp"] = @"i";
    paramaters[@"sdkv"] = @"2.9";
    paramaters[@"status_machine"] = [UIDevice currentDevice].model;
    paramaters[@"status_os"] = [UIDevice currentDevice].systemVersion;
    paramaters[@"status_version"] = [UIDevice currentDevice].systemVersion;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:paramaters];
    [[UIPasteboard generalPasteboard] setData:data forPasteboardType:[NSString stringWithFormat:@"com.tencent.tencent%@",appId]];
    
    NSString *QQURLString = [NSString stringWithFormat:@"mqqOpensdkSSoLogin://SSoLogin/tencent%@/com.tencent.tencent\%@?generalpastboard=1", appId,appId];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:QQURLString]];
}



- (BOOL)handleOpenURL:(NSURL *)url {
    if (self.isLogin) {
        return [self handleLoginOpenURL:url];
    } else {
        return [self handleShareOpenURL:url];
    }
}

- (BOOL)handleLoginOpenURL:(NSURL *)url {
    
    NSMutableDictionary *message;
    
    NSInteger errorCode = 0;
    NSInteger generalErrorCode = 0;

    if ([[url scheme] hasPrefix:@"tencent"]) {
        NSString *appId = EMCONFIG(tencentAppId);

        NSData *messageData = [[UIPasteboard generalPasteboard] dataForPasteboardType:[@"com.tencent.tencent" stringByAppendingString:appId]];
        message = [NSKeyedUnarchiver unarchiveObjectWithData:messageData];
    } else if ([[url scheme] hasPrefix:@"auth"]) {
        message = [[url query] SK_URLParameters].mutableCopy;
        NSString *accessToken = message[@"access_token"];
        if (accessToken.length > 0) {
            message[@"ret"] = @"0";
        }
    }
    
    __block NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (message) {
        NSString *accessToken = message[@"access_token"];
        NSString *expires_in = message[@"expires_in"];
        NSString *openid = message[@"openid"];
        
        
        if (message[@"ret"]) {
            errorCode = [message[@"ret"] integerValue];
            
            
            if (errorCode == EMActivityQQStatusCodeSuccess) {
                generalErrorCode = EMActivityGeneralStatusCodeSuccess;
            } else if (errorCode == EMActivityQQStatusCodeUserCancel) {
                generalErrorCode = EMActivityGeneralStatusCodeUserCancel;
            } else if (errorCode == EMActivityQQStatusCodeSentFail) {
                generalErrorCode = EMActivityGeneralStatusCodeCommonFail;
            } else {
                generalErrorCode = EMActivityGeneralStatusCodeUnknownFail;
            }
            
            
            if (errorCode == EMActivityGeneralStatusCodeSuccess) {
                userInfo[EMActivityQQAccessTokenKey] = accessToken;
                userInfo[EMActivityQQExpirationDateKey] = expires_in;
                userInfo[EMActivityQQUserIdKey] = openid;
                
                
                userInfo[EMActivityGeneralStatusCodeKey] = @(EMActivityGeneralStatusCodeSuccess);
                userInfo[EMActivityGeneralMessageKey] = [[self class] errorMessageWithCode:EMActivityGeneralStatusCodeSuccess];
                
                NSURLSession *session = [NSURLSession sharedSession];
                NSString *urlString = [NSString stringWithFormat:@"%@?access_token=%@&oauth_consumer_key=%@&openid=%@&format=json",
                                       kQQGetUserInfoURL, accessToken, EMCONFIG(tencentAppId), openid];
                NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:
                                          ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                              if (!error) {
                                                  NSDictionary *profile = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                  userInfo[EMActivityQQNameKey] = profile[@"nickname"];
                                                  userInfo[EMActivityQQProfileImageURLKey] = profile[@"figureurl_2"];
                                                  
                                                  if ([NSThread currentThread] == [NSThread mainThread]) {
                                                      [super handledLoginResponse:userInfo error:error];
                                                  } else {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [super handledLoginResponse:userInfo error:error];
                                                      });
                                                  }
                                              }
                                          }];
                
                [task resume];
                
                return YES;
            } else {
                
            }
        }
        
        
        
    } else {
        errorCode = EMActivityQQStatusCodeUnknown;
        generalErrorCode = EMActivityGeneralStatusCodeUnknownFail;
    }
    
    userInfo[EMActivityQQStatusMessageKey] = [self errorMessages][@(errorCode)];
    userInfo[EMActivityGeneralMessageKey] = [[self class] errorMessageWithCode:generalErrorCode];
    [super handledLoginResponse:userInfo error:nil];
    
    return YES;
}


- (BOOL)handleShareOpenURL:(NSURL *)url {
    NSString *query = [url query];
    NSDictionary *parameters = [query SK_URLParameters];
    NSString *error = parameters[@"error"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    NSInteger errorCode = 0;
    NSInteger generalErrorCode = 0;
    
    if (error) {
        errorCode = [error integerValue];
        
        if (errorCode == EMActivityQQStatusCodeSuccess) {
            generalErrorCode = EMActivityGeneralStatusCodeSuccess;
        } else if (errorCode == EMActivityQQStatusCodeUserCancel) {
            generalErrorCode = EMActivityGeneralStatusCodeUserCancel;
        } else if (errorCode == EMActivityQQStatusCodeSentFail) {
            generalErrorCode = EMActivityGeneralStatusCodeCommonFail;
        } else {
            generalErrorCode = EMActivityGeneralStatusCodeUnknownFail;
        }
    } else {
        generalErrorCode = EMActivityGeneralStatusCodeUnknownFail;
    }
    
    userInfo[EMActivityQQStatusCodeKey] = @(errorCode);
    userInfo[EMActivityQQStatusMessageKey] = [self errorMessages][@(errorCode)];

    userInfo[EMActivityGeneralStatusCodeKey] = @(generalErrorCode);
    userInfo[EMActivityGeneralMessageKey] = [[self class] errorMessageWithCode:generalErrorCode];

    [super handledShareResponse:userInfo error:nil];
    
    return YES;
}


- (BOOL)handleAppNotInstall {
    NSMutableDictionary *userInfo = @{}.mutableCopy;
    
    userInfo[EMActivityGeneralStatusCodeKey] = @(EMActivityGeneralStatusCodeNotInstall);
    userInfo[EMActivityGeneralMessageKey] = [[self class] errorMessageWithCode:EMActivityGeneralStatusCodeNotInstall];
    userInfo[EMActivityQQStatusCodeKey] = @(EMActivityQQStatusCodeAppNotInstall);
    userInfo[EMActivityQQStatusMessageKey] = [self errorMessages][@(EMActivityQQStatusCodeAppNotInstall)];
    if (![self isAppInstalled]) {
        if (self.isLogin) {
            [self handledLoginResponse:userInfo error:nil];
        } else {
            [self handledShareResponse:userInfo error:nil];
        }
        return YES;
    }
    return NO;
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
      @(EMActivityQQStatusCodeAppNotInstall):    @"应用未安装",
      };
}

#pragma mark -
#pragma mark - WebApp OAuth2
- (void)performLoginInWeb {
    [self getAccessTokenInWeb];
}

- (void)getAccessTokenInWeb {
    NSString *appID = EMCONFIG(tencentAppId);
    
    NSString *authorizeTokenAPI = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&state=test&scope=%@", kQQAuthorizeURL,appID, [kQQRedirectURL SK_URLEncodedString], [self scope]];
    
    EMSocialWebViewController *webController = [[EMSocialWebViewController alloc] initWithURL:[NSURL URLWithString:authorizeTokenAPI]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webController];
    self.webAuthNavigationController = navigationController;
    UIViewController *presentingController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (presentingController.presentedViewController) {
        presentingController = presentingController.presentedViewController;
    }

    [presentingController presentViewController:navigationController animated:YES completion:^{
        webController.webView.delegate = self;
    }];
}

- (void)getOpenIdWithAccessToken:(NSString *)token result:(void(^)(NSDictionary *userInfo))result {

    NSString *accessTokenAPI = [NSString stringWithFormat:@"%@?access_token=%@", kQQOpenIdURL,token];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:accessTokenAPI]];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            if (!error) {
                                                NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                NSRange beginRange = [dataString rangeOfString:@"{"];
                                                NSRange endRange = [dataString rangeOfString:@"}"];

                                                if (beginRange.location != NSNotFound && endRange.location != NSNotFound) {
                                                    NSInteger location = beginRange.location;
                                                    NSInteger len = endRange.location - location + 1;
                                                    dataString = [dataString substringWithRange:NSMakeRange(location, len)];
                                                    NSData *resultData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                                                    NSDictionary *profile = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:nil];
                                                    NSString *openId= profile[@"openid"];
                                                    NSMutableDictionary *newUserInfo = [NSMutableDictionary dictionary];
                                                    newUserInfo[EMActivityQQUserIdKey] = openId;
                                                    newUserInfo[EMActivityGeneralStatusCodeKey] = @(EMActivityGeneralStatusCodeSuccess);
                                                    result(newUserInfo);
                                                }
                                                else {
                                                    NSMutableDictionary *newUserInfo = [NSMutableDictionary dictionary];
                                                    newUserInfo[EMActivityGeneralStatusCodeKey] = @(EMActivityGeneralStatusCodeCommonFail);
                                                    result(newUserInfo);
                                                }
                                            }
                                        }];
    
    // 启动任务
    [task resume];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = [request URL];
    if ([kQQRedirectURL rangeOfString:[URL host]].length > 0) {
        
        NSDictionary *parameters = [[URL fragment] SK_URLParameters];
        NSInteger cancel = [parameters[@"usercancel"] integerValue];
        if (cancel == 1) {
            NSDictionary *userInfo = @{EMActivityGeneralStatusCodeKey:@(EMActivityGeneralStatusCodeUserCancel)};
            [self handledLoginResponse:userInfo error:nil];
        }
        else
        {
            NSMutableDictionary *resultUserInfo = [NSMutableDictionary dictionaryWithDictionary:parameters];
            NSString *accessToken = parameters[@"access_token"];
            NSString *expires_in = parameters[@"expires_in"];
            NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:[expires_in integerValue]];
            resultUserInfo[EMActivityQQAccessTokenKey] = accessToken;
            resultUserInfo[EMActivityQQExpirationDateKey] = expireDate;
            
            [self getOpenIdWithAccessToken:accessToken result:^(NSDictionary *userInfo) {
                [resultUserInfo addEntriesFromDictionary:userInfo];
                [self handledLoginResponse:resultUserInfo error:nil];
            }];
        }
        
        [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:NULL];
        return NO;
    }
    
    return YES;
}


- (void)dealloc {
    self.webAuthNavigationController = nil;
}

@end
