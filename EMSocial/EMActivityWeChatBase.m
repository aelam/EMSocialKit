//
//  EMActivityWeChatBase.m
//  ActivityTest
//
//  Created by nickcheng on 15/1/8.
//  Copyright (c) 2015年 nickcheng.com. All rights reserved.
//

#import "EMActivityWeChatBase.h"
#import "WXApi.h"

NSString *const EMActivityWeChatStatusCodeKey = @"EMActivityWeChatStatusCodeKey";
NSString *const EMActivityWeChatSummaryKey    = @"EMActivityWeChatSummaryKey";

@interface EMActivityWeChatBase ()<WXApiDelegate>

@end

@implementation EMActivityWeChatBase

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
    } else if ([activityItem isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = activityItem;
      if ([dict.allKeys containsObject:@"thumbimage"] && [dict[@"thumbimage"] isKindOfClass:[UIImage class]]) {
        self.shareThumbImage = dict[@"thumbimage"];
      }
      if ([dict.allKeys containsObject:@"descstring"] && [dict[@"descstring"] isKindOfClass:[NSString class]]) {
        self.shareStringDesc = dict[@"descstring"];
      }
    }
  }
}

- (void)performActivity {
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

- (BOOL)canHandleActivityURL:(NSURL *)url {
    NSString *urlString = [url absoluteString];
                           
    BOOL can = [urlString containsString:@"wx"];
    if (can && ![[url absoluteString] containsString:@"safepay"]) {
        return YES;
    }
    return NO;
}

- (void)handleActivityURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
}

-(void) onReq:(BaseReq*)req {
    
}

-(void) onResp:(BaseResp*)resp
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(resp.errCode) forKey:EMActivityWeChatStatusCodeKey];
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        [userInfo setObject:@(resp.errCode) forKey:EMActivityWeChatStatusCodeKey];
//    }
//    else if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        SendAuthResp *temp = (SendAuthResp*)resp;
        
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
//    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
//    {
//        AddCardToWXCardPackageResp* temp = (AddCardToWXCardPackageResp*)resp;
//        NSMutableString* cardStr = [[NSMutableString alloc] init];
//        for (WXCardItem* cardItem in temp.cardAry) {
//            [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%lu\n",cardItem.cardId,cardItem.extMsg,cardItem.cardState]];
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp" message:cardStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
    
    [self handledActivityResponse:userInfo activityError:nil];
}

@end
