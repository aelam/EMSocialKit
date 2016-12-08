//
//  EMSocialWebViewController.m
//  EMSocialApp
//
//  Created by Ryan Wang on 3/18/15.
//  Copyright (c) 2015 Ryan Wang. All rights reserved.
//

#import "EMSocialWebViewController.h"

@interface EMSocialWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest* loadRequest;

@end

@implementation EMSocialWebViewController

- (void)dealloc {
    _webView.delegate = nil;
}


- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.hidesBottomBarWhenPushed = YES;
        [self openRequest:request];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithRequest:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    if (nil != self.loadRequest) {
        [self.webView loadRequest:self.loadRequest];
    }
}

- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}

- (void)openRequest:(NSURLRequest *)request {
    self.loadRequest = request;
    
    if ([self isViewLoaded]) {
        if (nil != request) {
            [self.webView loadRequest:request];
            
        } else {
            [self.webView stopLoading];
        }
    }
}

- (void)cancel:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
