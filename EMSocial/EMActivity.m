//
//  EMActivity.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMActivity.h"
#import "_EMActivityViewController.h"

@class EMActivityViewController;

NSString *const UIActivityTypePostToWeChatSession = @"UIActivityTypePostToWeChatSession";
NSString *const UIActivityTypePostToWeChatTimeline = @"UIActivityTypePostToWeChatTimeline";
NSString *const UIActivityTypePostToSinaWeibo = @"UIActivityTypePostToSinaWeibo";

@interface EMActivity ()

@property (nonatomic, strong, readwrite) EMActivityViewController *activityViewController;

@end


@implementation EMActivity

@synthesize activityViewController;

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

//- (UIViewController *)activityViewController {
//    return nil;
//}

- (void)performActivity {
    
}

- (void)activityDidFinish:(BOOL)completed {
    
}

- (BOOL)canHandleActivityURL:(NSURL *)url {
    return YES;
}

- (void)handleActivityURL:(NSURL *)url {
}

- (void)handledActivityResponse:(id)response activityError:(NSError *)error {
    [(EMActivityViewController *)self.activityViewController _handleAcitivityType:self.activityTitle completed:YES returnInfo:response activityError:error];
}


@end
