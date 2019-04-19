//
//  NSString+CYFExtra_.h
//  nike
//
//  Created by niu_o0 on 2019/4/11.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CYFExtra_)

+ (BOOL)isEmptyOrNil:(NSString *)string;

- (NSString *)percentEncode;

@end

NS_ASSUME_NONNULL_END
