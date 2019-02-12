//
//  EMSocialThemeConf.h
//  EMSocialKit
//
//  Created by ryan on 2019/2/12.
//

#import <UIKit/UIKit.h>

@protocol SocialThemeConf<NSObject>

@property (nonatomic, strong) UIColor *separatorColor; // 取消按钮上面的线
@property (nonatomic, strong) UIColor *cancelTitleColor; // 取消按钮
@property (nonatomic, strong) UIColor *cancelBackgroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *activityTitleColor;

@end

@interface EMSocialThemeConf : NSObject <SocialThemeConf>

@property (nonatomic, strong) UIColor *separatorColor; // 取消按钮上面的线
@property (nonatomic, strong) UIColor *cancelTitleColor; // 取消按钮
@property (nonatomic, strong) UIColor *cancelBackgroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *activityTitleColor;

+ (void)setDefaultConf:(id<SocialThemeConf>)conf;
+ (instancetype)defaultConf;

@end

@interface EMSocialThemeConf (Themes)

+ (instancetype)whiteConf;
+ (instancetype)blackConf;

@end
