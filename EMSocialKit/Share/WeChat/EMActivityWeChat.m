//
//  EMActivityWeChat.m
//

#define WITHOUT_SDK  1

#import "EMActivityWeChat.h"
#import "EMSocialSDK.h"
#import "NSString+SK_URLParameters.h"
#import "UIImage+SK_Resize.h"

NSString *const EMActivityWeChatStatusCodeKey       = @"EMActivityWeChatStatusCodeKey";
NSString *const EMActivityWeChatStatusMessageKey    = @"EMActivityWeChatStatusMessageKey";
NSString *const EMActivityWeChatSummaryKey          = @"EMActivityWeChatSummaryKey";
NSString *const EMActivityWeChatAuthCodeKey         = @"EMActivityWeChatAuthCodeKey";

NSString *const EMActivityWeChatAccessTokenKey      = @"accessToken";
NSString *const EMActivityWeChatRefreshTokenKey     = @"refreshToken";
NSString *const EMActivityWeChatExpirationDateKey   = @"expireDate";

NSString *const EMActivityWeChatUserIdKey           = @"openId";
NSString *const EMActivityWeChatOpenIdKey           = @"openId";
NSString *const EMActivityWeChatUnionIdKey          = @"unionId";
NSString *const EMActivityWeChatNameKey             = @"name";           // WeChat昵称
NSString *const EMActivityWeChatProfileImageURLKey  = @"profileImageURL";// WeChat头像

NSString *const EMActivityWeChatThumbImageKey       = @"thumbimage";
NSString *const EMActivityWeChatDescriptionKey      = @"descstring";

static NSString *const EMActivityWeChatURL          = @"weixin://";
static NSString *const kWeChatAccessTokenURL        = @"https://api.weixin.qq.com/sns/oauth2/access_token";
static NSString *const kWeChatUserInfoURL           = @"https://api.weixin.qq.com/sns/userinfo";

@interface EMActivityWeChat ()

@property (nonatomic, copy) NSString* state;
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation EMActivityWeChat

+ (void)registerApp {
}

- (NSString *)scope {
    return @"snsapi_userinfo";
}

+ (BOOL)isAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:EMActivityWeChatURL]];
}

- (BOOL)isAppInstalled {
    return [[self class] isAppInstalled];
}


#pragma mark - 
#pragma mark - Share
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if ([self isAppInstalled]) {
        for (id activityItem in activityItems) {
            if ([activityItem isKindOfClass:[NSString class]]) {
                return YES;
            } if ([activityItem isKindOfClass:[UIImage class]]) {
                return YES;
            } else if ([activityItem isKindOfClass:[NSData class]]) {
                return YES;
            } else if ([activityItem isKindOfClass:[NSURL class]]) {
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
            NSDictionary *dict = activityItem;
            if ([dict.allKeys containsObject:EMActivityWeChatThumbImageKey] &&
                [dict[EMActivityWeChatThumbImageKey] isKindOfClass:[UIImage class]]) {
                self.shareThumbImage = dict[EMActivityWeChatThumbImageKey];
            }
            /*
            if ([dict.allKeys containsObject:EMActivityWeChatDescriptionKey] &&
                [dict[EMActivityWeChatDescriptionKey] isKindOfClass:[NSString class]]) {
                self.shareStringDesc = dict[EMActivityWeChatDescriptionKey];
            }
             */
        }
    }
}

- (void)performActivity {
    self.isLogin = NO;
    if ([self handleAppNotInstall]) {
        return;
    }
    
    NSMutableDictionary *messageInfo = [NSMutableDictionary dictionary];
    messageInfo[@"result"] = @"1";
    messageInfo[@"returnFromApp"] = @"0";
    messageInfo[@"scene"] = @(self.scene).stringValue;
    messageInfo[@"result"] = @1;
    messageInfo[@"sdkver"] = @"1.5";
    messageInfo[@"command"] = @"1010";

    
    if (self.shareStringTitle) {
        messageInfo[@"title"] = self.shareStringTitle;
    }
    
    if (self.shareStringDesc) {
        messageInfo[@"description"] = self.shareStringDesc;
    }
    
    UIImage *thumbImage = self.shareThumbImage;
    
    if (!thumbImage) {
        thumbImage = self.shareImage;
    }

    if (thumbImage) {
        messageInfo[@"thumbData"] = [self optimizedThumbImageFromOriginal:thumbImage];
    }
    
    if (self.shareURL) {
        messageInfo[@"objectType"] = @"5";
        messageInfo[@"mediaUrl"] = self.shareURL.absoluteString;
    } else if (self.shareImage) {
        messageInfo[@"objectType"] = @"2";
        messageInfo[@"fileData"] = UIImageJPEGRepresentation(self.shareImage, 1);
    } else {
        // Text share
        messageInfo[@"command"] = @"1020";
    }

    NSData *data = [NSPropertyListSerialization dataWithPropertyList:@{EMCONFIG(tencentWeixinAppId):messageInfo} format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL];
    [[UIPasteboard generalPasteboard] setData:data forPasteboardType:@"content"];

    NSString *wechatURLString = [NSString stringWithFormat:@"weixin://app/%@/sendreq/?",EMCONFIG(tencentWeixinAppId)];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:wechatURLString]];
    
    [self activityDidFinish:YES];
    
}


