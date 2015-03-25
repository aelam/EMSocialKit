//
//  EMActivity.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const EMActivityOpenURLNotification;
UIKIT_EXTERN NSString *const EMActivityOpenURLKey;


@interface EMActivity : NSObject

+ (UIActivityCategory)activityCategory NS_AVAILABLE_IOS(7_0); // default is UIActivityCategoryAction.

- (NSString *)activityType;       // default returns nil. subclass may override to return custom activity type that is reported to completion handler
- (NSString *)activityTitle;      // default returns nil. subclass must override and must return non-nil value
- (UIImage *)activityImage;       // default returns nil. subclass must override and must return non-nil value

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems;   // override this to return availability of activity based on items. default returns NO
- (void)prepareWithActivityItems:(NSArray *)activityItems;      // override to extract items and set up your HI. default does nothing

- (UIViewController *)activityViewController;   // return non-nil to have vC presented modally. call activityDidFinish at end. default returns nil
- (void)performActivity;                        // if no view controller, this method is called. call activityDidFinish when done. default calls [self activityDidFinish:NO]

// state method
- (void)activityDidFinish:(BOOL)completed;   // activity must call this when activity is finished. can be called on any thread

// default return YES, if activity needn't handle some url return NO
// implement in subclass
- (void)handleOpenURLNotification:(NSNotification *)notification;
//- (BOOL)canHandleOpenURL:(NSURL *)url;
//- (void)handleOpenURL:(NSURL *)url;
- (void)handledActivityResponse:(id)response activityError:(NSError *)error; //breaks the retain cycle in it

@end
