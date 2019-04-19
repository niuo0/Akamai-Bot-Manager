//
//  FeistelCipher_.m
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "FeistelCipher_.h"

@implementation FeistelCipher_

+ (unsigned long long)encode:(unsigned long long)arg1 withKey:(unsigned int)arg2 {
    
    int v11 = 0;
    int v12 = 32;
    
    uint64_t v5 = arg1;
    
    do {
        
        v5 ^=  v5 ^ ((arg2 << v11) | (arg2 >> v12));
        
        
        ++ v11;
        -- v12;
        
    } while (v11 != 16);
    
    return v5;
}

+ (unsigned long long)decode:(unsigned long long)arg1 withKey:(unsigned int)arg2 {
    
    uint64_t result;
    signed int v5 = 17;
    
    HIDWORD(result) = 16;
    
    do {
        
        -- HIDWORD(result);
        LODWORD(result) = HIDWORD(arg1);
        uint v6 = arg2 >> v5++;
        HIDWORD(arg1) ^= ((arg2 << SBYTE4(result)) | v6) ^ arg1;
        LODWORD(arg1) = result;
        
    } while (SHIDWORD(result) > 0);
    
    HIDWORD(result) = HIDWORD(arg1);
    
    return result;
    
}

@end
