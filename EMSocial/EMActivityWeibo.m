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

NSString *const EMActivityWeiboAccessTokenKey   = @"EMActivityWeiboAccessTokenKey";
NSString *const EMActivityWeiboUserIdKey        = @"EMActivityWeiboUserIdKey";
NSString *const EMActivityWeiboStatusCodeKey    = @"EMActivityWeiboStatusCodeKey";
NSString *const EMActivityWeiboStatusMessageKey = @"EMActivityWeiboStatusMessageKey";

@interface EMActivityWeibo () <WeiboSDKDelegate>

@property (nonatomic, strong) UIImage *shareImage; // only support one image
@property (nonatomic, strong) NSString *shareString;
@property (nonatomic, strong) NSURL *shareURL; // will be converted to String

@property (nonatomic, strong) WBBaseResponse *response;


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
            self.shareString = [(self.shareString ? : @"") stringByAppendingFormat:@"%@%@", (self.shareString ? @" ": @""), [item absoluteString]];
        } else
            NSLog(@"NCActivityWeibo: Unknown item type: %@", item);
    }
}

- (void)performActivity {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURLNotification:) name:EMActivityOpenURLNotification object:nil];
    
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
        webObject.objectID = [NSString stringWithFormat:@"%ld", time(NULL)];
        webObject.title = self.shareString;
        webObject.thumbnailData = UIImageJPEGRepresentation(self.shareImage, 1);
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


- (void)handleOpenURLNotification:(NSNotification *)notification {
    NSURL *url = [[notification userInfo] objectForKey:EMActivityOpenURLKey];
    [WeiboSDK handleOpenURL:url delegate:self];
}

//- (BOOL)canHandleOpenURL:(NSURL *)url {
//    // If we use `+handleOpenURL:delegate:` to check URL
//    // It will casue problem when we use URL in `-handleOpenURL:` again.
//    //
//    BOOL can = [[url scheme] hasPrefix:@"wb"]; //[WeiboSDK handleOpenURL:url delegate:nil];
//    if (can && ![[url absoluteString] containsString:@"pay"]) {
//        return YES;
//    }
//    return NO;
//    
////    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//
//- (void)handleOpenURL:(NSURL *)url {
//    [WeiboSDK handleOpenURL:url delegate:self];
//}
//

#pragma mark - WBSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
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
        
        [userInfo setObject:accessToken forKey:EMActivityWeiboAccessTokenKey];
        [userInfo setObject:userID forKey:EMActivityWeiboUserIdKey];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString* accessToken = [(WBAuthorizeResponse *)response accessToken];
        NSString* userID = [(WBAuthorizeResponse *)response userID];
        
        if (accessToken.length == 0) {
            accessToken = [response.requestUserInfo valueForKeyPath:@"access_token"];
        }
        
        if (userID.length == 0) {
            userID = [response.requestUserInfo valueForKeyPath:@"uid"];
        }

        [userInfo setObject:accessToken forKey:EMActivityWeiboAccessTokenKey];
        [userInfo setObject:userID forKey:EMActivityWeiboUserIdKey];
    }

    [self handledActivityResponse:userInfo activityError:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
