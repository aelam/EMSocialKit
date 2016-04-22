//
//  EMActivityWeChat.m
//

#import "EMActivityWeChat.h"
#import "WXApi.h"
#import "EMSocialSDK.h"

NSString *const EMActivityWeChatStatusCodeKey       = @"EMActivityWeChatStatusCodeKey";
NSString *const EMActivityWeChatStatusMessageKey    = @"EMActivityWeChatStatusMessageKey";
NSString *const EMActivityWeChatSummaryKey          = @"EMActivityWeChatSummaryKey";
NSString *const EMActivityWeChatAuthCodeKey         = @"EMActivityWeChatAuthCodeKey";

NSString *const EMActivityWeChatThumbImageKey       = @"thumbimage";
NSString *const EMActivityWeChatDescriptionKey      = @"descstring";

@interface EMActivityWeChat ()<WXApiDelegate>

@property (nonatomic, strong) NSString* state;
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation EMActivityWeChat

+ (void)registerApp {
    [WXApi registerApp:EMCONFIG(tencentWeixinAppId)];
}

- (NSString *)scope {
    return @"snsapi_userinfo";
}

- (BOOL)isAppInstalled {
    return [WXApi isWXAppInstalled];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        for (id activityItem in activityItems) {
            if ([activityItem isKindOfClass:[UIImage class]]) {
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
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = self.scene;
    req.message = WXMediaMessage.message;
    req.message.title       = self.shareStringTitle ? : @"";
    req.message.description = self.shareStringDesc ? : @"";
    [self setThumbImage:req];
    if (self.shareURL) {
        WXWebpageObject *webObject = WXWebpageObject.object;
        webObject.webpageUrl    = [self.shareURL absoluteString];
        req.message.mediaObject = webObject;
    } else if (self.shareImage) {
        WXImageObject *imageObject = WXImageObject.object;
        imageObject.imageData   = UIImageJPEGRepresentation(self.shareImage, 1);
        req.message.mediaObject = imageObject;
    }
    [WXApi sendReq:req];
    [self activityDidFinish:YES];
}

#pragma mark -
#pragma mark Private Methods

- (void)setThumbImage:(SendMessageToWXReq *)req {
    if (self.shareThumbImage) {
        [req.message setThumbImage:[self optimizedThumbImageFromOriginal:self.shareThumbImage]];
    } else if (self.shareImage) {
        [req.message setThumbImage:[self optimizedThumbImageFromOriginal:self.shareImage]];
    }
}

- (UIImage *)optimizedThumbImageFromOriginal:(UIImage *)oriImage {
    CGFloat width  = 100.0f;
    CGFloat height = oriImage.size.height * 100.0f / oriImage.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [oriImage drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (BOOL)canHandleOpenURL:(NSURL *)url {
    NSString *urlString = [url absoluteString];

    BOOL can = [urlString rangeOfString:@"wx"].location != NSNotFound;
    if (can && [[url absoluteString] rangeOfString:@"safepay"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

-(void) onReq:(BaseReq*)req {
    
}

-(void) onResp:(BaseResp*)resp
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(resp.errCode) forKey:EMActivityWeChatStatusCodeKey];
    NSString *message = resp.errStr;
    if (message == nil) {
        message = [[self errorMessages] objectForKey:@(resp.errCode)];
    }
    if (message) {
        [userInfo setObject:message forKey:EMActivityWeChatStatusMessageKey];
    }

    if (self.isLogin) {
        NSError *error = nil;
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if ([self.state isEqualToString:authResp.state]) {
            if (authResp.code) {
                userInfo[EMActivityWeChatAuthCodeKey] = authResp.code;
            } else {
                error = [NSError errorWithDomain:EMSocialSDKErrorDomain code:100 userInfo:@{NSLocalizedDescriptionKey:@"微信授权失败"}];
            }
        } else {
            // error
        }

        [self handledLoginResponse:userInfo error:nil];
    } else {
        [self handledShareResponse:userInfo error:nil];
    }
}

- (BOOL)canPerformLogin {
    return YES;
}

- (void)performLogin {
    self.isLogin = YES;
    
    if ([self handleAppNotInstall]) {
        return;
    }
    
    SendAuthReq *req = [SendAuthReq new];
    req.scope = [self scope];
    req.state = [NSString stringWithFormat:@"%ld", time(NULL)];
    self.state = req.state;
    [WXApi sendAuthReq:req viewController:nil delegate:self];
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

- (BOOL)handleAppNotInstall {
    NSMutableDictionary *userInfo = @{}.mutableCopy;
    userInfo[EMActivityWeChatStatusCodeKey] = @(EMActivityWeChatStatusCodeAppNotInstall);
    userInfo[EMActivityWeChatStatusMessageKey] = [self errorMessages][@(EMActivityWeChatStatusCodeAppNotInstall)];
    if (![WXApi isWXAppInstalled]) {
        if (self.isLogin) {
            [self handledLoginResponse:userInfo error:nil];
        } else {
            [self handledShareResponse:userInfo error:nil];
        }
        return YES;
    }
    return NO;
}


@end
