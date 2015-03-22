//
//  EMLogin.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMLogin.h"
#import "EMSocialLoginController.h"

@interface EMSocialLoginController ()

- (void)_handleCompleted:(BOOL)completed returnInfo:(NSDictionary *)returnedInfo activityError:(NSError *) activityError;


@end

@interface EMLogin ()

@property (nonatomic, strong) EMSocialLoginController *loginController;

@end

@implementation EMLogin

- (NSString *)loginType {
    return nil;
}

- (BOOL)canHandleOpenURL:(NSURL *)url {
    return NO;
}

- (void)handleOpenURL:(NSURL *)url {

}

- (void)performLogin {
    
}

- (void)handledActivityResponse:(id)response activityError:(NSError *)error {
    [(EMSocialLoginController *)self.loginController _handleCompleted:YES returnInfo:response activityError:error];
    
    // break retain cycle
    self.loginController = nil;
    
}


@end
