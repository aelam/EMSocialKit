//
//  EMLogin.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMLogin : NSObject

- (NSString *)loginType;
- (BOOL)canHandleOpenURL:(NSURL *)url;
- (void)handleOpenURL:(NSURL *)url;
- (void)performLogin;

- (void)handledActivityResponse:(id)response activityError:(NSError *)error;

@end
