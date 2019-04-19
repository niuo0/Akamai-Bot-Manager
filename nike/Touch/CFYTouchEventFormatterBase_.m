//
//  CFYTouchEventFormatterBase_.m
//  nike
//
//  Created by niu_o0 on 2019/4/16.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CFYTouchEventFormatterBase_.h"
#import "NSDate+CYFExtra_.h"

@implementation CFYTouchEventFormatterBase_

- (NSString *)formatTypeString{
    return [NSString stringWithFormat:@"%lu", 0];
}

- (id)formatTouchData:(CYFTouchData_ *)arg1 withLastEventTime:(NSDate *)arg2{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:@"" forKey:@"datastring"];
    
    if (arg1) {
        
        long long t = [arg1.timeStamp timeIntervalSinceDateInMilliSeconds:arg2];
        
        NSString * string = [NSString stringWithFormat:@"%@,%ld,%@,%@,%lu,%@,%@,%@;", arg1.touchEventType, t, arg1.xCords, arg1.yCords, arg1.tapCount, self.formatTypeString, @"-1", arg1.touchViewAddressString];
        
        [dic setObject:string forKey:@"datastring"];
        
        NSInteger y = [arg1.yCords integerValue];
        
        NSInteger r10 = [arg1.xCords integerValue];
        
        NSInteger r11 = [arg1.touchEventType integerValue];
        
        [dic setObject:[NSNumber numberWithInteger:t+y+r10+r11] forKey:@"eventvelocity"];
        
    }
    
    return dic;
}

@end
