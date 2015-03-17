//
//  ymSocialViewController.m
//  Social
//
//  Created by Sam Chen on 13-4-16.
//  Copyright (c) 2013年 emoney. All rights reserved.
//

#import "EMSocialViewController.h"
//#import "EMSocial.h"
//#import "Global.h"
//#import "ymStockWindow.h"
//#import "ymTabBarController.h"
//#import "UIImage+utility.h"
//#import "EMSocial+shareAuto.h"
//#import "EMAppDelegate.h"
//#import "EMRecommendAddressBookViewController.h"

//#import "EMStockWindow.h"
//#import "EMNetworkManager.h"
//#import "BDKNotifyHUD.h"

NSString * const SOCIAL_PARAM_SINA_WEIBO    = @"0";
NSString * const SOCIAL_PARAM_WeChat        = @"1";
NSString * const SOCIAL_PARAM_Friends       = @"2";
NSString * const SOCIAL_PARAM_TENCENT_WEIBO = @"3";
NSString * const SOCIAL_PARAM_QQ            = @"4";
NSString * const SOCIAL_PARAM_QQ_SPACE      = @"5";
NSString * const SOCIAL_PARAM_ADDRESSBOOK   = @"6";

#define SHARE_BUTTON_WIDTH  80
#define SHARE_BUTTON_HEIGHT 90
#define IMAGE_BUTTON_WIDTH  54
#define IMAGE_BUTTON_HEIGHT  54
#define CANCEL_BUTTON_WIDTH 294
#define CANCEL_BUTTON_HEIGHT 42
#define SPACE_WIDTH         0
#define SPACE_HEIGHT        8


static EMSocialViewController *_socialVC;

@interface EMSocialViewController() {
    UIView *_viewButtonBg;
    NSArray *_params;
    UIButton *btnCancel;
}

@property (nonatomic, strong) NSArray *params;;

- (UIButton *)buttonByParam:(NSString *)param;
@end

@implementation EMSocialViewController
@synthesize viewButtonBg = _viewButtonBg;

- (id)init
{
    self = [super init];
    if (self) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        self.modalPresentationStyle = UIModalPresentationCustom;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            self.transitioningDelegate = self;
        }
#endif
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewButtonBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    float bgH = 160;
    _viewButtonBg.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, bgH);
    _viewButtonBg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_viewButtonBg];
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.layer.cornerRadius = 3.f;
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnCancel setTitle:@"取 消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.tag = -1;
    btnCancel.frame = CGRectMake(CGRectGetMaxX(_viewButtonBg.frame)/2-CANCEL_BUTTON_WIDTH/2, SPACE_HEIGHT+SHARE_BUTTON_HEIGHT, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT);
    
    [_viewButtonBg addSubview:btnCancel];
    
    if (3 == self.showButtonCount) {
        self.params = [NSArray arrayWithObjects:SOCIAL_PARAM_SINA_WEIBO,SOCIAL_PARAM_WeChat, SOCIAL_PARAM_Friends, nil]; // 测试
    }
    else
    {
        self.params = [NSArray arrayWithObjects:SOCIAL_PARAM_SINA_WEIBO,SOCIAL_PARAM_WeChat, SOCIAL_PARAM_Friends, SOCIAL_PARAM_ADDRESSBOOK, nil]; // 测试
    }
    
    float space_width = (self.view.frame.size.width - SHARE_BUTTON_WIDTH*_params.count)/(_params.count+1);
    for (int i=0; i<[_params count]; i++) {
        UIButton *btn = [self buttonByParam:[_params objectAtIndex:i]];
        if (btn!=nil) {
            CGRect frame = btn.frame;
            frame.origin.x = (space_width+SHARE_BUTTON_WIDTH)*i+space_width;  // SPACE_WIDTH
            frame.origin.y = SPACE_HEIGHT;
            btn.frame = frame;
            [_viewButtonBg addSubview:btn];
            btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleTopMargin;
        }
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha: 0.6f];
//    _viewButtonBg.backgroundColor = [UIColor colorForKey:@"share_Background"];
//    
//    btnCancel.backgroundColor = [UIColor colorForKey:@"share_CancelButton"];
//    
//    [btnCancel setTitleColor:[UIColor colorForKey:@"share_CancelButtonTitle"] forState:UIControlStateNormal];
    //    [btnCancel setTitleColor:[UIColor menuHighlightedColor] forState:UIControlStateHighlighted];
    
