//
//  EMActivityViewController.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// Notice the differenc
//
//typedef void (^UIActivityViewControllerCompletionWithItemsHandler)(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError);

typedef void (^EMActivityViewControllerCompletionWithItemsHandler)(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError);


@interface EMActivityViewController : UIViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities; 

@property(nonatomic,copy) EMActivityViewControllerCompletionWithItemsHandler completionWithItemsHandler;

@property(nonatomic,copy) NSArray *excludedActivityTypes; // default is nil. activity types listed will not be displayed


@end
