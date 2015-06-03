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


static NSString *kActivityCellIdentifier = @"kActivityCellIdentifier";
static CGFloat kDefaultHeight = 160.f;


@interface EMActivityViewController () <UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *activityItems;
@property (nonatomic, strong) NSArray *applicationActivities;
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;
@property (nonatomic, strong, readwrite) UIButton *closeButton;
@property (nonatomic, assign) NSString *selectedActivityType;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end


@implementation EMActivityViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
    if (self = [super init]) {
        self.activityItems = activityItems;
        self.applicationActivities = applicationActivities;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        
    }
    
    return self;
}

- (CGSize)preferredContentSize {
    return CGSizeMake(self.view.frame.size.width, kDefaultHeight);
}


- (void)viewDidLoad {
    [super viewDidLoad];

#if 1
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 1;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, kDefaultHeight);
#endif
    
    CGRect collectionViewRect = self.view.bounds;
    collectionViewRect.size.height = kDefaultHeight;
    
    collectionViewRect.size.height = collectionViewRect.size.height - 50;
    self.collectionView.frame = collectionViewRect;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    self.collectionView.layer.borderColor = [UIColor greenColor].CGColor;
    self.collectionView.layer.borderWidth = 1;
    
    CGRect closeRect = self.view.bounds;//
    closeRect.origin.y = collectionViewRect.size.height;
    closeRect.size.height = 50;
    self.closeButton.frame = closeRect;
    self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
//    self.closeButton.layer.borderColor = [UIColor cyanColor].CGColor;
//    self.closeButton.layer.borderWidth = 1;

    [self setUpActivitiesUI];
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


- (void)setUpActivitiesUI {
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
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[_EMActivityViewCell class] forCellWithReuseIdentifier:kActivityCellIdentifier];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    CGRect closeRect = self.view.bounds;//
    closeRect.origin.y = collectionViewRect.size.height;
    closeRect.size.height = 50;
    self.closeButton.frame = closeRect;
    self.closeButton.backgroundColor = [UIColor whiteColor];
    [self.closeButton setTitleColor:[UIColor em_colorWithHexString:@"F84E14"] forState:UIControlStateNormal];
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
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.applicationActivities.count > indexPath.row) {
        [self dismiss:nil];
        EMActivity *activity = self.applicationActivities[indexPath.row];
        self.selectedActivityType = activity.activityType;
        
        
        [EMSocialSDK sharedSDK].activityViewController = self;;
        [activity prepareWithActivityItems:self.activityItems];
        [activity performActivity];
    }
}


- (void)_handleAcitivityType:(NSString *)activityType completed:(BOOL)completed returnInfo:(NSDictionary *)returnedInfo activityError:(NSError *) activityError {
        [EMSocialSDK sharedSDK].activityViewController = nil;
    if (self.completionWithItemsHandler) {
        self.completionWithItemsHandler(activityType,completed, returnedInfo, activityError);
    }
}

- (void)cancelAction:(id)sender {
    if (self.completionWithItemsHandler) {
        NSError *activityError = [NSError errorWithDomain:@"EMActivityViewController" code:100 userInfo:@{NSLocalizedDescriptionKey:@"用户取消"}];
        self.completionWithItemsHandler(self.selectedActivityType,YES, nil, activityError);
    }
    [self dismiss:nil];
}

#pragma mark - UIVieControllerTransitioningDelegate -
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    EMSSlideUpTransitionAnimator *slideUpTransitionAnimator = [EMSSlideUpTransitionAnimator animator];
    slideUpTransitionAnimator.presenting = YES;
    return slideUpTransitionAnimator;
}

#pragma mark - Rotate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    EMSSlideUpTransitionAnimator *slideUpTransitionAnimator = [EMSSlideUpTransitionAnimator animator];
    slideUpTransitionAnimator.presenting = NO;
    return slideUpTransitionAnimator;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;//|;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}



- (void)dealloc {
    
}

@end
