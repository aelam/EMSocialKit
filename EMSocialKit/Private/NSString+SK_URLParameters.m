//
//  NSDictionary+EMSocialQueries.m
//  Pods
//
//  Created by ryan on 28/11/2016.
//
//

#import "NSString+SK_URLParameters.h"
#import "NSString+SK_URLEncode.h"

@implementation NSString (URLParameters)

- (NSDictionary *)SK_URLParameters {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSArray *components = [self componentsSeparatedByString:@"&"];
    for (NSString *item in components) {
        NSArray *itemComponents = [item componentsSeparatedByString:@"="];
        if ([itemComponents count] == 2) {
            NSString *key = [itemComponents[0] SK_URLDecodedString];
            NSString *value = [itemComponents[1] SK_URLDecodedString];
            parameters[key] = value;
        }
    }
    return parameters;
}


@end