//    if (self.shareEntity.shareImageUrl) {
//        //        [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            [self downloadImage];
//        });
//    }
}

- (void)downloadImage
{
//    NSLog(@"sky test downloadImage %@", [NSThread currentThread]);
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.shareEntity.shareImageUrl]];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (data)
//    {
//        self.shareEntity.shareImage = [UIImage imageWithData:data];
//    }
//    
//    if (self.shareEntity.shareImage == nil)
//    {
//        self.shareEntity.shareImage = [UIImage imageNamed: @"share_app_icon"];
//    }
//    
//    if (self.immediateShareBlock) {
//        self.immediateShareBlock();
//        self.immediateShareBlock = nil; // 因为这个程序是单例的,因此需要清空值,以便下次可以得到正确的结果.
//    }
}

- (void)dismiss:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.viewButtonBg.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, self.viewButtonBg.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view.backgroundColor = [UIColor clearColor];
                             
                             [self dismissViewControllerAnimated: NO completion:NULL];
                         }];
    }
    else
    {
        [self dismissViewControllerAnimated: NO completion:NULL];
    }
}

- (UIButton *)buttonByParam:(NSString *)param
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = [param intValue];
    
    [btn addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, SHARE_BUTTON_WIDTH, SHARE_BUTTON_HEIGHT);
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(18, 15, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH)];
    [btn addSubview:imgv];
    
    NSString *titleLocal = @"";
    if ([param isEqualToString:SOCIAL_PARAM_QQ]) {
        titleLocal = @"腾讯QQ";
        [imgv setImage: [UIImage imageNamed:@"qq"]];
//        [btn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    }
    else if ([param isEqualToString:SOCIAL_PARAM_QQ_SPACE]) {
        titleLocal = @"QQ空间";
        [imgv setImage: [UIImage imageNamed:@"qq空间"]];
//        [btn setImage:[UIImage imageNamed:@"qq空间"] forState:UIControlStateNormal];
    }
    else if ([param isEqualToString:SOCIAL_PARAM_WeChat]) {
        titleLocal = @"微信";
        [btn setImage:[UIImage imageNamed:@"jf_btn_wechat"] forState:UIControlStateNormal];
    }
    else if ([param isEqualToString:SOCIAL_PARAM_Friends]) {
        titleLocal = @"朋友圈";
        [btn setImage:[UIImage imageNamed:@"jf_btn_moment"] forState:UIControlStateNormal];
    }
    else if ([param isEqualToString:SOCIAL_PARAM_TENCENT_WEIBO]) {
        titleLocal = @"腾讯微博";
        [btn setImage:[UIImage imageNamed:@"info_tengxunwb"] forState:UIControlStateNormal];
    }
    else if ([param isEqualToString:SOCIAL_PARAM_SINA_WEIBO]) {
        titleLocal = @"新浪微博";
        [btn setImage:[UIImage imageNamed:@"jf_btn_weibo"] forState:UIControlStateNormal];
    }
    else if ([param isEqualToString:SOCIAL_PARAM_ADDRESSBOOK]) {
        titleLocal = @"通讯录";
        [btn setImage:[UIImage imageNamed:@"jf_btn_address"] forState:UIControlStateNormal];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, IMAGE_BUTTON_HEIGHT, SHARE_BUTTON_WIDTH, SHARE_BUTTON_HEIGHT-IMAGE_BUTTON_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.text = titleLocal;
    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor textColor];
    label.font = [UIFont systemFontOfSize:14];
//    label.textColor = [UIColor colorForKey:@"share_LabelTextColor"];
    label.tag = 100;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [btn addSubview:label];
    
    return btn;
}

- (UIImage *)captureScreen:(CGFloat)resolution
{
    self.view.hidden = YES;
//    UIImage *img = [UIImage captureScreen: resolution];
    self.view.hidden = NO;
    UIImage *img = nil;
    
    return img;
}

