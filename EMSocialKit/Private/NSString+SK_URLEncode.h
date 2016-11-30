//
//  NSString+SK_URLEncode.h
//  Pods
//
//  Created by ryan on 29/11/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSString (SK_URLEncode)

/**
 *  URL encode
 *
 *  @return encode后的字符串
 */
- (NSString *)SK_URLEncodedString;


/**
 *  URL decode
 *
 *  @return decode后的字符串
 */
- (NSString *)SK_URLDecodedString;


@end
