//
//  EMActivityWeChatSession.m
//

#import "EMActivityWeChatSession.h"


@implementation EMActivityWeChatSession

- (NSString *)activityType {
  return UIActivityTypePostToWeChatSession;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"EMSocial.bundle/wechat"];
}

- (NSString *)activityTitle {
  return @"微信好友"; // todo
}

@end
