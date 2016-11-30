//
//  ShareDemoViewController.m
//  EMSocialApp
//
//  Created by ryan on 30/11/2016.
//  Copyright © 2016 Ryan Wang. All rights reserved.
//

#import "ShareDemoViewController.h"
#import <EMSocialKit/EMSocialKit.h>

@interface ShareDemoViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *platformSegmentedControl;
@property (nonatomic, strong) NSArray <Class> *classes;
@property (nonatomic, strong) Class currentActivityClass;

@end

@implementation ShareDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classes = @[
                     [EMActivityWeChatSession class],
                     [EMActivityWeChatTimeline class],
                     [EMActivityWeibo class],
                     [EMActivityQQ class]
                     ];
    self.currentActivityClass = self.classes[self.platformSegmentedControl.selectedSegmentIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)valueChanged:(UISegmentedControl *)sender {
    self.currentActivityClass = self.classes[self.platformSegmentedControl.selectedSegmentIndex];
}

- (IBAction)sharePlainText:(id)sender {
    [self _shareWithActivity:[self.currentActivityClass new] withItems:@[@"Hello, I'm a plain text"]];
}

- (IBAction)shareImage:(id)sender {
    [self _shareWithActivity:[self.currentActivityClass new] withItems:@[[UIImage imageNamed:@"WechatIMG44"]]];
}

- (IBAction)shareLink:(id)sender {
    [self _shareWithActivity:[self.currentActivityClass new] withItems:@[@"Hello, I'm a plain text",[UIImage imageNamed:@"WechatIMG44"],[NSURL URLWithString:@"http://www.baidu.com"]]];
}

- (IBAction)login:(id)sender {
    [[EMSocialSDK sharedSDK] loginWithActivity:[self.currentActivityClass new] completionHandler:^(BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"login result %@", returnedInfo);
    }];
}


- (void)_shareWithActivity:(EMActivity *)activity withItems:(NSArray *)items {
    [[EMSocialSDK sharedSDK] shareActivityItems:items activity:activity completionHandler:^(NSString *activityType, BOOL completed, NSDictionary *returnedInfo, NSError *activityError) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Result" message:[returnedInfo description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Share result %@", returnedInfo);

    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
