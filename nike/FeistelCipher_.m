//
//  FeistelCipher_.m
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "FeistelCipher_.h"
#import <QuartzCore/QuartzCore.h>

@implementation FeistelCipher_

+ (unsigned long long)encode:(unsigned long long)arg1 withKey:(unsigned int)arg2 {
    
    int v11 = 0;
    int v12 = 32;
    uint64_t v5;
    uint v13;
    
    int v4 = HIDWORD(arg1);
    
    LODWORD(v5) = arg1;
    
    do
    {
        HIDWORD(v5) = v5;
        v13 = (arg2 << v11) | (arg2 >> v12);
        ++v11;
        LODWORD(v5) = v5 ^ v4 ^ v13;
        --v12;
        v4 = HIDWORD(v5);
    }
    while ( v11 != 16 );
    
    return v5;
}

+ (unsigned long long)decode:(unsigned long long)arg1 withKey:(unsigned int)arg2 {
    
    uint64_t result; // r0@1
    signed int v5; // r12@1
    unsigned int v6; // lr@2
    
    HIDWORD(result) = 16;
    v5 = 17;
    do
    {
        --HIDWORD(result);
        LODWORD(result) = HIDWORD(arg1);
        v6 = arg2 >> v5++;
        HIDWORD(arg1) ^= ((arg2 << SBYTE4(result)) | v6) ^ arg1;
        LODWORD(arg1) = result;
    }
    while ( SHIDWORD(result) > 0 );
    HIDWORD(result) = HIDWORD(arg1);
    return result;
    
}

@end
