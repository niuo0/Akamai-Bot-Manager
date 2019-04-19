//
//  CYFManager_.h
//  nike
//
//  Created by niu_o0 on 2019/4/11.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CYFBackgroundEventManager_, CYFKeyBoardEventManager_, CYFMotionManager_, CYFSensorDataSnapshot_, CYFTextEventManager_, CYFTouchEventManager_, NSDate, NSString;

@interface CYFManager_ : NSObject

+ (instancetype)sharedManager;

@property(retain, nonatomic) NSString *devicePerformance; // @synthesize devicePerformance=_devicePerformance;
@property(retain, nonatomic) NSString *exceptionInfo; // @synthesize exceptionInfo=_exceptionInfo;
@property(retain, nonatomic) NSString *eventMask; // @synthesize eventMask=_eventMask;
@property(retain, nonatomic) CYFBackgroundEventManager_ *backgroundManager; // @synthesize backgroundManager=_backgroundManager;
@property(retain, nonatomic) CYFSensorDataSnapshot_ *sensorDataSnapshot; // @synthesize sensorDataSnapshot=_sensorDataSnapshot;
@property(retain, nonatomic) CYFMotionManager_ *motionManager; // @synthesize motionManager=_motionManager;
@property(retain, nonatomic) CYFTextEventManager_ *textManager; // @synthesize textManager=_textManager;
@property(retain, nonatomic) CYFKeyBoardEventManager_ *keyboardManager; // @synthesize keyboardManager=_keyboardManager;
@property(retain, nonatomic) CYFTouchEventManager_ *touchManager; // @synthesize touchManager=_touchManager;
@property(retain, nonatomic) NSDate *lastAutoPostTime; // @synthesize lastAutoPostTime=_lastAutoPostTime;
@property(nonatomic) unsigned long long totalDataTransmitted; // @synthesize totalDataTransmitted=_totalDataTransmitted;
@property(nonatomic) unsigned long long autoPostIndex; // @synthesize autoPostIndex=_autoPostIndex;
@property(nonatomic) _Bool eventManagersInitialized; // @synthesize eventManagersInitialized=_eventManagersInitialized;

- (id)collectTestData;
- (void)resetAllEventManagers;
- (void)startOver;
- (id)base64Encode:(id)arg1;
- (id)AES128Operation:(id)arg1 dataString:(id)arg2;
- (long long)getMicroSecondsFromSeconds:(double)arg1;
- (long long)getMilliSecondsFromSeconds:(double)arg1;
- (id)buildSensorData:(long long)arg1;
- (id)collectSensorData:(long long)arg1;
- (id)updateExceptionInfoInSensorData:(id)arg1;
- (void)logExceptionInfo:(id)arg1;
- (void)collectMotionDataOnTouch;
- (void)stopCollectingTouchEventsOnWindow:(id)arg1;
- (void)startCollectingTouchEventsOnWindow:(id)arg1 withType:(unsigned long long)arg2;
- (id)getSensorData;
- (void)enableTest:(_Bool)arg1;
- (void)setAutoPostDataTransmissionLimit:(unsigned long long)arg1;
- (void)setAutoPostWakeUpTime:(double)arg1;
- (void)setAutoPost:(_Bool)arg1;
- (void)setApiUrl:(id)arg1;
- (void)setApiKey:(id)arg1;
- (void)setSensorDataFieldNames:(id)arg1;
- (void)setSessionId:(id)arg1;
- (void)startCollectingTouchEventsOnWindow:(id)arg1;
- (void)configure;
- (void)dealloc;
- (void)initialSetUp;
- (id)initPrivate;
- (id)init;
- (void)motionEventNotAvailable:(id)arg1;
- (void)removeResetObservers;
- (void)configureResetNotifications;
- (void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void *)arg4;
- (void)removeObserversForAutoPost;
- (void)addObserversForAutoPost;
- (_Bool)postWithRequest:(id)arg1 andCompletionBlock:(id)arg2;
- (id)setUpBasicPostRequestWithSensorData:(id)arg1;
- (_Bool)makePostCallWithSensorData:(id)arg1;
- (_Bool)moreThen30MinSinceLastAutoPost;
- (void)autoPostSensorData:(long long)arg1;
- (void)executeAutoPost:(id)arg1;
- (_Bool)shouldAutoPostWithInfo:(id)arg1;
- (void)configureAutoPost:(id)arg1;
- (void)configureForTestMode;

@end

NS_ASSUME_NONNULL_END
