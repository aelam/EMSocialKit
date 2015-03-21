//
//  EMActivityWeibo.m
//  ActivityTest
//
//  Created by nickcheng on 15/1/5.
//  Copyright (c) 2015年 nickcheng.com. All rights reserved.
//

#import "EMActivityWeibo.h"
#import "WeiboSDK.h"
#import "UIImage+ResizeMagick.h"
#import "EMSocialSDK+Private.h"

NSString *const EMActivityWeiboAccessTokenKey   = @"EMActivityWeiboAccessTokenKey";
NSString *const EMActivityWeiboUserIdKey        = @"EMActivityWeiboUserIdKey";
NSString *const EMActivityWeiboStatusCodeKey    = @"EMActivityWeiboStatusCodeKey";
NSString *const EMActivityWeiboStatusMessageKey = @"EMActivityWeiboStatusMessageKey";
//NSString *const EMActivityWeiboPayStatusCodeKey = @"EMActivityWeiboPayStatusCodeKey";
//NSString *const EMActivityWeiboPayStatusMessageKey = @"EMActivityWeiboPayMessageCodeKey";

@interface EMActivityWeibo () <WeiboSDKDelegate>

@end

@implementation EMActivityWeibo

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
    return [UIImage imageNamed:@"EMSocial.bundle/weibo"];
  else
    return [UIImage imageNamed:@"EMSocial.bundle/weibo"];
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
      NSLog(@"EMActivityWeibo: Unknown item type: %@", item);
  }
}

- (void)performActivity {
    
    WBMessageObject *message = [WBMessageObject message];
    if (self.shareString)
        message.text = self.shareString;

    if (self.shareImage) {
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(self.shareImage, 1);
        message.imageObject = imageObject;
    }
    if (self.shareURL) {
        WBWebpageObject *webObject = [WBWebpageObject object];
        webObject.webpageUrl = [self.shareURL absoluteString];
        message.mediaObject = webObject;
    }
    
    //
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.scope =  @"all";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    
    [WeiboSDK sendRequest:request];
    
    [self activityDidFinish:YES];
}

#pragma mark -
#pragma mark Private Methods
- (UIImage *)optimizedImageFromOriginalImage:(UIImage *)oriImage {
  // Resize if needed
  UIImage *result = (oriImage.size.width > 1600 || oriImage.size.height > 1600) ? [oriImage resizedImageByMagick:@"1600x1600"] : oriImage;

  return result;
}

- (BOOL)canHandleActivityURL:(NSURL *)url {
    BOOL can = [WeiboSDK handleOpenURL:url delegate:nil];
    if (can && ![[url absoluteString] containsString:@"pay"]) {
        return YES;
    }
    return NO;
}

- (void)handleActivityURL:(NSURL *)url {
    [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - WBSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        
        [userInfo setObject:accessToken forKey:EMActivityWeiboAccessTokenKey];
        [userInfo setObject:userID forKey:EMActivityWeiboUserIdKey];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        NSString* accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString* userID = [(WBAuthorizeResponse *)response userID];
        [userInfo setObject:accessToken forKey:EMActivityWeiboAccessTokenKey];
        [userInfo setObject:userID forKey:EMActivityWeiboUserIdKey];
    }
//    else if ([response isKindOfClass:WBPaymentResponse.class])
//    {
//        NSString *title = NSLocalizedString(@"支付结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//    }

    [self handledActivityResponse:userInfo activityError:nil];
}




@end
