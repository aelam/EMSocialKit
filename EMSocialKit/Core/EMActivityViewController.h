//
//  EMActivityViewController.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EMActivityStyle){
    EMActivityStyleWhite,
    EMActivityStyleBlack
};

typedef void (^EMActivityShareCompletionHandler)(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError);

@interface EMActivityViewController : UIViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities; 

@property(nonatomic, copy) EMActivityShareCompletionHandler completionWithItemsHandler;
@property(nonatomic, assign)EMActivityStyle activityStyle;


@end