#pragma mark - 
#pragma mark - Login
- (BOOL)canPerformLogin {
    return [self isAppInstalled];
}

- (void)performLogin {
    self.isLogin = YES;
    
    if ([self handleAppNotInstall]) {
        return;
    }
    
    NSString *wechatURLString = [NSString stringWithFormat:@"weixin://app/%@/auth/?scope=%@&state=Weixinauth", EMCONFIG(tencentWeixinAppId),[self scope]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:wechatURLString]];
    
}


#pragma mark -
#pragma mark - HandleURL
- (BOOL)canHandleOpenURL:(NSURL *)url {
    NSString *urlString = [url absoluteString];

    BOOL can = [urlString rangeOfString:@"wx"].location != NSNotFound;
    if (can && [[url absoluteString] rangeOfString:@"pay"].location == NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)handleOpenURL:(NSURL *)URL {
    NSString *urlString = [URL absoluteString];
    
    BOOL can = [urlString rangeOfString:@"wx"].location != NSNotFound;
    if (can && [urlString rangeOfString:@"pay"].location == NSNotFound) {
        if (self.isLogin) {
            return [self handleOpenLoginURL:URL];
        } else {
            return [self handleOpenShareURL:URL];
        }
    }
    return NO;
}

- (BOOL)handleOpenLoginURL:(NSURL *)URL {
    NSString *urlString = [URL absoluteString];
    if ([urlString rangeOfString:@"wx"].location == NSNotFound) {
        return NO;
    }
    

    // WeChat OAuth
    NSString *query = [URL query];
    NSDictionary *parameters = [query SK_URLParameters];
    NSString *state = parameters[@"state"];
    if ([state isEqualToString:@"Weixinauth"]) {
        NSString *code = parameters[@"code"];
        
        if (code.length == 0) {
            [self _handleLoginError];
        } else {
            [self getAccessTokenWithCode:code];
        }
        return YES;
    }
    
    return YES;
}

- (BOOL)handleOpenShareURL:(NSURL *)URL {
    NSString *urlString = [URL absoluteString];
    if ([urlString rangeOfString:@"wx"].location == NSNotFound) {
        return NO;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    NSData *messageData = [[UIPasteboard generalPasteboard] dataForPasteboardType:@"content"];
    NSDictionary *message = [NSPropertyListSerialization propertyListWithData:messageData options:0 format:0 error:NULL];
    
    NSDictionary *messageInfo = message[EMCONFIG(tencentWeixinAppId)];
    
    NSInteger generalErrorCode = 0;
    
    NSString *result = messageInfo[@"result"];
    if(result) {
        NSInteger errorCode = [result integerValue];
        userInfo[EMActivityWeChatStatusCodeKey] = @(errorCode);
        NSString *errorMessage = [[self errorMessages] objectForKey:@(errorCode)];
        if (errorMessage) {
            userInfo[EMActivityWeChatStatusMessageKey] = errorMessage;
        }
        
        if (errorCode == EMActivityWeChatStatusCodeSuccess) {
            generalErrorCode = EMActivityGeneralStatusCodeSuccess;
        } else if (errorCode == EMActivityWeChatStatusCodeUserCancel) {
            generalErrorCode = EMActivityGeneralStatusCodeUserCancel;
        } else {
            generalErrorCode = EMActivityGeneralStatusCodeCommonFail;
        }
    }
    
    userInfo[EMActivityGeneralStatusCodeKey] = @(generalErrorCode);
    NSString *errorMessage = [[self class] errorMessageWithCode:generalErrorCode];
    userInfo[EMActivityGeneralMessageKey] = errorMessage;

    [self handledShareResponse:userInfo error:nil];
    
    return YES;
}

- (BOOL)handleAppNotInstall {
    NSMutableDictionary *userInfo = @{}.mutableCopy;
    userInfo[EMActivityWeChatStatusCodeKey] = @(EMActivityWeChatStatusCodeAppNotInstall);
    userInfo[EMActivityWeChatStatusMessageKey] = [self errorMessages][@(EMActivityWeChatStatusCodeAppNotInstall)];
    
    userInfo[EMActivityGeneralStatusCodeKey] = @(EMActivityGeneralStatusCodeNotInstall);
    NSString *errorMessage = [[self class] errorMessageWithCode:EMActivityGeneralStatusCodeNotInstall];
    userInfo[EMActivityGeneralMessageKey] = errorMessage;
    
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


- (void)handledLoginResponse:(NSDictionary *)response error:(NSError *)error {
    
    [super handledLoginResponse:response error:error];
}


- (void)getAccessTokenWithCode:(NSString *)code {
    
    NSString *appID = EMCONFIG(tencentWeixinAppId);
    NSString *appKey = EMCONFIG(tencentWeixinAppKey);

    NSAssert(appID.length > 0, @"tencentWeixinAppId shouldn't be nil");
    NSAssert(appKey.length > 0, @"tencentWeixinAppKey shouldn't be nil");

    NSString *accessTokenURL = [NSString stringWithFormat:@"%@?appid=%@&secret=%@&grant_type=authorization_code&code=%@", kWeChatAccessTokenURL, appID,appKey, code];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:accessTokenURL]];
    request.HTTPMethod = @"POST";
    NSURLSession *session = [NSURLSession sharedSession];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSDictionary *profile = nil;
                                            if (!error) {
                                                profile = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                
                                                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

                                                NSString *userId = profile[@"openid"];
                                                NSString *unionid = profile[@"unionid"];
                                                NSString *accessToken = profile[@"access_token"];
                                                NSString *refreshToken = profile[@"refresh_token"];
                                                NSInteger expireIn = [profile[@"expire_in"] integerValue];
                                                
                                                userInfo[EMActivityWeChatUserIdKey] = userId;
                                                userInfo[EMActivityWeChatUnionIdKey] = unionid;
                                                userInfo[EMActivityWeChatAccessTokenKey] = accessToken;
                                                userInfo[EMActivityWeChatRefreshTokenKey] = refreshToken;
                                                userInfo[EMActivityWeChatExpirationDateKey] = [NSDate dateWithTimeIntervalSinceNow:expireIn];
  
                                                [self getUserInfoWithAccessToken:accessToken openId:userId result:^(NSDictionary *userInfo_) {
                                                    [userInfo addEntriesFromDictionary:userInfo_];
                                                    [self _handledLoginInMainThreadResponse:userInfo error:nil];
                                                }];
                                                
                                            } else {
                                                [self _handledLoginInMainThreadResponse:nil error:error];
                                            }
                                            
                                        }];
    
    // 启动任务
    [task resume];
}

