//
//  EMActivityHandler.h
//  EMSocialApp
//
//  Created by Ryan Wang on 3/20/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMActivityHandler : NSObject

+ (instancetype)defaultHandler;

- (BOOL)handleOpenURL:(NSURL *)URL delegate:(id)delegate;



@end
