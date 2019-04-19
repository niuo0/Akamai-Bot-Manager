//
//  CYFBackgroundEventManager_.h
//  nike
//
//  Created by niu_o0 on 2019/4/12.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYFBackgroundEventListener_.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYFBackgroundEventManager_ : NSObject <CYFBackgroundEventListenerDelegate_>

+ (instancetype)sharedBackgroundEventManager;
@property(retain, nonatomic) NSString *eventData; // @synthesize eventData=_eventData;
@property(retain, nonatomic) CYFBackgroundEventListener_ *eventListener; // @synthesize eventListener=_eventListener;
- (id)getBackgroundEventData;
- (void)resetBackgroundData;
- (void)configure;
- (id)initPrivate;

@end

NS_ASSUME_NONNULL_END
