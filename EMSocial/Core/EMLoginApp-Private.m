//
//  EMLoginApp+EMLoginApp_Private.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/26/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMLoginApp-Private.h"
#import "EMActivity.h"

@implementation EMLoginApp (Private)

- (void)_addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURLNotification:) name:EMActivityOpenURLNotification object:nil];
}

- (void)_removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleOpenURLNotification:(NSNotification *)notification {
    
}


@end
