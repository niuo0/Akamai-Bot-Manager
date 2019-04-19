//
//  SecureSensorData_.h
//  nike
//
//  Created by niu_o0 on 2019/4/11.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecureSensorData_ : NSObject

+ (instancetype)sharedInstance;
@property(retain, nonatomic) NSString *keyErrors; // @synthesize keyErrors=_keyErrors;
@property _Bool keysInitialized; // @synthesize keysInitialized=_keysInitialized;
@property(retain, nonatomic) NSString *b64HmacKey; // @synthesize b64HmacKey=_b64HmacKey;
@property(retain, nonatomic) NSString *b64AesKey; // @synthesize b64AesKey=_b64AesKey;
@property(retain, nonatomic) NSData *hmacKey; // @synthesize hmacKey=_hmacKey;
@property(retain, nonatomic) NSData *aesIV; // @synthesize aesIV=_aesIV;
@property(retain, nonatomic) NSData *aesKey; // @synthesize aesKey=_aesKey;

- (id)build:(id)arg1 error:(id *)arg2;
- (id)getErrors;
- (void)initializeKeys;
- (id)randomDataOfLength:(unsigned long long)arg1;
- (void)logError:(id)arg1;
- (id)initPrivate;
- (id)init;

@end

NS_ASSUME_NONNULL_END
