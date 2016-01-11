//
//  EMActivityViewController.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMActivity;

typedef NS_ENUM(NSUInteger, EMActivityStyle){
    EMActivityStyleWhite,
    EMActivityStyleBlack
};

typedef void (^EMActivityViewControllerCompletionWithItemsHandler)(EMActivity * activity, BOOL completed, NSArray * returnedItems, NSError * activityError);


@interface EMActivityViewController : UIViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities; 

@property(nonatomic, copy) EMActivityViewControllerCompletionWithItemsHandler completionWithItemsHandler;
@property(nonatomic, assign)EMActivityStyle activityStyle;


@end