- (void)pressButton:(id)sender
{
    UIButton *btn = sender;

    if ([SOCIAL_PARAM_ADDRESSBOOK intValue] == btn.tag) {
        self.viewButtonBg.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, self.viewButtonBg.frame.size.height);
        [self share: SOCIAL_PARAM_ADDRESSBOOK];
        
        return;
    }
    
    if (-1 != btn.tag)
    {
        NSString *param = [NSString stringWithFormat:@"%ld", (long)btn.tag];
        [self performSelector: @selector(share:) withObject: param afterDelay: 0.3];
        [self dismiss: NO];
    }
    else
    {
        [self dismiss: YES];
    }
}

//- (void)share:(NSString *)param
//{
//    CGFloat scale = [UIScreen mainScreen].scale;
//    
//    if ([param isEqualToString:SOCIAL_PARAM_QQ])
//    {
//        [EMSocial shareWithType:EMSocialTypeQQ title:kDefaultShareText image:nil];
//    }
//    else if ([param isEqualToString:SOCIAL_PARAM_WeChat])
//    {
//        //            [EMSocial shareWithType:EMSocialTypeWeChat title:kDefaultShareText image:[self captureScreen]];
//        
//        if (self.shareEntity.isSendScreenCapture)  // 发送截屏
//        {
//            [EMSocial shareWithType:EMSocialTypeWeChat title:self.shareEntity.shareTitle image:[self captureScreen:scale] description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//        }
//        else  // 发送链接
//        {
//            if (self.shareEntity.shareImageUrl)  // 网页分享
//            {
//                if (self.shareEntity.shareImage) {
//                    [EMSocial shareWithType:EMSocialTypeWeChat title:self.shareEntity.shareTitle image:self.shareEntity.shareImage description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//                }
//                else
//                {
//                    [EMSocial shareWithType:EMSocialTypeWeChat title:self.shareEntity.shareTitle image: [UIImage imageNamed: @"share_app_icon"] description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//                }
//            }
//            else
//            {
//                [EMSocial shareWithType:EMSocialTypeWeChat title:self.shareEntity.shareTitle image:self.shareEntity.shareImage description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//            }
//        }
//    }
//    else if ([param isEqualToString:SOCIAL_PARAM_Friends])
//    {
//        //            [EMSocial shareWithType:EMSocialTypeMoments title:kDefaultShareText image:[self captureScreen]];
//        
//        if (self.shareEntity.isSendScreenCapture)  // 发送截屏
//        {
//            [EMSocial shareWithType:EMSocialTypeMoments title:self.shareEntity.shareTitle image:[self captureScreen:scale] description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//        }
//        else  // 发送链接
//        {
//            if (self.shareEntity.shareImageUrl)  // 网页分享
//            {
//                if (self.shareEntity.shareImage) {
//                    [EMSocial shareWithType:EMSocialTypeMoments title:self.shareEntity.shareTitle image:self.shareEntity.shareImage description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//                }
//                else
//                {
//                    [EMSocial shareWithType:EMSocialTypeMoments title:self.shareEntity.shareTitle image: [UIImage imageNamed: @"share_app_icon"] description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//                }
//            }
//            else
//            {
//                [EMSocial shareWithType:EMSocialTypeMoments title:self.shareEntity.shareTitle image:self.shareEntity.shareImage description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//            }
//        }
//    }
//    else if ([param isEqualToString:SOCIAL_PARAM_TENCENT_WEIBO])
//    {
//        if (self.shareEntity.isSendScreenCapture)  // 发送截屏
//        {
//            [EMSocial shareWithType:EMSocialTypeTXWeibo title:[NSString stringWithFormat: @"%@%@", self.shareEntity.shareTitle, self.shareEntity.shareUrl] image:[self captureScreen:1.0] description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//        }
//        else  //
//        {
//            if (self.shareEntity.shareImage) {
//                [EMSocial shareWithType:EMSocialTypeTXWeibo title:self.shareEntity.shareTitle image:self.shareEntity.shareImage description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//            }
//            else
//            {
//                [EMSocial shareWithType:EMSocialTypeTXWeibo title:self.shareEntity.shareTitle image: [UIImage imageNamed: @"share_app_icon"] description:self.shareEntity.shareDescription Url:self.shareEntity.shareUrl];
//            }
//        }
//    }
//    else if ([param isEqualToString:SOCIAL_PARAM_SINA_WEIBO])
//    {
//        if (!self.shareEntity.shareUrl) {
//            self.shareEntity.shareUrl = @"";
//        }
//        
//        NSString *title;
//        NSString *description;
//        
//        if (self.shareEntity.isShareApp) {
//            title = [NSString stringWithFormat: @"%@%@", self.shareEntity.shareDescription, self.shareEntity.shareUrl];
//            description = self.shareEntity.shareTitle;
//        }
//        else
//        {
//            title = [NSString stringWithFormat: @"%@%@", self.shareEntity.shareTitle, self.shareEntity.shareUrl];
//            description = self.shareEntity.shareDescription;
//        }
//        
//        if (self.shareEntity.isSendScreenCapture)  // 发送截屏
//        {
//            [EMSocial shareWithType:EMSocialTypeSinaWeibo title:title image:[self captureScreen:scale] description:description Url:self.shareEntity.shareUrl];
//        }
//        else  //
//        {
//            if (self.shareEntity.shareImage) {
//                [EMSocial shareWithType:EMSocialTypeSinaWeibo title:title image:self.shareEntity.shareImage description:description Url:self.shareEntity.shareUrl];
//            }
//            else
//            {
//                [EMSocial shareWithType:EMSocialTypeSinaWeibo title:title image: [UIImage imageNamed: @"share_app_icon"] description:description Url:self.shareEntity.shareUrl];
//            }
//        }
//    }
//    else if ([param isEqualToString:SOCIAL_PARAM_ADDRESSBOOK])
//    {
//        UINavigationController* navController = self.rootViewController.navigationController;
//        [self dismiss:NO];
//        EMRecommendAddressBookViewController* controller = [[EMRecommendAddressBookViewController alloc]init];
//        [navController pushViewController:controller animated:YES];
////        if (!self.addressBookView) {
////            self.addressBookView = [[EMRecommendAddressBook alloc] initWithFrame:self.view.bounds target:self selector:@selector(doRecommendation)];
////            
////            __weak EMSocialViewController *weakSelf = self;
////            //实现block
////            self.addressBookView.dismissUIBlock = ^()
////            {
////                [weakSelf dismiss: NO];
////            };
////        }
////        
////        [self.view addSubview:self.addressBookView];
////        [self.addressBookView.phoneNumTextField becomeFirstResponder];
//    }
//}

