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

@implementation EMActivityWeibo

+ (UIActivityCategory)activityCategory {
  return UIActivityCategoryShare;
}

- (NSString *)activityType {
  return UIActivityTypePostToSinaWeibo;
}

- (NSString *)activityTitle {
  return @"Sina Weibo"; // todo: i18n
}

- (UIImage *)activityImage {
  if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
    return [UIImage imageNamed:@"weibo"];
  else
    return [UIImage imageNamed:@"weiboline"];
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
      NSLog(@"EMActivityWeibo: Unknown item type: %@", item);
  }
}

- (void)performActivity {
  // Genterate WBMessageObject
    
    if([WeiboSDK isWeiboAppInstalled]) {
        WBMessageObject *message = [WBMessageObject message];
        if (self.shareString)
            message.text = self.shareString;
        if (self.shareImage) {
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = UIImageJPEGRepresentation(self.shareImage, 1);
            message.imageObject = imageObject;
        }
        
        //
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.scope = (self.authScope && self.authScope.length > 0) ? self.authScope : @"all";
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        
        [WeiboSDK sendRequest:request];
        
    } else {
        
    }
    
    [self activityDidFinish:YES];
}

#pragma mark -
#pragma mark Private Methods

- (UIImage *)optimizedImageFromOriginalImage:(UIImage *)oriImage {
  // Resize if needed
  UIImage *result = (oriImage.size.width > 1600 || oriImage.size.height > 1600) ? [oriImage resizedImageByMagick:@"1600x1600"] : oriImage;

  return result;
}

- (UIViewController *)activityViewController {
    return [[UIViewController alloc] init];
}

@end
