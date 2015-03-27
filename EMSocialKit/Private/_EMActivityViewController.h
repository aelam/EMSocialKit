//
//  EMActivityViewController+Private.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/21.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMActivityViewController.h"

@interface EMActivityViewController (Private)

- (void)_handleAcitivityType:(NSString *)activityType completed:(BOOL)completed returnInfo:(NSDictionary *)returnInfo activityError:(NSError *) activityError;

@end
