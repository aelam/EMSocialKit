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
#import "WeiboSDK.h"
#import "EMSocialLoginController.h"
#import "EMLoginWeibo.h"

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

//    EMActivityViewController *activityViewController = [[EMActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:@"http://baidu.com"]] applicationActivities:activies];

    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    };
    
    [self presentViewController:activityViewController animated:YES completion:^{
        NSLog(@"DONE");
    }];
    
}

- (IBAction)weiboLogin {
//    
//#define kAppKey         @"2045436852"
//#define kRedirectURI    @"http://www.sina.com"
//
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = kRedirectURI;
//    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//
//    [WeiboSDK sendRequest:request];
    
    EMLoginWeibo *weibo = [[EMLoginWeibo alloc] init];
    EMSocialLoginController *controller = [[EMSocialLoginController alloc] initWithLogin:weibo];
    controller.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    };
    [controller performLogin];

}

- (IBAction)wechatLogin {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
