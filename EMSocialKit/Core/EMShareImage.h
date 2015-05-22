//
//  EMShareImage.h
//  EMSocialApp
//
//  Created by Ryan Wang on 5/22/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMShareImage : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;

+ (instancetype)imageWithImage:(UIImage *)image imageURL:(NSURL *)imageURL;

@end
