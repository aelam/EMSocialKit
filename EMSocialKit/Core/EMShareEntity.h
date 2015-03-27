//
//  EMShareEntity.h
//  EMSocialApp
//
//  Created by Ryan Wang on 3/26/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMShareEntity : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *shareURL;

+ (instancetype)entityWithTitle:(NSString *)title image:(UIImage *)image shareURL:(NSURL *)url;

@end
