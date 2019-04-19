//
//  FeistelCipher_.h
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeistelCipher_ : NSObject

+ (unsigned long long)decode:(unsigned long long)arg1 withKey:(unsigned int)arg2;
+ (unsigned long long)encode:(unsigned long long)arg1 withKey:(unsigned int)arg2;

@end

NS_ASSUME_NONNULL_END
