//
//  CYFUtilities_.h
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * DEFAULT_PERFORMANCE_VALUE = @"-1,-1,-1,-1,-1,-1,-1,-1,-1";

typedef void(^voidBlock)(void);

@interface CYFUtilities_ : NSObject

+ (id)NSDataToArray:(NSData *)arg1;
+ (double)now;
+ (id)measurePerformance;
+ (BOOL)isIOSVersionAtLeastVersion:(id)arg1;
+ (_Bool)IOS9OrHigher;
+ (_Bool)IOS8OrHigher;
+ (_Bool)IOS7OrHigher;
+ (id)removeUnnecessaryZerosInString:(id)arg1;
+ (long long)strToInt:(id)arg1;
+ (void)dispatchOnMainThread:(voidBlock)arg1 synchronously:(_Bool)arg2;

@end

NS_ASSUME_NONNULL_END
