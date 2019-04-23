//
//  CYFManager_.m
//  nike
//
//  Created by niu_o0 on 2019/4/11.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFManager_.h"
#import "SensorDataCache_.h"
#import "SecureSensorData_.h"
#import "CYFUtilities_.h"
#import "CYFTouchEventManager_.h"
#import "CYFTextEventManager_.h"
#import "CYFMotionManager_.h"
#import "CYFKeyBoardEventManager_.h"
#import "CYFBackgroundEventManager_.h"
#import "CYFGlobalManager_.h"
#include <stdio.h>
#include <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import "FeistelCipher_.h"
#import "CYFSensorDataSnapshot_.h"
#import "NSDate+CYFExtra_.h"

@implementation CYFManager_

+ (instancetype)sharedManager {
    
    static id manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initPrivate];
        [SecureSensorData_ sharedInstance];
        [SensorDataCache_ sharedInstance];
    });
    
    return manager;
}

- (id)initPrivate{
    
    if (self == [super init]) {
        self.devicePerformance = DEFAULT_PERFORMANCE_VALUE;
        self.eventManagersInitialized = false;
        
    }
    
    return self;
}

- (void)initialSetUp{
    [self configureResetNotifications];
    [self configure];
    [self configureForTestMode];
}

- (void)configureResetNotifications{
    [self removeResetObservers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(motionEventNotAvailable:) name:@"motioneventnotavailablenotification" object:nil];
}

- (void)removeResetObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"motioneventnotavailablenotification" object:nil];
}

- (void)motionEventNotAvailable:(id)arg1{
    self.eventMask = @"do_dis,dm_dis,t_en";
    [self removeResetObservers];
}

- (void)configure{
    
    [self setEventMask:@"do_en,dm_en,t_en"];
    self.exceptionInfo = nil;
    self.sensorDataSnapshot = nil;
    self.sensorDataSnapshot = [[CYFSensorDataSnapshot_ alloc] init];
    self.autoPostIndex = 0;
    self.totalDataTransmitted = 0;
    self.lastAutoPostTime = nil;
    
    [[CYFGlobalManager_ sharedGlobalManager] resetStartingDate];
    
    if (!self.touchManager) {
        
        self.touchManager = [[CYFTouchEventManager_ alloc] init];
        
    }
    
    if (!self.keyboardManager) {
        self.keyboardManager = [[CYFKeyBoardEventManager_ alloc] init];
    }
    
    if (!self.textManager) {
        self.textManager = [[CYFTextEventManager_ alloc] init];
    }
    
    if (!self.motionManager){
        self.motionManager = [[CYFMotionManager_ alloc] init];
        [self.motionManager startMotionEventTracking];
    }
    
    if (!self.backgroundManager){
        self.backgroundManager = [CYFBackgroundEventManager_ sharedBackgroundEventManager];
    }
    
    self.eventManagersInitialized = true;
    
}

- (id)getSensorData{
    
    NSString * data = [self collectSensorData:-1];
    
    [CYFUtilities_ dispatchOnMainThread:^{
        
        [self performSelector:@selector(startOver) withObject:nil afterDelay:0.001];
        
    } synchronously:false];
    
    return data;
}

- (id)collectSensorData:(long long)arg1{
    
    __block NSString * data = nil;
    
    [CYFUtilities_ dispatchOnMainThread:^{
        
        data = [self buildSensorData:arg1];
        
    } synchronously:true];
    
    return data;
}

