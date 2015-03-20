//
//  AppDelegate.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/17/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "AppDelegate.h"
//#import "WeiboSDK.h"
//#import "EMStockActivityWeibo.h"

#import "WXApi.h"
#import "WeiboSDK.h"

#define kWeiChatAppID               @"wx85e5bbec559cd907"//wxd50de003b78b9c87 // old wx6f0c62844c4ebbb5
#define kWeiChatAppKey              @"637c8424532704e01532cbb3634f3031"  // old f8c106a9a0bc385a02abd8db4a29790f


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WXApi registerApp:kWeiChatAppID];
    [WeiboSDK registerApp:@"1779442884"];
    [WeiboSDK enableDebugMode:YES];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
