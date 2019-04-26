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
        
        static unsigned char _k1[] = {0x7A, 0xC4, 0x52, 0x78, 0x8B, 0x89, 0x0B, 0x73, 0xD8, 0x3D, 0x5C, 0x76, 0x11, 0xAE, 0x1F, 0xF6, 0x66, 0x92, 0x39, 0x7A, 0xBC, 0xDC, 0x8B, 0xFC, 0xDC, 0x57, 0x73, 0xFE, 0xF9, 0x83, 0x25, 0xB7, 0x7E, 0xCE, 0x1A, 0x5C, 0x44, 0x9C, 0xBA, 0x90, 0xDB, 0x7F, 0x9F, 0xC7, 0x90, 0x32, 0xFA, 0xC0, 0x9E, 0x57, 0x8C, 0x76, 0xA7, 0xE6, 0xF0, 0xD8, 0xBB, 0xE6, 0x87, 0xC4, 0x21, 0x5D, 0x0D, 0xF2};
        
        
        self.aesKey = [NSData dataWithBytes:&_k1[0x10] length:16];
    }
    
    if (!self.hmacKey) {
        
        static unsigned char _k2[] = {0x62, 0x5A, 0x44, 0x09, 0x53, 0x7D, 0x75, 0xC1, 0xBE, 0x4F, 0xEA, 0x2C, 0xF5, 0xD7, 0x07, 0x30, 0x26, 0x0F, 0x4B, 0x6B, 0x53, 0xE5, 0x05, 0x35, 0x43, 0x85, 0xEA, 0x37, 0x67, 0x98, 0x87, 0x01, 0x2A, 0xB9, 0x1F, 0xEE, 0xAB, 0x22, 0xFE, 0x69, 0x3F, 0x28, 0xC1, 0x9B, 0xA6, 0x02, 0x6C, 0x53, 0x06, 0x8D, 0x70, 0x91, 0xB8, 0x3C, 0xFF, 0xA9, 0x88, 0x3E, 0x8C, 0x72, 0xE3, 0x28, 0x43, 0x81, 0xD5, 0x96, 0x71, 0x38, 0xA5, 0x04, 0xDB, 0xD4, 0xB8, 0x02, 0xBB, 0x28, 0xCA, 0x7F, 0x1E, 0xFD, 0xAC, 0x08, 0x28, 0xE5, 0x1F, 0xAE, 0x63, 0x84, 0xF4, 0x6F, 0xA2, 0x0B, 0x7D, 0x43, 0x4F, 0x8A, 0xFD, 0x8B, 0x62, 0xC5, 0x47, 0x2C, 0xD5, 0x09, 0x0E, 0xE4, 0x84, 0x36, 0xFB, 0xED, 0xD2, 0x47, 0x02, 0xB1, 0x23, 0x15, 0x58, 0x3F, 0x01, 0xDC, 0x1F, 0xDF, 0xC5, 0x4E, 0x29, 0x37, 0x2A, 0x34};
        
        self.hmacKey = [NSData dataWithBytes:&_k2[0x20] length:32];
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
