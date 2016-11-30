//
//  NSDictionary+sk_toQuery.m
//  Pods
//
//  Created by ryan on 29/11/2016.
//
//

#import "NSDictionary+sk_toQuery.h"
#import "NSString+SK_URLEncode.h"

@implementation NSDictionary (sk_toQuery)

- (NSString *)SK_toQuery {
    NSMutableArray *parts = [NSMutableArray array];
    for(NSString *key in self) {
        NSString *value = [NSString stringWithFormat:@"%@",self[key]];
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSString *encodedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSString *kv = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
        [parts addObject:kv];
    }
    
    return [parts componentsJoinedByString:@"&"];
}

@end
