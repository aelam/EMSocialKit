//
//  EMBridgeActivity.h
//  EMSocialApp
//
//  Created by Ryan Wang on 15/3/18.
//  Copyright (c) 2015年 Ryan Wang. All rights reserved.
//

#import "EMActivity.h"
#define USE_EM_ACTIVITY 1

@interface EMBridgeActivity :
#if USE_EM_ACTIVITY
EMActivity
#else
UIActivity
#endif


@end