//- (void)doRecommendation
//{
//    NSString *phoneNumText = _addressBookView.phoneNumTextField.text;
//    if ([phoneNumText length] == 0) {
//        return;
//    }
//    NSDictionary *params = @{@"FriendUsername":phoneNumText};
//    
//    NSOperation *operation = [[EMNetworkManager manager] authenticatePOST:kRecommondateURL params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [_operationArray removeObject:operation];
//        BOOL success = [[responseObject objectForKey:@"success"] boolValue];
//        if (success) {
//            if ([[responseObject objectForKey:@"data"] boolValue]) {
//                [self addEventWithName:@"手机号推荐成功"];
//                [_addressBookView removeFromSuperview];
//            }
//            NSString *message = [responseObject objectForKey:@"message"];
//            [BDKNotifyHUD showNotifHUDWithText:message];
//        }
//        else {
//            if (![[responseObject objectForKey:@"isExceptionError"] boolValue]) {
//                NSString *message = [responseObject objectForKey:@"message"];
//                [BDKNotifyHUD showNotifHUDWithText:message];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_operationArray removeObject:operation];
//        ;
//    }];
//    
//    if (operation)
//    {
//        [_operationArray addObject:operation];
//    }
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss: YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // 横竖屏未适配
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
//        float bgH = -(-CANCEL_BUTTON_HEIGHT-SPACE_HEIGHT-20-(SPACE_HEIGHT+SHARE_BUTTON_HEIGHT)*[_params count]/2-SPACE_HEIGHT);
//        _viewButtonBg.frame = CGRectMake(0, self.view.bounds.size.height-bgH, maskView.frame.size.width, bgH);
    }
    else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
        
    }
}

@end
