//
//  CFYTouchEventFormatterBase_.h
//  nike
//
//  Created by niu_o0 on 2019/4/16.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYFTouchData_.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFYTouchEventFormatterBase_ : NSObject

@property(retain, nonatomic) NSString *formatTypeString; // @synthesize formatTypeString=_formatTypeString;

- (id)formatTouchData:(CYFTouchData_ *)arg1 withLastEventTime:(NSDate *)arg2;

@end

NS_ASSUME_NONNULL_END
