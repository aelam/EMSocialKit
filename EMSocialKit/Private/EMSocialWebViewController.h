//
//  EMSocialWebViewController.h
//  EMSocialApp
//
//  Created by Ryan Wang on 3/18/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSocialWebViewController : UIViewController

@property (nonatomic, readonly, strong) UIWebView* webView;

- (instancetype)initWithURL:(NSURL *)URL;

- (void)openURL:(NSURL*)URL;
- (void)openRequest:(NSURLRequest*)request;

@end
