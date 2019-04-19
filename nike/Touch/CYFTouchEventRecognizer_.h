//
//  CYFTouchEventRecognizer_.h
//  nike
//
//  Created by niu_o0 on 2019/4/16.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CYFTouchEventRecognizerDelegate-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYFTouchEventRecognizer_ : UIGestureRecognizer

+ (long long)getTouchUpDownEventCount;
+ (long long)getTouchMoveEventCount;
+ (long long)getTotalTouchEventCount;
@property(nonatomic) unsigned long long windowType; // @synthesize windowType=_windowType;
@property(nonatomic, weak) id <CYFTouchEventRecognizerDelegate_> touchRecorder; // @synthesize touchRecorder=_touchRecorder;

- (void)enqueTouchData:(id)arg1 withType:(long long)arg2;
- (void)resetRecognizer;
- (void)disableTouchRecognizer;
- (void)setEnabled:(_Bool)arg1;
- (_Bool)canBePreventedByGestureRecognizer:(id)arg1;
- (_Bool)canPreventGestureRecognizer:(id)arg1;

@property(nonatomic) long long totalTouchEventCount;
@property(nonatomic) long long touchMoveEventCount;
@property(nonatomic) long long touchEventCountExcludingMove;

@end

NS_ASSUME_NONNULL_END
