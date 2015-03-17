//
//  EMActivity.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMActivity.h"

NSString *const UIActivityTypePostToWeChatSession = @"UIActivityTypePostToWeChatSession";
NSString *const UIActivityTypePostToWeChatTimeline = @"UIActivityTypePostToWeChatTimeline";
NSString *const UIActivityTypePostToSinaWeibo = @"UIActivityTypePostToSinaWeibo";

@implementation EMActivity


+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (NSString *)activityType {
    return nil;
};

- (NSString *)activityTitle {
    return nil;
}

- (UIImage *)activityImage {
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {}

- (UIViewController *)activityViewController {
    return nil;
}

- (void)performActivity {
    
}

- (void)activityDidFinish:(BOOL)completed {
    
}

@end
