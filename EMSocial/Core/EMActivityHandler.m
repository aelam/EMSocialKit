//
//  EMActivityHandler.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/20/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMActivityHandler.h"
#import "EMActivity.h"

@interface EMActivityHandler ()

@property (nonatomic, strong) NSArray *applicationActivities;

@end


@implementation EMActivityHandler

+ (instancetype)defaultHandler {
    static EMActivityHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (void)registerApplicationActivities:(NSArray *)activities {
    self.applicationActivities = activities;
}


- (BOOL)handleOpenURL:(NSURL *)URL delegate:(id)delegate {
    
    return YES;
}


@end
