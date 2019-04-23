//
//  SensorDataCache_.m
//  nike
//
//  Created by niu_o0 on 2019/4/11.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "SensorDataCache_.h"

static NSString * const userKey = @"com.akamai.botman.defaults.sensor_data_";

@implementation SensorDataCache_

+ (instancetype)sharedInstance{
    
    static SensorDataCache_ * cache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] initPrivate];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache initializeCache];
        });
    });
    return cache;
}

- (id)initPrivate{
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)initializeCache{
    
    @synchronized (self) {
        [self loadData];
    }
    
}

- (void)loadData{
    
    self.sensorData = [[NSUserDefaults standardUserDefaults] objectForKey:userKey];
    
}

- (void)saveData{
    
    [[NSUserDefaults standardUserDefaults] setObject:self.sensorData forKey:userKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)set:(id)arg1{
    if (arg1 && [arg1 length]) {
        self.sensorData = arg1;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self saveData];
        });
    }
}

- (id)get{
    return self.sensorData;
}

- (bool)isValid{
    return self.sensorData != nil;
}

@end
