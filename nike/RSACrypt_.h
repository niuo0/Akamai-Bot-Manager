//
//  RSACrypt_.h
//  nike
//
//  Created by niu_o0 on 2019/4/15.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * BeginPublicKey = @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4sA7vA7N/t1SRBS8tugM2X4bByl0jaCZLqxPOql+qZ3sP4UFayqJTvXjd7eTjMwg1T70PnmPWyh1hfQr4s12oSVphTKAjPiWmEBvcpnPPMjr5fGgv0w6+KM9DLTxcktThPZAGoVcoyM/cTO/YsAMIxlmTzpXBaxddHRwi8S2NvwIDAQAB-----END PUBLIC KEY-----";

static NSString * aesKey = @"eLkd5zom7j24VR3EVEuYIdGbjl2t1gn95wLlg+pe92IirwIBz/yeUe4SVBX7RD/3v/xRZDo0AuoiGJbHwKpZ5WuYD47NLarwcTyQtn2JaAiea/9o3ItY2bX1e5rzXOyAVwfs1f8NjFbCtGZ1uZ9s4V63AEEKGgD0lfeggl/JhAc=";

static NSString * hmacKey = @"eXBCzpOw6Oj09ZwbxsdBRLClGv3CHRFBwlmrMJQlkFMBVWrJHYdd4sj3rcK0IgEODqZ9XlwsScA6Eml1mLjavkQpuNchEs36Ca04sMC1Jn9JrgeoD5ByQ4SmW1i526i388zZpJjAOTGgkEj8j3AzqMYmiYzS/rr0zloC1yVJp1A=";

@interface RSACrypt_ : NSObject

+ (id)encryptData:(id)arg1 publicKey:(id)arg2 error:(id *)arg3;
+ (id)encryptString:(id)arg1 publicKey:(id)arg2 error:(id *)arg3;
+ (id)encryptData:(id)arg1 withKeyRef:(struct __SecKey *)arg2 isSign:(_Bool)arg3 error:(id *)arg4;
+ (struct __SecKey *)addPublicKey:(id)arg1 error:(id *)arg2;
+ (id)stripPublicKeyHeader:(id)arg1 error:(id *)arg2;

@end

NS_ASSUME_NONNULL_END
