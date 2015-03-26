//
//  EMLoginApp.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EMSocialLoginCompletionWithItemsHandler)(BOOL completed, NSDictionary *returnedInfo, NSError *activityError);


@interface EMLoginApp : NSObject

@property (nonatomic, copy) EMSocialLoginCompletionWithItemsHandler completionWithItemsHandler;

- (NSString *)appId;
- (BOOL)isAppInstalled;

- (NSString *)loginType;
- (void)performLogin;
- (BOOL)needsHandleOpenURL;

- (void)handledResponse:(id)response error:(NSError *)error;

@end
