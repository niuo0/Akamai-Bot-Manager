//
//  RSACrypt_.m
//  nike
//
//  Created by niu_o0 on 2019/4/15.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "RSACrypt_.h"
#import <objc/message.h>

static NSString * const CYFAkamaiBMPErrorDomain = @"com.akamai.bmp";

@implementation RSACrypt_

+ (id)encryptString:(id)arg1 publicKey:(id)arg2 error:(__autoreleasing id *)arg3{
    
    return [self encryptData:[arg1 dataUsingEncoding:4] publicKey:arg2 error:arg3];
    
}

+ (id)encryptData:(id)arg1 publicKey:(id)arg2 error:(__autoreleasing id *)arg3{
    
    return objc_msgSend(NSClassFromString(@"RSACrypt"), @selector(encryptData: publicKey: error:), arg1, arg2, arg3);
    
    if (arg1 && arg2) {
        
        struct __SecKey * key = [RSACrypt_ addPublicKey:arg2 error:arg3];
        
        if (key) {
            
           return [RSACrypt_ encryptData:arg1 withKeyRef:key isSign:false error:arg3];
            
        }
        
    }else{
        
        return [[NSError alloc] initWithDomain:CYFAkamaiBMPErrorDomain code:1131 userInfo:nil];
        
    }
    
    return nil;
}

@end
