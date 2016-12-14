//
//  EMSKUserInfo.m
//  Pods
//
//  Created by ryan on 14/12/2016.
//
//

#import "EMSKUserInfo.h"

@implementation EMSKUserInfo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.socialType forKey:@"socialType"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.openId forKey:@"openId"];
    [aCoder encodeObject:self.unionId forKey:@"unionId"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [aCoder encodeObject:self.expireDate forKey:@"expireDate"];
    [aCoder encodeObject:self.profileImageURL forKey:@"profileImageURL"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.socialType = [aDecoder decodeObjectForKey:@"socialType"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.openId = [aDecoder decodeObjectForKey:@"openId"];
        self.unionId = [aDecoder decodeObjectForKey:@"unionId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.refreshToken = [aDecoder decodeObjectForKey:@"refreshToken"];
        self.expireDate = [aDecoder decodeObjectForKey:@"expireDate"];
        self.profileImageURL = [aDecoder decodeObjectForKey:@"profileImageURL"];
    }
    return self;
}

@end
