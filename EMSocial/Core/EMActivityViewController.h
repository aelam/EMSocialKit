//
//  EMActivityViewController.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIActivityViewControllerCompletionHandler)(NSString *activityType, BOOL completed);
typedef void (^UIActivityViewControllerCompletionWithItemsHandler)(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError);

@interface EMActivityViewController : UIViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities; 

@property(nonatomic,copy) UIActivityViewControllerCompletionHandler completionHandler NS_DEPRECATED_IOS(6_0, 8_0, "Use completionWithItemsHandler instead.");  // set to nil after call
@property(nonatomic,copy) UIActivityViewControllerCompletionWithItemsHandler completionWithItemsHandler NS_AVAILABLE_IOS(8_0); // set to nil after call
@property(nonatomic,copy) NSArray *excludedActivityTypes; // default is nil. activity types listed will not be displayed


@end
