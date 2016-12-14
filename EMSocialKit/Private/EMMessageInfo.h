//
//  EMMessageInfo.h
//  Pods
//
//  Created by ryan on 07/12/2016.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMMessageInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) UIImage *thumbNail;
@property (nonatomic, strong) NSURL *shareURL;

@end
