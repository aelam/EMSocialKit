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

NSString *const EMActivityWeChatThumbImageKey       = @"thumbimage";
NSString *const EMActivityWeChatDescriptionKey      = @"descstring";

static NSString *const EMActivityWeChatURL          = @"weixin://";


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

- (BOOL)isAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:EMActivityWeChatURL]];
}

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

- (BOOL)canHandleOpenURL:(NSURL *)url {
    NSString *urlString = [url absoluteString];

    BOOL can = [urlString rangeOfString:@"wx"].location != NSNotFound;
    if (can && [[url absoluteString] rangeOfString:@"safepay"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)handleOpenURL:(NSURL *)URL {
    NSString *urlString = [URL absoluteString];
    
    BOOL can = [urlString rangeOfString:@"wx"].location != NSNotFound;
    if (can && [urlString rangeOfString:@"safepay"].location == NSNotFound) {
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
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    // WeChat OAuth
    NSString *query = [URL query];
    NSDictionary *parameters = [query SK_URLParameters];
    NSString *state = parameters[@"state"];
    if ([state isEqualToString:@"Weixinauth"]) {
        userInfo[EMActivityWeChatAuthCodeKey] = parameters[@"code"];
        userInfo[EMActivityWeChatStatusCodeKey] = @(EMActivityWeChatStatusCodeSuccess);
        NSString *errorMessage = [[self errorMessages] objectForKey:@(EMActivityWeChatStatusCodeSuccess)];
        if (errorMessage) {
            userInfo[EMActivityWeChatStatusMessageKey] = errorMessage;
        }
        
        {
            userInfo[EMActivityGeneralStatusCodeKey] = @(EMActivityGeneralStatusCodeSuccess);
            NSString *errorMessage = [[self class] errorMessageWithCode:EMActivityGeneralStatusCodeSuccess];
            userInfo[EMActivityGeneralMessageKey] = errorMessage;
        }
        
        [self handledLoginResponse:userInfo error:nil];
        
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

- (BOOL)canPerformLogin {
    return YES;
}

- (void)performLogin {
    self.isLogin = YES;
    
    if ([self handleAppNotInstall]) {
        return;
    }
    
    NSString *wechatURLString = [NSString stringWithFormat:@"weixin://app/%@/auth/?scope=%@&state=Weixinauth", EMCONFIG(tencentWeixinAppId),[self scope]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:wechatURLString]];
    
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


@end
