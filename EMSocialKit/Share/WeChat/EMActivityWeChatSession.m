//
//  EMActivityWeChatSession.m
//

#import "EMActivityWeChatSession.h"
#import "UIImage+SocialBundle.h"

NSString *const UIActivityTypePostToWeChatSession = @"UIActivityTypePostToWeChatSession";

@implementation EMActivityWeChatSession

- (NSString *)activityType {
  return UIActivityTypePostToWeChatSession;
}

- (UIImage *)activityImage {
    return [UIImage socialImageNamed:@"EMSocialKit.bundle/wechat"];
}

- (NSString *)activityTitle {
  return @"微信";
}

@end
