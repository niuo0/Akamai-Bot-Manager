//
//  CYFUtilities_.m
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFUtilities_.h"
#import <UIKit/UIKit.h>

@implementation CYFUtilities_

+ (void)dispatchOnMainThread:(voidBlock)arg1 synchronously:(bool)arg2{
    
    if ([NSThread isMainThread]) {
        
        arg1();
        
    }else{
        
        if (arg2) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                arg1();
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                arg1();
            });
        }
        
    }
    
}

+ (long long)strToInt:(NSString *)arg1 {
    
    if ([NSNull null] == arg1) {
        
        return 0;
        
    }
    
    if (![arg1 length]) {
        return 0;
    }
    
    int v9 = 0;
    long long v16 = 0;
    do {
        
        unichar c = [arg1 characterAtIndex:v9];
        
        NSNumber * n = [NSNumber numberWithUnsignedChar:c];
        
        if (n.integerValue <= 127) {
            v16 += n.integerValue;
        }
        
        ++v9;
        
    }while (v9 < arg1.length);
    
    return v16;
}

+ (id)removeUnnecessaryZerosInString:(id)arg1{
    
    NSError *err1, *err2, *err3;
    
    NSRegularExpression * reg1 = [NSRegularExpression regularExpressionWithPattern:@"\\b(\\d*)(\\.[0]+)\\b" options:0 error:&err1];
    
    NSRegularExpression * reg2 = [NSRegularExpression regularExpressionWithPattern:@"\\b(0+)(\\.)\\b" options:0 error:&err2];
    
    NSRegularExpression * reg3 = [NSRegularExpression regularExpressionWithPattern:@"-0+(?!\\.)\\b" options:0 error:&err3];
    
    if (!err1 && !err2 && !err3) {
        
        NSMutableString * string = [NSMutableString stringWithString:arg1];
        
        [reg1 replaceMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@"$1"];
        
        [reg2 replaceMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@"$2"];
        
        [reg3 replaceMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@"0"];
        
        return string;
    }
    
    return arg1;
}

+ (BOOL)isIOSVersionAtLeastVersion:(id)arg1{
    
    NSString * v = [[UIDevice currentDevice] systemVersion];
    
    NSComparisonResult res = [v compare:arg1 options:NSNumericSearch];
    
    if (res == NSOrderedAscending) {return  NO; }
    
    return  YES;
}

+ (bool)IOS7OrHigher{
    return [self isIOSVersionAtLeastVersion:@"7.0"];
}

+ (bool)IOS8OrHigher{
    return [self isIOSVersionAtLeastVersion:@"8.0"];
}

+ (bool)IOS9OrHigher{
    return [self isIOSVersionAtLeastVersion:@"9.0"];
}

+ (double)now{
    return [[NSDate date] timeIntervalSince1970];
}

+ (id)NSDataToArray:(NSData *)arg1{
    
    _BYTE * b = arg1.bytes;
    
    NSMutableString * string = [NSMutableString stringWithCapacity:arg1.length*4];
    
    NSUInteger l = arg1.length;
    
    if (l) {
        
        NSUInteger tmp = 0;
        
        do {
            
            [string appendFormat:@"%d", b[tmp]];
            
            if (tmp < l-1) {
                [string appendString:@","];
            }
            
            ++ tmp;
            
        }while (tmp != l);
        
    }
    
    return [NSString stringWithString:string];
    
}

@end
