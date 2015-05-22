//
//  EMShareEntity.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/26/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMShareEntity.h"
#import "EMShareImage.h"

@implementation EMShareEntity

+ (instancetype)entityWithTitle:(NSString *)title
                        content:(NSString *)content
                     shareImage:(EMShareImage *)image
                       shareURL:(NSURL *)url {
    EMShareEntity *entity = [[EMShareEntity alloc] init];
    entity.title = title;
    entity.content = content;
    entity.shareURL = url;
    entity.image = image;

    return entity;
}

@end
