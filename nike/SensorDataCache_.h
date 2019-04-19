//
//  SensorDataCache_.h
//  nike
//
//  Created by niu_o0 on 2019/4/11.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorDataCache_ : NSObject

+ (instancetype)sharedInstance;
@property(retain, nonatomic) NSString *sensorData; // @synthesize sensorData=_sensorData;
- (void)saveData;
- (void)loadData;
- (void)initializeCache;
- (void)set:(id)arg1;
- (id)get;
- (_Bool)isValid;
- (id)initPrivate;
- (id)init;

@end

NS_ASSUME_NONNULL_END
