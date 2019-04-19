//
//  CYFTouchEventRecognizerFactory_.m
//  nike
//
//  Created by niu_o0 on 2019/4/16.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFTouchEventRecognizerFactory_.h"
#import "CYFKeyWindowTouchEventRecognizer_.h"
#import "CYFKeyBoardWindowTouchEventRecognizer_.h"

@implementation CYFTouchEventRecognizerFactory_

+ (id)createTouchEventRecognizerForType:(unsigned long long)arg1 {
    
    if (arg1 == 2) {
        return [[CYFKeyBoardWindowTouchEventRecognizer_ alloc] init];
    }else if (arg1 == 1) {
        return [[CYFKeyWindowTouchEventRecognizer_ alloc] init];
    }
    
    return nil;
}

@end
