//
//  ymSocialViewController.h
//  Social
//
//  Created by Sam Chen on 13-4-16.
//  Copyright (c) 2013年 emoney. All rights reserved.
//

#import <UIKit/UIKit.h>

#if HAS_EM_CORE
    #import "EMViewController.h"
    #import "EMRecommendAddressBook.h"
    #import "EMAppDelegate.h"
    #import "EMStockWindow.h"
#endif

#import "EMSocialKey.h"

FOUNDATION_EXTERN NSString * const SOCIAL_PARAM_QQ;
FOUNDATION_EXTERN NSString * const SOCIAL_PARAM_QQ_SPACE;
FOUNDATION_EXTERN NSString * const SOCIAL_PARAM_WeChat;
FOUNDATION_EXTERN NSString * const SOCIAL_PARAM_Friends;
FOUNDATION_EXTERN NSString * const SOCIAL_PARAM_TENCENT_WEIBO;
FOUNDATION_EXTERN NSString * const SOCIAL_PARAM_SINA_WEIBO;


@interface EMSocialViewController :
#if HAS_EM_CORE
EMViewController
#else 
UIViewController
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
<UIViewControllerTransitioningDelegate>
#endif
{
}

@property (nonatomic, weak) UIViewController *rootViewController;

// 分享实体,用于存放分享内容.
@property (nonatomic, assign) int showButtonCount;
@property (nonatomic, strong)  UIView *viewButtonBg;

- (void)share:(NSString *)param;

- (void)downloadImage;
//block
typedef void (^ImmediateShareBlock)(void);
@property (nonatomic, copy) ImmediateShareBlock immediateShareBlock;

@end
