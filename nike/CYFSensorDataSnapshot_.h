//
//  CYFSensorDataSnapshot_.h
//  nike
//
//  Created by niu_o0 on 2019/4/15.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYFSensorDataSnapshot_ : NSObject

@property(retain, nonatomic) NSString *sensorData; // @synthesize sensorData=_sensorData;
- (id)getSensorData;

@end

NS_ASSUME_NONNULL_END
