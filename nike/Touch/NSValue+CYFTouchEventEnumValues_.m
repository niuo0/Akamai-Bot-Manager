//
//  NSValue+CYFTouchEventEnumValues_.m
//  nike
//
//  Created by niu_o0 on 2019/4/16.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "NSValue+CYFTouchEventEnumValues_.h"

@implementation NSValue (CYFTouchEventEnumValues_)

+ (id)valuewithTouchDataFormatterType:(unsigned long long)arg1 {
    
    return [self valueWithBytes:&arg1 objCType:@encode(long long)];
    
}

@end
