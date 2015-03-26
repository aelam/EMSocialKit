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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)share {
    [self share2];
}

- (void)share1 {
    EMStockActivityWeibo *weibo = [[EMStockActivityWeibo alloc]init];
    NSLog(@"%@",weibo.activityImage);
    
    NSArray *activies = @[weibo,[[EMActivityWeChatTimeline alloc]init],[[EMActivityWeChatSession alloc]init]];
    EMActivityViewController *activityViewController = [[EMActivityViewController alloc] initWithActivityItems:@[@"test",[NSURL URLWithString:@"http://baidu.com"]] applicationActivities:activies];
    
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    };
    
    [self presentViewController:activityViewController animated:YES completion:^{
        NSLog(@"DONE");
    }];
}

- (void)share2 {
    NSArray *contents = @[@"test",[NSURL URLWithString:@"http://baidu.com"]];
    [[EMSocialSDK sharedSDK] shareWithContent:contents rootViewController:self completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        if (activityError) {
            NSLog (@"error: %@", [activityError localizedDescription]);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
    }];
}

- (IBAction)weiboLogin {
    EMLoginWeibo *weibo = [[EMLoginWeibo alloc] init];
    
    [[EMSocialSDK sharedSDK] loginWithSession:weibo completionHandler:^(BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"login result %@", returnedInfo);
    }];
}
    


- (IBAction)qqLogin {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
