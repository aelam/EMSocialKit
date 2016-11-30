//
//  NSDictionary+Unicode.m
//  EMSocialApp
//
//  Created by ryan on 29/11/2016.
//  Copyright © 2016 Ryan Wang. All rights reserved.
//

#import "NSDictionary+Unicode.h"
#import <JRSwizzle/JRSwizzle.h>

@implementation NSDictionary (Unicode)

+ (void)load {
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
}

- (NSString*)my_description {
    NSString *desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}
@end
