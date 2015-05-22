//
//  EMShareImage.m
//  EMSocialApp
//
//  Created by Ryan Wang on 5/22/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMShareImage.h"

@implementation EMShareImage

+ (instancetype)imageWithImage:(UIImage *)image imageURL:(NSURL *)imageURL {
    EMShareImage *shareImage = [[EMShareImage alloc] init];
    shareImage.image = image;
    shareImage.imageURL = imageURL;

    return shareImage;
}

@end
