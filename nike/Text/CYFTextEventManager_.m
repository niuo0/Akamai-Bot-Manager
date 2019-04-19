//
//  CYFTextEventManager_.m
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFTextEventManager_.h"
#import "CYFManager_.h"

@implementation CYFTextEventManager_

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)dealloc
{
    [self resetTextEventManager];
}

- (void)configure {
    
    self.textEventsListener = [[CYFTextEventListener_ alloc] init];
    
    self.textEventDataFormatter = [CYFTextEventFormatter_ new];
    
    self.textFormFieldDataFormatter = [CYFTextFormfieldDataFormatter_ new];
    
    self.textEventDataString = @"";
    
    self.textFormFieldDataString = @"";
    
    self.textEventDataVelocity = 0;
    
    self.lastEventTime = [NSDate date];
    
}

- (void)resetTextEventManager {
    self.textEventsListener = nil;
    self.textEventDataFormatter = nil;
    self.textFormFieldDataFormatter = nil;
}

- (id)getTextEventSensorData {
    return self.textEventDataString;
}

- (id)getTextFormFieldSensorData{
    return self.textFormFieldDataString;
}

- (long long)getTextEventVelocity{
    return self.textEventDataVelocity;
}

- (long long)getTotalTextEventCount{
    return [self.textEventsListener getTotalTextEventCount];
}

- (long long)getTextChangeEventCount {
    return [self.textEventsListener getTextChangeEventCount];
}

- (void)textEventListener:(CYFTextEventListener_ *)arg1 withTextData:(CYFTextEvent_ *)arg2 {
    
    if (arg2) {
        
        NSDictionary * v15 = [self.textEventDataFormatter formatTextData:arg2 withLastEventTime:self.lastEventTime];
        
        NSString * v39 = [v15 objectForKey:@"datastring"];
        
        if (v39) {
            self.textEventDataString = [self.textEventDataString stringByAppendingString:v39];
        }
        
        self.textEventDataVelocity += [[v15 objectForKey:@"eventvelocity"] integerValue];
        
        self.lastEventTime = [v15 objectForKey:@"timeStamp"];
    }
    
    NSDictionary * dic = @{@"4" : @"autoposttype", [NSString stringWithFormat:@"%lu", [self getTotalTextEventCount]] : @"totaleventcount"};
    
    [[CYFManager_ sharedManager] executeAutoPost:dic];
    
}

- (void)textEventListener:(CYFTextEventListener_ *)arg1 withTextFieldAddressString:(NSString *)arg2 {
    
    if (arg2) {
        
        self.textFormFieldDataString = [self.textFormFieldDataString stringByAppendingString:[self.textFormFieldDataFormatter formatTextFormFieldData:arg2]];
        
    }
    
}

@end
