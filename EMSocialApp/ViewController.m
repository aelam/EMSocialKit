//
//  ViewController.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/17/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "ViewController.h"
#import "EMStockActivityWeibo.h"

#import "EMSocialSDK.h"
#import "EMSocialKey.h"
#import "EMActivityWeChat.h"
#import "EMActivityWeibo.h"
#import "EMActivityWeChatSession.h"
#import "EMActivityWeChatTimeline.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

// 全部分享
- (IBAction)share {
    NSArray *contents = @[@"test",[NSURL URLWithString:@"http://baidu.com"]];
    [[EMSocialSDK sharedSDK] shareContent:contents rootViewController:self completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        if (activityError) {
            NSLog (@"error: %@", [activityError localizedDescription]);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
    }];
}


- (IBAction)weiboShare {
    EMActivityWeibo *weibo = [[EMActivityWeibo alloc] init];
    NSArray *contents = @[@"test",[NSURL URLWithString:@"http://baidu.com"]];

    [[EMSocialSDK sharedSDK] shareContent:contents activity:weibo completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"分享 result %@", returnedInfo);
    }];
    
}

- (IBAction)wechatShare {
    EMActivityWeChatSession *weibo = [[EMActivityWeChatSession alloc] init];
    NSArray *contents = @[@"微信分享",[NSURL URLWithString:@"http://baidu.com"]];
    
    [[EMSocialSDK sharedSDK] shareContent:contents activity:weibo completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        if (activityError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Result" message:[activityError localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"分享 result %@", returnedInfo);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"分享 result %@", returnedInfo);
        }
    }];
    
}




- (IBAction)weChatLogin2:(id)sender {
    EMActivityWeChat *wechat = [[EMActivityWeChat alloc] init];
    
    [[EMSocialSDK sharedSDK] loginWithActivity:wechat completionHandler:^(BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"login result %@", returnedInfo);
    }];

}


- (IBAction)weiboLogin2:(id)sender {
    EMActivityWeibo *weibo = [[EMActivityWeibo alloc] init];
    
    [[EMSocialSDK sharedSDK] loginWithActivity:weibo completionHandler:^(BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"login result %@", returnedInfo);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
