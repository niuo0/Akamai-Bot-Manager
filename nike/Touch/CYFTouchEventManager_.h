//
//  CYFTouchEventManager_.h
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYFTouchEventRecognizerDelegate-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYFTouchEventManager_ : NSObject <CYFTouchEventRecognizerDelegate_>

@property(retain, nonatomic) NSDate *lastEventTime; // @synthesize lastEventTime=_lastEventTime;
@property(nonatomic) long long touchEventDataVelocity; // @synthesize touchEventDataVelocity=_touchEventDataVelocity;
@property(retain, nonatomic) NSString *touchEventDataString; // @synthesize touchEventDataString=_touchEventDataString;
@property(retain, nonatomic) NSMutableDictionary *formatters; // @synthesize formatters=_formatters;
@property(retain, nonatomic) NSMutableArray *touchEventRecognizers; // @synthesize touchEventRecognizers=_touchEventRecognizers;


- (long long)getTouchUpDownEventCount;
- (long long)getTouchMoveEventCount;
- (long long)getTotalTouchEventCount;
- (long long)getTouchEventVelocity;
- (id)getSensorData;
- (void)enableTouchEventManager;
- (void)disableTouchEventManager;
- (void)stopCollectingTouchEventsOnWindow:(id)arg1;
- (void)startCollectingTouchEventsOnWindow:(id)arg1 withType:(unsigned long long)arg2;
- (id)fetchTouchDataFormatterForType:(unsigned long long)arg1;
- (void)createTouchDataFormatters;
- (id)getAlreadyAttachedGestureForWindow:(id)arg1;
- (void)configure;
- (void)applicationBecomeActive:(id)arg1;

@end

NS_ASSUME_NONNULL_END
