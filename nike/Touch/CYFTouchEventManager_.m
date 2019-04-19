//
//  CYFTouchEventManager_.m
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFTouchEventManager_.h"
#import <UIKit/UIKit.h>
#import "NSValue+CYFTouchEventEnumValues_.h"
#import "CYFKeyWindowTouchEventFormatter_.h"
#import "CYFTouchEventRecognizerFactory_.h"
#import "CYFManager_.h"

@implementation CYFTouchEventManager_

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self configure];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}

- (void)applicationBecomeActive:(id)arg1{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window) {
        
        [self startCollectingTouchEventsOnWindow:window withType:1];
        
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (id)getAlreadyAttachedGestureForWindow:(id)arg1{
    
    NSUInteger index = [self.touchEventRecognizers indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        return [[obj view] isEqual:arg1];
        
    }];
    
    if (index != NSNotFound) {
        
        return  [self.touchEventRecognizers firstObject];
        
    }
    
    return nil;
}

- (void)configure{
    
    self.touchEventDataString = @"";
    self.touchEventDataVelocity = 0;
    self.lastEventTime = [NSDate date];
    [self createTouchDataFormatters];
    
}

- (long long)getTouchEventVelocity{
    return self.touchEventDataVelocity;
}

- (void)enableTouchEventManager{
    
    [self.touchEventRecognizers enumerateObjectsUsingBlock:^(UITapGestureRecognizer *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = YES;
    }];
    
    [self configure];
}

- (void)disableTouchEventManager{
    [self.touchEventRecognizers enumerateObjectsUsingBlock:^(UITapGestureRecognizer *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = NO;
    }];
    
    [self.formatters removeAllObjects];
    self.formatters = nil;
}

- (long long)getTotalTouchEventCount{
    return [CYFTouchEventRecognizer_ getTotalTouchEventCount];
}

- (long long)getTouchMoveEventCount{
    return [CYFTouchEventRecognizer_ getTouchMoveEventCount];
}

- (long long)getTouchUpDownEventCount{
    return [CYFTouchEventRecognizer_ getTouchUpDownEventCount];
}

- (void)createTouchDataFormatters{
    
    NSArray * keys = [NSArray arrayWithObjects:[NSValue valuewithTouchDataFormatterType:0], [NSValue valuewithTouchDataFormatterType:1], [NSValue valuewithTouchDataFormatterType:2], nil];
    
    NSArray * objcs = [NSArray arrayWithObjects:[NSNull null], [CYFKeyWindowTouchEventFormatter_ new], [CYFKeyWindowTouchEventFormatter_ new], nil];
    
    self.formatters = [[NSMutableDictionary alloc] initWithObjects:objcs forKeys:keys];
}

- (id)getSensorData{
    return self.touchEventDataString;
}

- (id)fetchTouchDataFormatterForType:(unsigned long long)arg1{
    
    id v = [NSValue valuewithTouchDataFormatterType:arg1];
    
    return [self.formatters objectForKey:v];
    
}

- (void)startCollectingTouchEventsOnWindow:(id)arg1 withType:(unsigned long long)arg2 {
    
    if (!self.touchEventRecognizers) {
        
        self.touchEventRecognizers = [[NSMutableArray alloc] init];
        
    }
    
    id gesture = [self getAlreadyAttachedGestureForWindow:arg1];
    
    if (!gesture) {
        
        CYFTouchEventRecognizer_ * recognizer = [CYFTouchEventRecognizerFactory_ createTouchEventRecognizerForType:arg2];
        
        if (recognizer) {
            [arg1 addGestureRecognizer:recognizer];
            recognizer.touchRecorder = self;
            [self.touchEventRecognizers addObject:recognizer];
        }
        
        NSDictionary * dic = @{@"autoposttype" : @"0"};
        
        [[CYFManager_ sharedManager] executeAutoPost:dic];
    }
    
}

- (void)stopCollectingTouchEventsOnWindow:(id)arg1{
    
    id g = [self getAlreadyAttachedGestureForWindow:arg1];
    
    if (g) {
        
        [arg1 removeGestureRecognizer:g];
        
        [self.touchEventRecognizers removeObject:g];
    }
    
}

- (void)touchDataRecognizer:(CYFTouchEventRecognizer_ *)arg1 withTouchData:(CYFTouchData_ *)arg2{
    
    if (arg2) {
        
        CYFKeyWindowTouchEventFormatter_ * v47 = [self fetchTouchDataFormatterForType:arg2.formatterType];
        
        if (![v47 isEqual:[NSNull null]]) {
            
            NSDictionary * dic = [v47 formatTouchData:arg2 withLastEventTime:self.lastEventTime];
            
            NSString * string = [dic objectForKey:@"datastring"];
            
            if (string) {
                self.touchEventDataString = [self.touchEventDataString stringByAppendingString:string];
            }
            
            NSNumber * v26 = [dic objectForKey:@"eventvelocity"];
            self.touchEventDataVelocity = [v26 integerValue];
        }
        
        self.lastEventTime = arg2.timeStamp;
        
    }
    
    NSString * v33 = [NSString stringWithFormat:@"%lu", [self getTotalTouchEventCount]];
    
    NSDictionary * dic = @{@"1" : @"autoposttype", v33 : @"totaleventcount"};
    
    [[CYFManager_ sharedManager] executeAutoPost:dic];
    
    [[CYFManager_ sharedManager] collectMotionDataOnTouch];
    
}

@end