- (id)buildSensorData:(long long)arg1{
    
    if (self.eventManagersInitialized) {
        
        CFTimeInterval time = CACurrentMediaTime();
        
        NSString * v196;
        if (self.touchManager) {
            v196 = [self.touchManager getSensorData];
        }
        
        NSString * v195;
        NSString * v195_4;
        if (self.textManager) {
            v195_4 = [self.textManager getTextEventSensorData];
            v195 = [self.textManager getTextFormFieldSensorData];
        }
        
        
        NSDictionary * dic = [self.motionManager getMotionSensorData];
        NSString * sensorData = [dic objectForKey:@"sensorData"]; //v34
        NSNumber * vel = [dic objectForKey:@"velocity"]; //v205
        NSNumber * count = [dic objectForKey:@"totalCount"];//v208
        
        
        dic = [self.motionManager getOrientationSensorData];
        NSString * m_sensorData = [dic objectForKey:@"sensorData"];//v41
        NSNumber * m_vel = [dic objectForKey:@"velocity"];//v204
        NSNumber * m_count = [dic objectForKey:@"totalCount"];//v207
        
        if ([count intValue] <= 9 &&
            [m_count intValue] <= 9 &&
            [SensorDataCache_ sharedInstance].isValid){
            
            NSString * string = [[SensorDataCache_ sharedInstance] get];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getSensorData];
            });
            
            return string;
            
        }else{
            
            if (self.backgroundManager) {
                [self.backgroundManager getBackgroundEventData];
            }
            
            NSString * ds = [[CYFGlobalManager_ sharedGlobalManager] getDeviceInfoString];
            long long dsi = [CYFUtilities_ strToInt:ds];
            NSDate * date = [[CYFGlobalManager_ sharedGlobalManager] startingDate];
            NSTimeInterval time = [date timeIntervalSince1970];
            
            long long mill = [self getMilliSecondsFromSeconds:time];
            
            uint32_t arc = arc4random_uniform(-1);
            
            
            
            NSString * v78 = [NSString stringWithFormat:@"%@,%ld,%u,%lld", ds, dsi, arc, mill];
            
            long long v199 = [self.textManager getTextEventVelocity];
            
            long long v198 = [self.touchManager getTouchEventVelocity];
            
            long v206 = [self.textManager getTotalTextEventCount];
            
            long v197 = [self.touchManager getTotalTouchEventCount];
            
            double d_time = [CYFGlobalManager_ sharedGlobalManager].dInfoInitTime;
            
            long long v91 = [self getMicroSecondsFromSeconds:d_time];
            
            long long v188 = [self getMilliSecondsFromSeconds:[[NSDate date] timeIntervalSince1970]];
            
            CACurrentMediaTime();
            
            
           unsigned long long code = [FeistelCipher_ encode:[count unsignedIntegerValue] withKey:[vel intValue] + [m_vel intValue]];
            
            
            NSString * v117 = [NSString stringWithFormat:@"%ld,%ld,%d,%d,%ld,%lld,%ld,%ld,%d,%d,%lld,%lld,-1,%llu,%lld,%@", v199, v198/*sp*/, [m_vel intValue]/*sp+4*/, [vel intValue]/*sp+8*/, 1/*sp+12*/, v188, v206, v197, [m_count intValue], [count intValue], v91, v188, code, mill, @"0"];
            
            
            NSString * string = [NSString stringWithFormat:@"%@-1,2,-94,-100,%@-1,2,-94,-101,%@-1,2,-94,-105,-1,2,-94,-102,%@-1,2,-94,-108,%@-1,2,-94,-110,-1,2,-94,-117,%@-1,2,-94,-111,%@-1,2,-94,-109,%@-1,2,-94,-112,-1,2,-94,-115,%@-1,2,-94,-106,%ld,%ld-1,2,-94,-70,-1,2,-94,-80,-1,2,-94,-120,%@-1,2,-94,-112,%@-1,2,-94,-121,", @"2.1.1", v78, self.eventMask, v195, v195_4, v196, m_sensorData, sensorData, v117, arg1, self.autoPostIndex, self.exceptionInfo, self.devicePerformance];
            
            string = [[SecureSensorData_ sharedInstance] build:string error:nil];
            
            [[SensorDataCache_ sharedInstance] set:string];
            
            return string;
        }
        
    }else{
        return @"default-mobile";
    }
    
}

- (long long)getMilliSecondsFromSeconds:(double)arg1 {
    return (long long)arg1*1000.0;
}

- (long long)getMicroSecondsFromSeconds:(double)arg1{
    return (long long)arg1*1000000.0;
}

- (void)startOver{
    
    if (self.eventManagersInitialized) {
        
        [self resetAllEventManagers];
        
        [self configure];
        
        [self.touchManager enableTouchEventManager];
        
    }
    
}

- (void)resetAllEventManagers{
    
    [self.touchManager disableTouchEventManager];
    
    [self.backgroundManager resetBackgroundData];
    
    [[CYFGlobalManager_ sharedGlobalManager] resetStartingDate];
    
    self.keyboardManager = nil;
    self.textManager = nil;
    [self.motionManager resetTimer];
    self.motionManager = nil;
    self.eventManagersInitialized = false;
    
}

