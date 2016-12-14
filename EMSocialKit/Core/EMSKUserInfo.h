//
//  EMSKUserInfo.h
//  Pods
//
//  Created by ryan on 14/12/2016.
//
//

#import <Foundation/Foundation.h>

@interface EMSKUserInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *socialType;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *unionId; // 微信使用
@property (nonatomic, copy) NSString *name;    //
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, strong) NSDate *expireDate;
@property (nonatomic, copy) NSString *profileImageURL;

@end
