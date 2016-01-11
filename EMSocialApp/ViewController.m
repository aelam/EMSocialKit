//
//  ViewController.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/17/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "ViewController.h"

#import "EMSocialSDK.h"
#import "EMActivityWeChat.h"
#import "EMActivityWeibo.h"
#import "EMActivityWeChatSession.h"
#import "EMActivityWeChatTimeline.h"
#import "DemoUIActivityViewController.h"
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
    [[EMSocialSDK sharedSDK] shareActivityItems:contents rootViewController:self completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        if (activityError) {
            NSLog (@"error: %@", [activityError localizedDescription]);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
    }];
}


- (IBAction)weiboShare {
    EMActivity *weibo = [[EMActivityWeibo alloc] init];
    NSArray *contents = @[@"test",[NSURL URLWithString:@"http://baidu.com"]];

    [[EMSocialSDK sharedSDK] shareActivityItems:contents activity:weibo completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"微博分享" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"分享 result %@", returnedInfo);
    }];
    
}

- (IBAction)wechatShare {
    EMActivityWeChatSession *weibo = [[EMActivityWeChatSession alloc] init];
    NSArray *contents = @[@"微信分享",[NSURL URLWithString:@"http://baidu.com"]];
    
    [[EMSocialSDK sharedSDK] shareActivityItems:contents activity:weibo completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        if (activityError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"微信分享" message:[activityError localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"分享 result %@", returnedInfo);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"微信分享" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (IBAction)systemShare:(id)sender {
    DemoUIActivityViewController *v = [[DemoUIActivityViewController alloc] initWithActivityItems:@[@"title"] applicationActivities:nil];
    
    [self presentViewController:v animated:YES completion:^{
        v.view.layer.borderColor = [UIColor yellowColor].CGColor;
        v.view.layer.borderWidth = 1;
        NSLog(@"%@",v.view);
    }];
}


- (IBAction)qqLogin2:(id)sender {
    EMActivityQQ *qq = [[EMActivityQQ alloc] init];
    
    [[EMSocialSDK sharedSDK] loginWithActivity:qq completionHandler:^(BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"login result %@", returnedInfo);
    }];
    
}

- (IBAction)qqShare:(id)sender {
    EMActivityQQ *qq = [[EMActivityQQ alloc] init];
    
//    [[EMSocialSDK sharedSDK] loginWithActivity:qq completionHandler:^(BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        NSLog(@"login result %@", returnedInfo);
//    }];
    
    NSArray *contents = @[@"微信分享",[NSURL URLWithString:@"http://baidu.com"]];

    [[EMSocialSDK sharedSDK] shareActivityItems:contents activity:qq completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QQ Share Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"login result %@", returnedInfo);

    }];
    
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
