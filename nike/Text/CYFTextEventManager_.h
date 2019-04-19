//
//  CYFTextEventManager_.h
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYFTextEventListener_.h"
#import "CYFTextEventFormatter_.h"
#import "CYFTextFormfieldDataFormatter_.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYFTextEventManager_ : NSObject <CYFTextEventListenerDelegate_>

@property(retain, nonatomic) NSDate *lastEventTime; // @synthesize lastEventTime=_lastEventTime;
@property(retain, nonatomic) NSString *textFormFieldDataString; // @synthesize textFormFieldDataString=_textFormFieldDataString;
@property(nonatomic) long long textEventDataVelocity; // @synthesize textEventDataVelocity=_textEventDataVelocity;
@property(retain, nonatomic) NSString *textEventDataString; // @synthesize textEventDataString=_textEventDataString;
@property(retain, nonatomic) CYFTextFormfieldDataFormatter_ *textFormFieldDataFormatter; // @synthesize textFormFieldDataFormatter=_textFormFieldDataFormatter;
@property(retain, nonatomic) CYFTextEventFormatter_ *textEventDataFormatter; // @synthesize textEventDataFormatter=_textEventDataFormatter;
@property(retain, nonatomic) CYFTextEventListener_ *textEventsListener; // @synthesize textEventsListener=_textEventsListener;

- (long long)getTextChangeEventCount;
- (long long)getTotalTextEventCount;
- (long long)getTextEventVelocity;
- (id)getTextFormFieldSensorData;
- (id)getTextEventSensorData;
- (void)resetTextEventManager;
- (void)configure;

@end

NS_ASSUME_NONNULL_END
