//
//  EMSocialLoginController.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMLogin.h"

typedef void (^EMSocialLoginControllerCompletionWithItemsHandler)(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError);

@interface EMSocialLoginController : NSObject

- (instancetype)initWithLogin:(EMLogin *)login;

@property (nonatomic, copy) EMSocialLoginControllerCompletionWithItemsHandler completionWithItemsHandler;

- (void)performLogin;

@end
