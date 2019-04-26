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
    
    CFTimeInterval crypt_start = CACurrentMediaTime();
    
    size_t dataOut;
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, self.aesKey.bytes, self.aesKey.length, self.aesIV.bytes, data.bytes, data.length, m_data.mutableBytes, m_data.length, &dataOut);
    
    if  (status != kCCSuccess) {
        NSLog(@"Failed to encrypt sensor data");
    }else{
        m_data.length = dataOut;
        
        CFTimeInterval crypt_end = CACurrentMediaTime();
        
        NSMutableData * v64 = [[NSMutableData alloc] initWithCapacity:self.aesIV.length+m_data.length];
        
        [v64 appendData:self.aesIV];
        [v64 appendData:m_data];
        
        NSMutableData * v68 = [NSMutableData dataWithLength:32];
        
        CFTimeInterval hmac_start = CACurrentMediaTime();
        
        CCHmac(kCCHmacAlgSHA256, self.hmacKey.bytes, self.hmacKey.length, v64.bytes, v64.length, v68.mutableBytes);
        
        CFTimeInterval hmac_end = CACurrentMediaTime();
        
        NSMutableData * v91 = [[NSMutableData alloc] initWithCapacity:v64.length+32];
        [v91 appendData:v64];
        [v91 appendData:v68];
        
        CFTimeInterval base64_start = CACurrentMediaTime();
        
        NSString * v95 = [v91 base64EncodedStringWithOptions:32];
        
        CFTimeInterval base64_end = CACurrentMediaTime();
        
        NSString * v106 = [NSString stringWithFormat:@"%@,i,%@,%@", @"1", self.b64AesKey, self.b64HmacKey];
        
        int64_t v119 = floor((crypt_end - crypt_start)*1000000.0);
        
        int64_t v109 = floor((hmac_end - hmac_start)*1000000.0);
        
        int64_t v115 = floor((base64_end - base64_start)*1000000.0);
        
        NSString * v122 = [NSString stringWithFormat:@"%lld,%lld,%lld", v119, v109, v115];
        
        [self unBuild:[NSString stringWithFormat:@"%@$%@", v106, v95]];
        
        return [NSString stringWithFormat:@"%@$%@$%@", v106, v95, v122];
        
    }
    
    return nil;
}

- (void)unBuild:(NSString *)arg1 {
    
    NSArray * arr = [arg1 componentsSeparatedByString:@"$"];
    
    NSString * v106 = arr[0];
    NSString * v95 = arr[1];
    
    NSData * d = [[NSData alloc] initWithBase64EncodedString:v95 options:0];
    
    //d 后32字节为摘要信息
    NSData * v64 = [d subdataWithRange:NSMakeRange(0, d.length-32)];
    
    NSData * aesIV = [d subdataWithRange:NSMakeRange(0, 16)];
    
    NSData * m_data = [v64 subdataWithRange:NSMakeRange(16, v64.length-16)];
    
    unsigned char buffer[m_data.length];
    memset(buffer, 0,sizeof(char));
    
    size_t dataOut;
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, self.aesKey.bytes, self.aesKey.length, aesIV.bytes, m_data.bytes, m_data.length, buffer, m_data.length, &dataOut);
    
    if  (status != kCCSuccess) {
        NSLog(@"Failed to encrypt sensor data");
    }else{
        
        NSData * data = [NSData dataWithBytes:buffer length:dataOut];
        NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", string);
        
    }
    
}

@end
