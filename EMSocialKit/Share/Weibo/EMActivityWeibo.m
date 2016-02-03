//
//  EMActivityWeibo.m
//

#import "EMActivityWeibo.h"
#import "WeiboSDK.h"
#import "UIImage+ResizeMagick.h"
#import "EMSocialSDK.h"
#import "WeiboUser.h"

NSString *const EMActivityWeiboAccessTokenKey   = @"EMActivityWeiboAccessTokenKey";
NSString *const EMActivityWeiboRefreshTokenKey  = @"EMActivityWeiboRefreshTokenKey";
NSString *const EMActivityWeiboExpirationDateKey= @"EMActivityWeiboExpirationDateKey";

NSString *const EMActivityWeiboUserIdKey        = @"EMActivityWeiboUserIdKey";
NSString *const EMActivityWeiboUserNameKey      = @"EMActivityWeiboUserNameKey";
NSString *const EMActivityWeiboProfileImageURLKey= @"EMActivityWeiboProfileImageURLKey";// 头像

NSString *const EMActivityWeiboStatusCodeKey    = @"EMActivityWeiboStatusCodeKey";
NSString *const EMActivityWeiboStatusMessageKey = @"EMActivityWeiboStatusMessageKey";

NSString *const UIActivityTypePostToSinaWeibo = @"UIActivityTypePostToSinaWeibo";


@interface EMActivityWeibo () <WeiboSDKDelegate>

@property (nonatomic, strong) UIImage *shareImage; // only support one image
@property (nonatomic, strong) NSString *shareString;
@property (nonatomic, strong) NSURL *shareURL; // will be converted to String

@property (nonatomic, strong) WBBaseResponse *response;
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, strong) NSMutableDictionary *responseUserInfo;
@property (nonatomic, strong) NSOperationQueue *queue;


@end

@implementation EMActivityWeibo

+ (void)registerApp {
    [WeiboSDK registerApp:EMCONFIG(sinaWeiboConsumerKey)];
    [WeiboSDK enableDebugMode:YES];
}

- (NSString *)redirectURI {
    return EMCONFIG(sinaWeiboCallbackUrl);
}

- (NSString *)appId {
    return EMCONFIG(sinaWeiboConsumerKey);
}

- (NSString *)appSecret {
    return EMCONFIG(sinaWeiboConsumerSecret);
}

- (NSString *)scope {
    return @"all";
}


+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}

- (NSString *)activityType {
    return UIActivityTypePostToSinaWeibo;
}

- (NSString *)activityTitle {
    return @"新浪微博";
}

- (UIImage *)activityImage {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
        return [UIImage imageNamed:@"EMSocialKit.bundle/weibo"];
    else
        return [UIImage imageNamed:@"EMSocialKit.bundle/weibo"];
}

