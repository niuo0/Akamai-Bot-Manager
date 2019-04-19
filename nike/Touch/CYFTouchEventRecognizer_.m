//
//  CYFTouchEventRecognizer_.m
//  nike
//
//  Created by niu_o0 on 2019/4/16.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFTouchEventRecognizer_.h"
#import "CYFUtilities_.h"

 static long long totalTouchEventCount;
 static long long touchMoveEventCount;
 static long long touchEventCountExcludingMove;

@implementation CYFTouchEventRecognizer_

- (instancetype)init
{
    return [self initWithTarget:nil action:nil];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    
    if (self = [super initWithTarget:target action:action]) {
        self.cancelsTouchesInView = NO;
        self.windowType = 0;
    }
    return self;
}

- (long long)touchEventCountExcludingMove{
    return touchEventCountExcludingMove;
}

-(void)setTouchEventCountExcludingMove:(long long)touchEventCountExcludingMove{
    touchEventCountExcludingMove = touchEventCountExcludingMove;
}

- (long long)touchMoveEventCount{
    return touchMoveEventCount;
}

- (void)setTouchMoveEventCount:(long long)touchMoveEventCount{
    touchMoveEventCount = touchMoveEventCount;
}

- (long long)totalTouchEventCount{
    return totalTouchEventCount;
}

- (void)setTotalTouchEventCount:(long long)totalTouchEventCount{
    totalTouchEventCount = totalTouchEventCount;
}

+ (long long)getTouchMoveEventCount {
    return touchMoveEventCount;
}

+ (long long)getTotalTouchEventCount{
    return totalTouchEventCount;
}

+ (long long)getTouchUpDownEventCount{
    return touchEventCountExcludingMove;
}

- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {
    
    [super touchesBegan:arg1 withEvent:arg2];
    
    [self enqueTouchData:arg1 withType:1];
}

- (void)touchesMoved:(id)arg1 withEvent:(id)arg2 {
    
    [super touchesMoved:arg1 withEvent:arg2];
    
    [self enqueTouchData:arg1 withType:0];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self enqueTouchData:touches withType:1];
    
    
    do {
        if (event.allTouches.count == touches.count) {
            self.state = 3;
        }else{
            self.state = 2;
        }
        
    } while (0);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesCancelled:touches withEvent:event];
    [self enqueTouchData:touches withType:1];
        
    self.state = 4;
    
}

- (bool)canPreventGestureRecognizer:(id)arg1 {
    return false;
}

- (bool)canBePreventedByGestureRecognizer:(id)arg1 {
    return false;
}

- (void)setEnabled:(bool)arg1 {
    [super setEnabled:true];
}

- (void)disableTouchRecognizer {
    [super setEnabled:false];
}

- (void)resetRecognizer {
    [self disableTouchRecognizer];
    [self setTouchEventCountExcludingMove:0];
    [self setTouchMoveEventCount:0];
    [self setTotalTouchEventCount:0];
}

- (void)enqueTouchData:(NSSet<UITouch *> *)arg1 withType:(long long)arg2 {
    
    NSSet<UITouch *> * touchs = [arg1 mutableCopy];
    
    [touchs.allObjects enumerateObjectsUsingBlock:^(UITouch * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        self.totalTouchEventCount += 1;
        
        if (arg2) {
            
            if (arg2 == 1) {
                
                if (self.touchEventCountExcludingMove > 49) {
                    [self.touchRecorder touchDataRecognizer:self withTouchData:nil];
                    return ;
                }
            }
            
        }else{
            if (self.touchMoveEventCount >= 50) {
                [self.touchRecorder touchDataRecognizer:self withTouchData:nil];
                return ;
            }
        }
        
        CGPoint point = [obj locationInView:self.view];
        
        NSString * v86 = @"0";
        if (obj.view) {
            
            NSString * v30 = [NSString stringWithFormat:@"%p", obj.view];
            v86 = [NSString stringWithFormat:@"%ld", [CYFUtilities_ strToInt:v30]];
        }
        
        
        
    }];
    
}

@end
