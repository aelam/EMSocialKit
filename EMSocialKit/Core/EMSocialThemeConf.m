//
//  EMSocialThemeConf.m
//  EMSocialKit
//
//  Created by ryan on 2019/2/12.
//

#import "EMSocialThemeConf.h"

#define EMSOCIAL_RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define EMSOCIAL_RGB(r,g,b) EMSOCIAL_RGBA(r,g,b,1)

@implementation EMSocialThemeConf

static EMSocialThemeConf *_defaultConf;

+ (void)setDefaultConf:(id<SocialThemeConf>)conf {
    _defaultConf = conf;
}

+ (instancetype)defaultConf {
    if (_defaultConf) {
        return _defaultConf;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConf = [EMSocialThemeConf whiteConf];
    });
    
    return _defaultConf;
}

@end


@implementation EMSocialThemeConf (Themes)

+ (instancetype)whiteConf {
    EMSocialThemeConf *conf = [EMSocialThemeConf new];

    conf.separatorColor = EMSOCIAL_RGB(0x36,0x36,0x36);
    conf.cancelTitleColor = EMSOCIAL_RGB(0x3d,0x3d,0x3d);
    conf.backgroundColor = EMSOCIAL_RGB(0xf2,0xf2,0xF2);
    conf.activityTitleColor = EMSOCIAL_RGB(0x3d,0x3d,0x3d);
    conf.cancelBackgroundColor = [UIColor whiteColor];
    
    return conf;
}

+ (instancetype)blackConf {
    EMSocialThemeConf *conf = [EMSocialThemeConf new];

    conf.separatorColor = EMSOCIAL_RGB(0x36,0x36,0x36);
    conf.cancelTitleColor = [UIColor whiteColor];
    conf.backgroundColor = EMSOCIAL_RGB(0x28,0x29,0x2c);
    conf.activityTitleColor = [UIColor whiteColor];
    conf.cancelBackgroundColor = EMSOCIAL_RGB(0x28,0x29,0x2c);

    return conf;
}

@end
