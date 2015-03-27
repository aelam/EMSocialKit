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
@property (nonatomic, strong) NSURL* loadingURL;

@property (nonatomic, strong) NSURLRequest* loadRequest;

@end

@implementation EMSocialWebViewController

- (void)dealloc {
    _webView.delegate = nil;
}

- (id)initWithRequest:(NSURLRequest *)request {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.hidesBottomBarWhenPushed = YES;
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        [self openRequest:request];
    }
    return self;
}

- (id)initWithURL:(NSURL *)URL {
    return [self initWithRequest:[NSURLRequest requestWithURL:URL]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithRequest:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
