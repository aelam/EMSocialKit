//
//  EMActivityWeChatTimeline.h.m
//

#import "EMActivityWeChatTimeline.h"



@implementation EMActivityWeChatTimeline

- (id)init {
  self = [super init];
  if (self) {
    self.scene = WXSceneTimeline;
  }
  return self;
}

- (NSString *)activityType {
  return UIActivityTypePostToWeChatTimeline;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"EMSocial.bundle/moment"];
}

- (NSString *)activityTitle {
  return @"微信朋友圈"; // todo:
}

@end
