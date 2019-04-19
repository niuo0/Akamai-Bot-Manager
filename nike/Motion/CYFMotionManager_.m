//
//  CYFMotionManager_.m
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFMotionManager_.h"
#import "CYFMotionHandler_.h"
#import "CYFOrientationHandler_.h"
#import <UIKit/UIKit.h>

@implementation CYFMotionManager_

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.motionHandler = [[CYFMotionHandler_ alloc] init];
        self.oriHandler = [[CYFOrientationHandler_ alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self resetMotionManager];
    self.motionHandler = nil;
    self.oriHandler = nil;
}

- (void)startMotionEventTracking{
    
    [self createMotionManager];
    
    if (self.configureMotionEvents) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        
        [self configureTimer];
        
    }else{
        self.motionManager = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"motioneventnotavailablenotification" object:nil userInfo:nil];
    }
    
}

- (void)collectMotionDataOnTouch{
    [self getMotionData:nil];
}

- (id)getMotionSensorData{
    return [self.motionHandler getSensorData];
}

- (long long)getTotalMotionEventCount{
    return [self.motionHandler getTotalEventCount];
}

- (id)getOrientationSensorData{
    return [self.oriHandler getSensorData];
}

- (long long)getTotalOrientationEventCount{
    return [self.oriHandler getTotalEventCount];
}

- (void)applicationBecomeActive:(id)arg1{
    
    if (self.totalEventsCount <= 0xc7) {
        [self configureMotionEvents];
        [self configureTimer];
    }
    
}

- (void)applicationWillResignActive:(id)arg1{
    [self resetDeviceMotionUpdates];
    [self resetTimer];
}

- (void)createMotionManager{
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionHandler create];
    //[self.oriHandler create];
}

- (bool)configureMotionEvents{
    
    if (self.motionManager.isDeviceMotionAvailable) {
        [self.motionManager startDeviceMotionUpdates];
        return true;
    }
    return false;
}

- (void)resetDeviceMotionUpdates{
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)configureTimer{
    
    if (self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(getMotionData:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)resetTimer{
    
    if (self.timer) {
        [self.timer invalidate];
    }
    
    self.timer = nil;
}

- (void)getMotionData:(id)arg1{
    
    if (self.motionManager.isDeviceMotionAvailable) {
        
        if (self.totalEventsCount <= 0xc7) {
            
            bool v12 = false;
            
            if (arg1) v12 = true;
            
            if (self.motionManager.deviceMotion) {
                
                self.totalEventsCount ++;
                
                [self.motionHandler updateData:self.motionManager.deviceMotion timeStamp:[NSDate date] andTrigger:arg1];
                
                [self.oriHandler updateData:self.motionManager.deviceMotion timeStamp:[NSDate date] andTrigger:arg1];
                
                if (self.totalEventsCount >= 0xc8) {
                    [self resetDeviceMotionUpdates];
                    [self resetTimer];
                }
                
            }
            
        }
        
    }
    
}

- (void)resetMotionManager{
    
    [self resetDeviceMotionUpdates];
    [self resetTimer];
    self.motionManager = nil;
    self.totalEventsCount = 0;
    [self.motionHandler reset];
    [self.oriHandler reset];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

@end
