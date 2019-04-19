//
//  CYFSensorDataSnapshot_.m
//  nike
//
//  Created by niu_o0 on 2019/4/15.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFSensorDataSnapshot_.h"

@implementation CYFSensorDataSnapshot_

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSensorData:@"default-mobile-snapshot"];
    }
    return self;
}

- (id)getSensorData {
    return self.sensorData;
}

@end
