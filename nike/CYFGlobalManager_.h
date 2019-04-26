//
//  CYFGlobalManager.h
//  nike
//
//  Created by niu_o0 on 2019/4/10.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *(^buildingBlock)(void);

typedef void(^assignmentBlock)(NSString *, CFTimeInterval);

@interface CYFGlobalManager_ : NSObject

+ (instancetype)sharedGlobalManager;
@property(nonatomic) _Bool isDeviceInfoCalculated; // @synthesize isDeviceInfoCalculated=_isDeviceInfoCalculated;
@property(retain, nonatomic) NSString *deviceInfo; // @synthesize deviceInfo=_deviceInfo;
@property(retain, nonatomic) NSDate *startDate; // @synthesize startDate=_startDate;
@property(nonatomic, getter=isTestModeOn) _Bool testMode; // @synthesize testMode=_testMode;
@property(nonatomic) unsigned long long autoPostMaxTransmissionLimit; // @synthesize autoPostMaxTransmissionLimit=_autoPostMaxTransmissionLimit;
@property(nonatomic) double autoPostWakeUpTime; // @synthesize autoPostWakeUpTime=_autoPostWakeUpTime;
@property(nonatomic, assign) NSTimeInterval dInfoInitTime; // @synthesize dInfoInitTime=_dInfoInitTime;
@property(retain, nonatomic) NSString *sensorDataFieldName; // @synthesize sensorDataFieldName=_sensorDataFieldName;
@property(retain, nonatomic) NSString *apiUrl; // @synthesize apiUrl=_apiUrl;
@property(getter=isFrontEndPostEnabled) _Bool enableFrontEndPost; // @synthesize enableFrontEndPost=_enableFrontEndPost;
@property(retain, nonatomic) NSString *sessionId; // @synthesize sessionId=_sessionId;


- (id)isDeviceJailBroken;
- (id)fetchIdentifierForTheVendor;
- (id)getAppIdentifier;
- (id)getDeviceHardwareType;
- (id)getCurrentLanguage;
- (id)getBatteryInfo;
- (long long)getCurrentStatusBarOrientation;
- (struct CGSize)getCurrentScreenSize;
- (id)getDeviceInfoString;
- (assignmentBlock)deviceInfoAssignmentBlock;
- (buildingBlock)deviceInfoBuildingBlock;
- (void)buildDeviceInfo:(_Bool)arg1;
- (void)resetStartingDate;
- (id)startingDate;
- (id)initPrivate;
- (id)init;

@end

NS_ASSUME_NONNULL_END
