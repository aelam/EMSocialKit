//
//  EMActivityWeChatTimeline.h.m
//  ActivityTest
//
//  Created by nickcheng on 15/1/8.
//  Copyright (c) 2015年 nickcheng.com. All rights reserved.
//

#import "EMActivityWeChatTimeline.h"



@implementation EMActivityWeChatTimeline

- (id)init {
  self = [super init];
  if (self) {
    self.scene = EMActivityWeChatSceneSession;
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