- (void)startCollectingTouchEventsOnWindow:(id)arg1 withType:(unsigned long long)arg2 {
    [self.touchManager startCollectingTouchEventsOnWindow:arg1 withType:arg2];
}

- (void)stopCollectingTouchEventsOnWindow:(id)arg1 {
    [self.touchManager stopCollectingTouchEventsOnWindow:arg1];
}

#pragma mark - auto

- (void)executeAutoPost:(id)arg1 {
    
}

- (void)collectMotionDataOnTouch{
    
    [self.motionManager collectMotionDataOnTouch];
    
}

- (void)configureForTestMode {
    
    if ([CYFGlobalManager_ sharedGlobalManager].isTestModeOn) {
        
        [self addObserversForAutoPost];
        
        [[CYFGlobalManager_ sharedGlobalManager] addObserver:self forKeyPath:@"testMode" options:1 context:nil];
        
    }
    
}

- (void)configureAutoPost:(id)arg1 {
    
    if ([CYFGlobalManager_ sharedGlobalManager].isTestModeOn) {
        
        [CYFGlobalManager_ sharedGlobalManager].sessionId = arg1;
        
        if (!arg1 || [[CYFGlobalManager_ sharedGlobalManager].sessionId caseInsensitiveCompare:arg1]) {
            
            [CYFGlobalManager_ sharedGlobalManager].enableFrontEndPost = true;
            
            [self startOver];
            
        }
        
    }else {
        [CYFGlobalManager_ sharedGlobalManager].sessionId = nil;
        [CYFGlobalManager_ sharedGlobalManager].enableFrontEndPost = false;
    }
    
}

- (bool)shouldAutoPostWithInfo:(NSDictionary *)arg1 {
    
    if (arg1) {
        
        NSInteger type = [[arg1 objectForKey:@"autoposttype"] integerValue];
        if (type) {
            
            NSInteger v10 = [[arg1 objectForKey:@"totaleventcount"] integerValue];
            
            
            switch (type) {
                case 1:
                case 4:
                    return true;
                case 2:
                    if (v10 % 0xA == 5) return true;
                    return false;
                case 3:
                    if (v10 % 0xA != 1) return false;
                    return v10 % 0xA;
                default:
                    return false;
            }
        }else{
            return true;
        }
        
    }else{
        return false;
    }
    
}

- (void)autoPostSensorData:(long long)arg1 {
    
    id v21 = nil;
    
    if (self.moreThen30MinSinceLastAutoPost) {
        
        if ([CYFGlobalManager_ sharedGlobalManager].isTestModeOn) {
            
            NSString * idx = [[NSNumber numberWithUnsignedInteger:self.autoPostIndex] stringValue];
            
            NSDictionary * dic = @{@"ReStarting" : @"status", idx : @"index", [NSDate date] : @"time"};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CYFAUTOPOSTRESPONSERECEIVED" object:dic];
        }
        
        v21 = [self collectSensorData:arg1];
        [self startOver];
    }
    
    if (self.autoPostIndex <= 4) {
        
        if (self.totalDataTransmitted <= [CYFGlobalManager_ sharedGlobalManager].autoPostMaxTransmissionLimit) {
            
            if (self.lastAutoPostTime) {
                
                long t = [[NSDate date] timeIntervalSinceDateInMilliSeconds:self.lastAutoPostTime];
                
                if (t < 5.0) return;
                
            }
            
            if (!v21) {
                v21 = [self collectSensorData:arg1];
            }
            
            if (self.totalDataTransmitted + [v21 length] <= [CYFGlobalManager_ sharedGlobalManager].autoPostMaxTransmissionLimit) {
                [self makePostCallWithSensorData:v21];
            }else{
                self.totalDataTransmitted = [CYFGlobalManager_ sharedGlobalManager].autoPostMaxTransmissionLimit + 1;
            }
            
        }
        
    }
    
}

- (bool)moreThen30MinSinceLastAutoPost {
    
    if (!self.lastAutoPostTime) return false;
    
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:self.lastAutoPostTime];
    
    return (t > [CYFGlobalManager_ sharedGlobalManager].autoPostWakeUpTime);
}

@end
