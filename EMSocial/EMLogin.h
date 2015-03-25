//
//  EMLogin.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EMSocialLoginCompletionWithItemsHandler)(BOOL completed, NSDictionary *returnedInfo, NSError *activityError);


@interface EMLogin : NSObject

@property (nonatomic, copy) EMSocialLoginCompletionWithItemsHandler completionWithItemsHandler;

- (NSString *)loginType;
//- (BOOL)canHandleOpenURL:(NSURL *)url;
//- (void)handleOpenURL:(NSURL *)url;
- (void)performLogin;

//- (void)handledActivityResponse:(id)response activityError:(NSError *)error;

@end
