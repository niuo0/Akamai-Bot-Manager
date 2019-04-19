//
//  NSDate+CYFExtra_.m
//  nike
//
//  Created by niu_o0 on 2019/4/16.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "NSDate+CYFExtra_.h"

@implementation NSDate (CYFExtra_)

- (long long)timeIntervalSinceDateInMilliSeconds:(NSDate *)arg1{
    
    NSTimeInterval time = [self timeIntervalSinceDate:arg1];
    
    return lround(time*100);
}

@end