- (void)_handledLoginInMainThreadResponse:(NSDictionary *)response error:(NSError *)error {
    if ([NSThread isMainThread]) {
        [self handledLoginResponse:response error:error];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handledLoginResponse:response error:error];
        });
    }
}


- (void)getUserInfoWithAccessToken:(NSString *)token openId:(NSString *)openId result:(void (^)(NSDictionary *userInfo))result{
    
    NSString *userInfoURL = [NSString stringWithFormat:@"%@?openid=%@&access_token=%@", kWeChatUserInfoURL, openId, token];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:userInfoURL]];
    request.HTTPMethod = @"POST";
    NSURLSession *session = [NSURLSession sharedSession];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSDictionary *profile = nil;
                                            if (!error) {
                                                profile = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                
                                                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                                                
                                                NSString *nickname = profile[@"nickname"];
                                                NSString *headimgurl = profile[@"headimgurl"];
                                                
                                                userInfo[EMActivityWeChatNameKey] = nickname;
                                                userInfo[EMActivityWeChatProfileImageURLKey] = headimgurl;
                                                result(userInfo);
                                            } else {
                                                result(nil);
                                            }
                                            
                                        }];
    
    // 启动任务
    [task resume];
}


- (void)_handleLoginError {
    __block NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

    userInfo[EMActivityWeChatStatusCodeKey] = @(EMActivityWeChatStatusCodeSentFail);
    userInfo[EMActivityWeChatStatusMessageKey] = [self errorMessages][@(EMActivityWeChatStatusCodeSentFail)];
    
    userInfo[EMActivityGeneralStatusCodeKey] = @(EMActivityGeneralStatusCodeCommonFail);
    NSString *errorMessage = [[self class] errorMessageWithCode:EMActivityGeneralStatusCodeCommonFail];
    userInfo[EMActivityGeneralMessageKey] = errorMessage;
    
    [self handledLoginResponse:userInfo error:nil];

}



- (NSDictionary *)errorMessages{
    return
    @{
      @(EMActivityWeChatStatusCodeSuccess):         @"分享成功",
      @(EMActivityWeChatStatusCodeCommon):          @"普通类型错误",
      @(EMActivityWeChatStatusCodeUserCancel):      @"用户取消发送",
      @(EMActivityWeChatStatusCodeSentFail):        @"发送失败",
      @(EMActivityWeChatStatusCodeAuthDeny):        @"授权失败",
      @(EMActivityWeChatStatusCodeUnsupport):       @"不支持的请求",
      @(EMActivityWeChatStatusCodeAppNotInstall):   @"您未安装微信客户端",
      };
}

#pragma mark -
#pragma mark Private Methods
- (NSData *)optimizedThumbImageFromOriginal:(UIImage *)oriImage {
    UIImage *image = [oriImage SK_resizedImageWithMaximumSize:CGSizeMake(240.f, 240.f)];
    
    CGFloat compressionQuality = 0.7;
    NSInteger dataLengthCeiling = 31500;
    
    NSData *imageData;
    do {
        compressionQuality -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compressionQuality);
    } while (imageData && [imageData length] >= dataLengthCeiling && compressionQuality > 0);
    
    return imageData;
    
}

@end
