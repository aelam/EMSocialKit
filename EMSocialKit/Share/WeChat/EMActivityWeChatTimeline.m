//
//  EMActivityWeChatTimeline.h.m
//

#import "EMActivityWeChatTimeline.h"
#import "UIImage+SocialBundle.h"

NSString *const UIActivityTypePostToWeChatTimeline = @"UIActivityTypePostToWeChatTimeline";


@implementation EMActivityWeChatTimeline

- (instancetype)init {
  self = [super init];
  if (self) {
    self.scene = EMWXSceneTimeline;
  }
  return self;
}

- (NSString *)activityType {
  return UIActivityTypePostToWeChatTimeline;
}

- (UIImage *)activityImage {
    return [UIImage socialImageNamed:@"EMSocialKit.bundle/moment"];
}

- (NSString *)activityTitle {
  return @"微信朋友圈"; // todo:
}

@end
