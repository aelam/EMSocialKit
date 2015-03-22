//
//  EMSocialLoginController.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/22.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMSocialLoginController.h"
#import "EMLogin.h"
#import "EMSocialOpenURLHandler.h"

@interface EMLogin (Private)

@property (nonatomic, weak)EMSocialLoginController *loginController;

@end

@interface EMSocialOpenURLHandler (Private)

@property (nonatomic, strong)EMLogin *watchingLogin;

@end


@interface EMSocialLoginController ()

@property (nonatomic, strong) EMLogin *login;

@end

@implementation EMSocialLoginController

- (instancetype)initWithLogin:(EMLogin *)login {
    if (self = [super init]) {
        self.login = login;
        [EMSocialOpenURLHandler sharedHandler].watchingLogin = login;
        self.login.loginController = self;
    }
    return self;
}

- (void)performLogin {
    [self.login performLogin];
}

- (void)_handleCompleted:(BOOL)completed returnInfo:(NSDictionary *)returnedInfo activityError:(NSError *) activityError {
    if (self.completionWithItemsHandler) {
        self.completionWithItemsHandler(self.login.loginType,YES,returnedInfo,activityError);
    }
}

@end
