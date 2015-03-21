//
//  ViewController.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/17/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "ViewController.h"
#import "EMActivityViewController.h"
#import "EMActivityWeibo.h"
#import "EMActivityWeChatTimeline.h"
#import "EMActivityWeChatSession.h"
#import "EMStockActivityWeibo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)share {
    EMStockActivityWeibo *weibo = [[EMStockActivityWeibo alloc]init];
    NSLog(@"%@",weibo.activityImage);
    
    NSArray *activies = @[weibo,[[EMActivityWeChatTimeline alloc]init],[[EMActivityWeChatSession alloc]init]];
    EMActivityViewController *activityViewController = [[EMActivityViewController alloc] initWithActivityItems:@[@"test",[NSURL URLWithString:@"http://baidu.com"]] applicationActivities:activies];

    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hello" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    };
    
    [self presentViewController:activityViewController animated:YES completion:^{
        NSLog(@"DONE");
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
