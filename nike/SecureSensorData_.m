//
//  SecureSensorData_.m
//  nike
//
//  Created by niu_o0 on 2019/4/11.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "SecureSensorData_.h"
#import <Security/Security.h>
#import "RSACrypt_.h"
#import <QuartzCore/QuartzCore.h>


@implementation SecureSensorData_

+ (instancetype)sharedInstance {
    
    static SecureSensorData_ * data = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[self alloc] initPrivate];
        
        data.keysInitialized = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [data initializeKeys];
        });
        
    });
    
    return data;
}

- (void)initializeKeys{
    
    if (!self.keysInitialized) {
        
        self.aesKey = [self randomDataOfLength:16];
        
        self.aesIV = [self randomDataOfLength:16];
        
        self.hmacKey = [self randomDataOfLength:32];
        
        id aes = [RSACrypt_ encryptData:self.aesKey publicKey:BeginPublicKey error:nil];//var_5c
        
        id hma = [RSACrypt_ encryptData:self.hmacKey publicKey:BeginPublicKey error:nil];//var_64
        
        if (aes && hma) {
            
            self.b64AesKey = [aes base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            
            self.b64HmacKey = [hma base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            
        }
        
        if (self.b64AesKey) {
            
            if (self.b64HmacKey) {
                
                self.keysInitialized = true;
                
                return;
            }
            
        }
        
        self.b64AesKey = aesKey;
        self.b64HmacKey = hmacKey;
        self.keysInitialized = true;
    }
    
}

- (id)randomDataOfLength:(unsigned long long)arg1{
    
    NSMutableData * data = [NSMutableData dataWithLength:arg1];
    
    SecRandomCopyBytes(kSecRandomDefault, arg1, [data mutableBytes]);
    
    return data;
}

- (id)initPrivate{
    
    if (self = [super init]) {
        
    }
    return self;
}

- (id)build:(id)arg1 error:(__autoreleasing id *)arg2 {
    
    if (!self.keysInitialized) [self initializeKeys];
    
    CFTimeInterval crypt_start = CACurrentMediaTime();
    
    if (!self.b64AesKey) {
        self.b64AesKey = aesKey;
    }
    
    if (!self.b64HmacKey) {
        self.b64HmacKey = hmacKey;
    }
    
    if (!self.aesKey) {
        //self.aesKey = [NSData dataWithBytes:<#(nullable const void *)#> length:16]
    }
    
    if (!self.hmacKey) {
        //self.hmacKey = [NSData dataWithBytes:<#(nullable const void *)#> length:32];
    }
    
    
    if  (!self.aesIV) {
        self.aesIV = [self randomDataOfLength:16];
    }
    
    NSData * data = [arg1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData * m_data = [NSMutableData dataWithLength:data.length + 16];
    
    size_t dataOut;
    CCCryptorStatus status = CCCrypt(0, 0, 1, self.aesKey.bytes, self.aesKey.length, self.aesIV.bytes, data.bytes, data.length, m_data.mutableBytes, m_data.length, &dataOut);
    
    if  (status != kCCSuccess) {
        NSLog(@"Failed to encrypt sensor data");
    }else{
        m_data.length = dataOut;
        
        CFTimeInterval crypt_end = CACurrentMediaTime();
        
        NSMutableData * v64 = [[NSMutableData alloc] initWithCapacity:self.aesIV.length+m_data.length];
        
        [v64 appendData:self.aesIV];
        [v64 appendData:m_data];
        
        NSMutableData * v68 = [NSMutableData dataWithLength:32];
        
        CCHmac(2, self.hmacKey.bytes, self.hmacKey.length, v64.bytes, v64.length, v68.mutableBytes);
        
        NSMutableData * v91 = [[NSMutableData alloc] initWithCapacity:v64.length+32];
        [v91 appendData:v64];
        [v91 appendData:v68];
        
        CFTimeInterval time_start = CACurrentMediaTime();
        
        NSString * v95 = [v91 base64EncodedStringWithOptions:32];
        
        CFTimeInterval time_end = CACurrentMediaTime();
        
        NSString * v106 = [NSString stringWithFormat:@"%@,i,%@,%@", @"1", self.b64AesKey, self.b64HmacKey];
        
        NSString * v122 = [NSString stringWithFormat:@"%lld,%lld,%lld", (time_end - time_start)*1000000.0, (crypt_end - crypt_start)*1000000.0, (time_end - crypt_start)*1000000.0];
        
        return [NSString stringWithFormat:@"%@$%@$%@", v106, v95, v122];
        
    }
    
    return nil;
}

@end