// URL will be converted to string
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id item in activityItems) {
        if ([item isKindOfClass:[UIImage class]]) {
            return YES;
        } else if ([item isKindOfClass:[NSData class]]) {
            return YES;
        } else if ([item isKindOfClass:[NSURL class]]) {
            return YES;
        } else if ([item isKindOfClass:[NSString class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id item in activityItems) {
        if ([item isKindOfClass:[UIImage class]] && !self.shareImage) {
            self.shareImage = [self optimizedImageFromOriginalImage:item];
        } else if ([item isKindOfClass:[NSData class]] && !self.shareImage) {
            self.shareImage = [self optimizedImageFromOriginalImage:[UIImage imageWithData:item]];
        } else if ([item isKindOfClass:[NSString class]]) {
            self.shareString = [(self.shareString ? : @"") stringByAppendingFormat:@"%@%@", (self.shareString ? @" " : @""), item];
        } else if ([item isKindOfClass:[NSURL class]]) {
            self.shareURL = item;
        } else
            NSLog(@"NCActivityWeibo: Unknown item type: %@", item);
    }
}

- (void)performActivity {
    self.isLogin = NO;
    
    [super performActivity];
    
    WBMessageObject *message = [WBMessageObject message];
    
    NSString *shareString = self.shareString;
#if 1
    if (self.shareURL) {
        // 长度太长需要截取
        NSString *shareURLString = [self.shareURL absoluteString];
        if (shareString.length >0 && shareString.length + shareURLString.length >= 136) {
            shareString = [shareString substringToIndex:136 - shareURLString.length];
            shareString = [shareString stringByAppendingFormat:@"... %@", self.shareURL];
        } else {
            shareString = [shareString stringByAppendingFormat:@" %@", self.shareURL];
        }
    }
    
    if (shareString) {
        message.text = shareString;
    }
#else
    if (self.shareURL) {
        WBWebpageObject *webObject = [WBWebpageObject object];
        webObject.objectID = [NSString stringWithFormat:@"%ld", time(NULL)];
        webObject.title = self.shareString;
        webObject.thumbnailData = UIImageJPEGRepresentation(self.shareImage, 0.3);
        webObject.webpageUrl = [self.shareURL absoluteString];
        message.mediaObject = webObject;
    }else
#endif
        if (self.shareImage) {
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = UIImageJPEGRepresentation(self.shareImage, 1);
            message.imageObject = imageObject;
        }
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.scope =  @"all";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    
    [WeiboSDK sendRequest:request];
    
    [self activityDidFinish:YES];
}


- (BOOL)canPerformLogin {
    return YES;
}


- (void)performLogin {
    self.isLogin = YES;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = self.redirectURI;// @"http://weibo.com";
    request.scope = self.scope;//@"all";
    
    [WeiboSDK sendRequest:request];
}


#pragma mark -
#pragma mark Private Methods
- (UIImage *)optimizedImageFromOriginalImage:(UIImage *)oriImage {
    // Resize if needed
    UIImage *result = (oriImage.size.width > 1600 || oriImage.size.height > 1600) ? [oriImage resizedImageByMagick:@"1600x1600"] : oriImage;
    
    return result;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}


#pragma mark - WBSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(response.statusCode) forKey:EMActivityWeiboStatusCodeKey];
    NSString *message = [[self errorMessages] objectForKey:@(response.statusCode)];
    if (message) {
        [userInfo setObject:message forKey:EMActivityWeiboStatusMessageKey];
    }
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        
        if (accessToken.length == 0) {
            accessToken = [sendMessageToWeiboResponse.requestUserInfo valueForKeyPath:@"access_token"];
        }
        
        if (userID.length == 0) {
            userID = [sendMessageToWeiboResponse.requestUserInfo valueForKeyPath:@"uid"];
        }
        
        if (accessToken.length > 0) {
            [userInfo setObject:accessToken forKey:EMActivityWeiboAccessTokenKey];
        }
        
        if (userID.length > 0) {
            [userInfo setObject:userID forKey:EMActivityWeiboUserIdKey];
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString* accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString* refreshToken = [(WBAuthorizeResponse *)response refreshToken];
        NSDate* expirationDate = [(WBAuthorizeResponse *)response expirationDate];

        NSString* userID = [(WBAuthorizeResponse *)response userID];
        
        // accessToken
        if (accessToken.length == 0) {
            accessToken = [response.requestUserInfo valueForKeyPath:@"access_token"];
        }
        if (accessToken.length > 0) {
            [userInfo setObject:accessToken forKey:EMActivityWeiboAccessTokenKey];
        }

        // refreshToken
        if (refreshToken.length == 0) {
            refreshToken = [response.requestUserInfo valueForKeyPath:@"refresh_token"];
        }
        if (refreshToken.length > 0) {
            [userInfo setObject:refreshToken forKey:EMActivityWeiboRefreshTokenKey];
        }

        // expirationDate
        if (expirationDate == nil) {
            expirationDate = [response.requestUserInfo valueForKeyPath:@"expiration_date"];
        }
        if (expirationDate) {
            [userInfo setObject:expirationDate forKey:EMActivityWeiboExpirationDateKey];
        }

        // UID
        if (userID.length == 0) {
            userID = [response.requestUserInfo valueForKeyPath:@"uid"];
        }
        if (userID.length > 0) {
            [userInfo setObject:userID forKey:EMActivityWeiboUserIdKey];
        }
    }
    
    if (self.isLogin) {
        [self handledLoginResponse:userInfo error:nil];
    } else {
        [self handledShareResponse:userInfo error:nil];
    }
}

- (void)handledLoginResponse:(NSDictionary *)userInfo error:(NSError *)error {
    NSString *userId = userInfo[EMActivityWeiboUserIdKey];
    NSString *accessToken = userInfo[EMActivityWeiboAccessTokenKey];
    
    if (userId == nil || accessToken == nil) {
        [super handledLoginResponse:userInfo error:error];
    } else {
        __block NSMutableDictionary *newUserInfo = [userInfo mutableCopy];
        [WBHttpRequest requestForUserProfile:userId withAccessToken:accessToken andOtherProperties:nil queue:[NSOperationQueue mainQueue] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            if (error) {
            }
            WeiboUser *weiboUser = result;
            NSString *nickname = [weiboUser screenName];
            newUserInfo[EMActivityWeiboUserNameKey] = nickname;
            newUserInfo[EMActivityWeiboProfileImageURLKey] = [weiboUser avatarLargeUrl];
            
            [super handledLoginResponse:newUserInfo error:error];
        }];
    }
}

- (NSDictionary *)errorMessages{
    return
    @{
      @(EMActivityWeiboStatusCodeSuccess):          @"分享成功",
      @(EMActivityWeiboStatusCodeUserCancel):       @"用户取消分享",
      @(EMActivityWeiboStatusCodeSentFail):         @"分享失败",
      @(EMActivityWeiboStatusCodeAuthDeny):         @"授权失败",
      @(EMActivityWeiboStatusCodeUserCancelInstall):@"用户取消安装微博客户端",
      @(EMActivityWeiboStatusCodePayFail):          @"支付失败",
      @(EMActivityWeiboStatusCodeShareInSDKFailed): @"分享失败",
      @(EMActivityWeiboStatusCodeUnsupport):        @"不支持的请求",
      @(EMActivityWeiboStatusCodeUnknown):          @"未知错误",
      @(EMActivityWeiboStatusCodeAppNotInstall):    @"您未安装微博客户端",
      };
}

- (BOOL)handleAppNotInstall {
    NSMutableDictionary *userInfo = @{}.mutableCopy;
    userInfo[EMActivityWeiboStatusCodeKey] = @(EMActivityWeiboStatusCodeAppNotInstall);
    userInfo[EMActivityWeiboStatusMessageKey] = [self errorMessages][@(EMActivityWeiboStatusCodeAppNotInstall)];
    if (![WeiboSDK isWeiboAppInstalled]) {
        if (self.isLogin) {
            [self handledLoginResponse:userInfo error:nil];
        } else {
            [self handledShareResponse:userInfo error:nil];
        }
        return YES;
    }
    return NO;
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
