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
    
    return [self encryptData:[arg1 dataUsingEncoding:NSUTF8StringEncoding] publicKey:arg2 error:arg3];
    
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

+ (struct __SecKey *)addPublicKey:(NSString *)arg1 error:(__autoreleasing id *)arg2 {
    
    if (arg1) {
        
        NSRange br = [arg1 rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
        NSRange er = [arg1 rangeOfString:@"-----END PUBLIC KEY-----"];
        
        if (br.length != NSNotFound && er.length != NSNotFound) {
            
            arg1 = [arg1 substringWithRange:NSMakeRange(br.length, er.location-br.length)];
            
        }
    }
    
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    arg1 = [arg1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSData * data = [[NSData alloc] initWithBase64EncodedString:arg1 options:1];
    
    NSData * v21 = [self stripPublicKeyHeader:data error:arg2];
    
    if (v21) {
        
        
        NSString *tag = @"RSAUtil_PubKey";
        NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
        
        NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
        [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
        [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
        [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
        SecItemDelete((__bridge CFDictionaryRef)publicKey);
        
        
        [publicKey setObject:v21 forKey:(__bridge id)kSecValueData];
        [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
         kSecAttrKeyClass];
        [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
         kSecReturnPersistentRef];
        
        CFTypeRef persistKey = nil;
        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
        if (persistKey != nil){
            CFRelease(persistKey);
        }
        
        if (status == errSecDuplicateItem || status == errSecSuccess) {
            
            SecKeyRef publicKeyReference = NULL;
            
            [publicKey removeObjectForKey:(__bridge id)kSecValueData];
            [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
            [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
            [publicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
            
            if (SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&publicKeyReference)) {
                
                *arg2 = [NSError errorWithDomain:CYFAkamaiBMPErrorDomain code:1113 userInfo:nil];
                
            }else{
                
                return  publicKeyReference;
            }
            
        }else{
            
            NSError * e = [[NSError alloc] initWithDomain:@"NSSecurityDomain" code:status userInfo:nil];
            
            * arg2 = [NSError errorWithDomain:CYFAkamaiBMPErrorDomain code:1111 userInfo:@{e : @"NSUnderlyingErrorKey"}];
            
        }
    }
    
    return NULL;
}

+ (id)encryptData:(NSData *)arg1 withKeyRef:(struct __SecKey *)arg2 isSign:(bool)arg3 error:(__autoreleasing id *)arg4 {
    
    
    const uint8_t *srcbuf = (const uint8_t *)[arg1 bytes];
    size_t srclen = (size_t)arg1.length;
    size_t block_size = SecKeyGetBlockSize(arg2) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(arg2,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    free(outbuf);
    CFRelease(arg2);
    return ret;
    
    
    
    size_t v11 = SecKeyGetBlockSize(arg2);
    
    void * v12 = malloc(v11);
    
    NSMutableData * data = [[NSMutableData alloc] init];
    
    uint v17 = arg1.length;
    
    if (v17) {
        
        OSStatus status;
        
        uint v15 = 0;
        
        uint v14 = v11 - 0xB;
        
        while (1) {
            
            
            
            if (arg1.length > v14) v17 = v14;
            
            
            
            if (arg3) {
                
                status = SecKeyRawSign(arg2, 1, &arg1.bytes[v15], v17, v12, &v11);
                
            }else{
                
                status = SecKeyEncrypt(arg2, 1, &arg1.bytes[v15], v17, v12, &v11);
                
            }
            
            if (status) break;
            
            [data appendBytes:v12 length:v11];
            
            v15 += v14;
            v17 -= v14;
            
            if (arg1.length <= v15) return data;
            
        }
        
        NSError * e = [[NSError alloc] initWithDomain:@"NSSecurityDomain" code:status userInfo:nil];
        
        * arg4 = [NSError errorWithDomain:CYFAkamaiBMPErrorDomain code:1111 userInfo:@{e : @"NSUnderlyingErrorKey"}];
        
    }
    
    return data;
}

+ (id)stripPublicKeyHeader:(NSData *)arg1 error:(__autoreleasing id *)arg2 {
    
    if (arg1) {
        
        NSData * h = [self convertHexStrToData:@"300D06092A864886F70D0101010500"];
        
        NSUInteger l = arg1.length;
        
        if (l) {
            
            const void * bytes = arg1.bytes;
            
            if (BYTEn(*bytes, 0) == 0x30) {
                
                int v11 = 2;
                
                if (BYTEn(*bytes, 1) > 0x80) {
                    v11 = BYTE1(*bytes) - 0x7E;
                }
                
                NSUInteger v12 = &BYTEn(*bytes, v11);
                
                if (!memcmp((char *)v12, h.bytes, 0xF)) {
                    
                    if (*(_BYTE *)(v12+0xF) == 0x3) {
                        
                        uint v23 = *(_BYTE *)(v12 + 0x10);
                        
                        if ( v23 >= 0x81 )
                            v23 = v23 + v11 - 0x6F;
                        else
                            v23 = v11 + 0x11;
                        
                        if (!BYTEn(*bytes, v23)) {
                            return [NSData dataWithBytes:&BYTEn(*bytes, v23+1) length:l-v23-1];
                        }
                        
                        *arg2 = [[NSError alloc] initWithDomain:CYFAkamaiBMPErrorDomain code:1106 userInfo:nil];
                        
                    }else{
                        *arg2 = [[NSError alloc] initWithDomain:CYFAkamaiBMPErrorDomain code:1105 userInfo:nil];
                    }
                    
                }else{
                    *arg2 = [[NSError alloc] initWithDomain:CYFAkamaiBMPErrorDomain code:1104 userInfo:nil];
                }
                
            }else{
                *arg2 = [[NSError alloc] initWithDomain:CYFAkamaiBMPErrorDomain code:1103 userInfo:nil];
            }
            
        }else{
            *arg2 = [[NSError alloc] initWithDomain:CYFAkamaiBMPErrorDomain code:1102 userInfo:nil];
        }
        
    }else{
        *arg2 = [[NSError alloc] initWithDomain:CYFAkamaiBMPErrorDomain code:1101 userInfo:nil];
    }
    
    return nil;
}

// 16进制转NSData
+ (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end
