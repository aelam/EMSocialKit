//
//  EMActivityWeChatSession.m
//

#import "EMActivityWeChatSession.h"

NSString *const UIActivityTypePostToWeChatSession = @"UIActivityTypePostToWeChatSession";

@implementation EMActivityWeChatSession

- (NSString *)activityType {
  return UIActivityTypePostToWeChatSession;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"EMSocialKit.bundle/wechat"];
}

- (NSString *)activityTitle {
  return @"微信";
}

@end
