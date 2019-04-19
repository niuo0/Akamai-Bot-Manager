//
//  CYFBackgroundEventManager_.m
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFBackgroundEventManager_.h"
#import "CYFBackgroundEventFormatter_.h"

@implementation CYFBackgroundEventManager_

+ (instancetype)sharedBackgroundEventManager {
    
    static CYFBackgroundEventManager_ * manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CYFBackgroundEventManager_ alloc] initPrivate];
    });
    
    return manager;
}

- (instancetype)init
{
    return [CYFBackgroundEventManager_ sharedBackgroundEventManager];
}

- (id)initPrivate {
    
    if (self = [super init]) {
        [self configure];
    }
    
    return self;
}

- (void)configure {
    
    CYFBackgroundEventListener_ * listener = [[CYFBackgroundEventListener_ alloc] initListener:self];
    self.eventListener = listener;
    self.eventData = @"";
    
}

- (void)resetBackgroundData {
    self.eventData = @"";
}

- (void)onEvent:(CYFBackgroundEvent_ *)arg1 {
    
    NSString * event = [CYFBackgroundEventFormatter_ formatEvent:arg1];
    
    if (event) {
        
        self.eventData = [self.eventData stringByAppendingString:event];
        
    }
    
}

- (id)getBackgroundEventData {
    return self.eventData;
}

@end
