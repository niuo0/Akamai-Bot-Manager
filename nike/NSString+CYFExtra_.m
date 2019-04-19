//
//  NSString+CYFExtra_.m
//  nike
//
//  Created by niu_o0 on 2019/4/11.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "NSString+CYFExtra_.h"

@implementation NSString (CYFExtra_)

+ (BOOL)isEmptyOrNil:(NSString *)string{
    
    if (string == nil) { return  YES; }
    
    if ([string isEqualToString:@""]) { return YES; }
    
    return NO;
}


- (NSString *)percentEncode{
    
    static NSCharacterSet * allowed;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSMutableCharacterSet * set = [NSMutableCharacterSet alphanumericCharacterSet];
        [set addCharactersInString:@"!#$&()*+-./:;<=>?@[]^_`{|}~"];
        allowed = [set copy];
        
    });
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowed];
    
}



@end
