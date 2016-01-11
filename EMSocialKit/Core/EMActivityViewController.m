//
//  EMActivityViewController.m
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMActivityViewController.h"
#import "EMSSlideUpTransitionAnimator.h"
#import "_EMActivityViewCell.h"
#import "EMActivity.h"
#import "EMSocialSDK.h"

#define EMSOCIAL_RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define EMSOCIAL_RGB(r,g,b) EMSOCIAL_RGBA(r,g,b,1)

static NSString *kActivityCellIdentifier = @"kActivityCellIdentifier";
static CGFloat kDefaultHeight = 166.f;


@interface EMActivityViewController () <UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, strong) NSArray *applicationActivities;
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) UIButton *closeButton;
@property (nonatomic, assign) NSString *selectedActivityType;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

// About Theme 
@property(nonatomic, strong)UIColor *cancelBackgroundColor;
@property(nonatomic, strong)UIColor *cancelBorderColor;
@property(nonatomic, strong)UIColor *backgroundColor;
@property(nonatomic, strong)UIColor *activityTitleColor;
@property(nonatomic, strong, readwrite)EMActivity *activeActivity;

@end


@implementation EMActivityViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
    if (self = [super init]) {
        self.activityItems = activityItems;
        self.applicationActivities = applicationActivities;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.activityTitleColor = [UIColor darkGrayColor];
        self.activityStyle = EMActivityStyleBlack;
    }
    
    return self;
}

- (void)loadView {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, kDefaultHeight)];
}

- (CGSize)preferredContentSize {
    return CGSizeMake(self.view.frame.size.width, kDefaultHeight);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpActivitiesUI];
    
    if (self.activityStyle == EMActivityStyleWhite) {
        [self loadWhiteTheme];
    } else {
        [self loadBlackTheme];
    }
    [self updateUIForTheme];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // this moment the self.view.window != nil
    [self addCloseGestureOnWindow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeGesture];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)loadWhiteTheme {
    self.backgroundColor = EMSOCIAL_RGB(0xf2,0xf2,0xF2);
    self.activityTitleColor = EMSOCIAL_RGB(0x3d,0x3d,0x3d);
    self.cancelBackgroundColor = [UIColor whiteColor];
    self.cancelBorderColor = [UIColor whiteColor];
}

- (void)loadBlackTheme {
    self.backgroundColor = EMSOCIAL_RGB(0x28,0x29,0x2c);
    self.activityTitleColor = [UIColor whiteColor];
    self.cancelBackgroundColor = EMSOCIAL_RGB(0x3e,0x40,0x4f);
    self.cancelBorderColor = EMSOCIAL_RGB(0x5b,0x5b,0x5b);
}

- (void)updateUIForTheme {
    self.view.backgroundColor = self.backgroundColor;
    self.closeButton.backgroundColor = self.cancelBackgroundColor;
    self.closeButton.layer.borderWidth = 1;
    self.closeButton.layer.cornerRadius = 3;
    self.closeButton.layer.borderColor = self.cancelBorderColor.CGColor;
}

- (void)setApplicationActivities:(NSArray *)applicationActivities {
    if (_applicationActivities != applicationActivities) {
        _applicationActivities = applicationActivities;
    }
    [self.collectionView reloadData];
}

- (void)addCloseGestureOnWindow {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view.window addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)removeGesture {
    [self.view.window removeGestureRecognizer:self.tapGestureRecognizer];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if ([self isViewLoaded]) {
        self.view.backgroundColor = _backgroundColor;
    }
}

- (void)setUpActivitiesUI {
    self.view.backgroundColor = self.backgroundColor;
    CGRect collectionViewRect = self.view.bounds;
    collectionViewRect.size.height = collectionViewRect.size.height - 50;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat screenWidth = [UIScreen mainScreen].applicationFrame.size.width;
    flowLayout.itemSize = CGSizeMake((screenWidth - 20) /3.0, 110);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[_EMActivityViewCell class] forCellWithReuseIdentifier:kActivityCellIdentifier];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CGRect closeRect = self.view.bounds;//
    closeRect.origin.y = collectionViewRect.size.height;
    closeRect.size.height = 60;
    closeRect = UIEdgeInsetsInsetRect(closeRect, UIEdgeInsetsMake(0, 15, 20, 15));
    self.closeButton.frame = closeRect;
    [self.closeButton setTitleColor:EMSOCIAL_RGB(0x51, 0x96, 0xef) forState:UIControlStateNormal];
    self.closeButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.closeButton];
    
    [self.closeButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark UIGestureRecognizerDelegate -
- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    // dimiss and clear tapGestureRecognizer
    [self.view.window removeGestureRecognizer:sender];
    [self dismiss:nil];
    self.tapGestureRecognizer = nil;
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:nil];
    // if tap outside pincode inputscreen
    BOOL inView = [self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil];
    // if tap outside pincode inputscreen
    if (!inView)
    {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

#pragma mark - UICollectionViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.applicationActivities.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _EMActivityViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kActivityCellIdentifier forIndexPath:indexPath];
    if (self.applicationActivities.count > indexPath.row) {
        EMActivity *activity = self.applicationActivities[indexPath.row];
        cell.activityTitleLabel.text = activity.activityTitle;
        cell.activityImageView.image = activity.activityImage;
        cell.activityTitleLabel.textColor = self.activityTitleColor;
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.applicationActivities.count > indexPath.row) {
        [self dismissViewControllerAnimated:YES completion:^{
            EMActivity *activity = self.applicationActivities[indexPath.row];
            self.selectedActivityType = activity.activityType;
            self.activeActivity = activity;
            
            [self.activeActivity prepareWithActivityItems:self.activityItems];
            [self.activeActivity performActivity];
            
            if (self.completionWithItemsHandler) {
                self.completionWithItemsHandler(self.activeActivity, YES, NULL, nil);
            }

        }];
    }
}


- (void)cancelAction:(id)sender {
    if (self.completionWithItemsHandler) {
        NSError *activityError = [NSError errorWithDomain:@"EMActivityViewController" code:100 userInfo:@{NSLocalizedDescriptionKey:@"用户取消"}];
        self.completionWithItemsHandler(self.activeActivity,YES, nil, activityError);
    }
    [self dismiss:nil];
}

#pragma mark - UIVieControllerTransitioningDelegate -
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    EMSTransitionAnimator *slideUpTransitionAnimator = [EMSocialSDK sharedSDK].transitionAnimator;
    slideUpTransitionAnimator.presenting = YES;
    return slideUpTransitionAnimator;
}

#pragma mark - Rotate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    EMSTransitionAnimator *slideUpTransitionAnimator = [EMSocialSDK sharedSDK].transitionAnimator;
    slideUpTransitionAnimator.presenting = NO;
    return slideUpTransitionAnimator;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    
}

@end
