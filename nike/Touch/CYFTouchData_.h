//
//  CYFTouchData_.h
//  nike
//
//  Created by niu_o0 on 2019/4/16.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CYFTouchDataBuilder_ <NSObject>
@property(nonatomic) unsigned long long formatterType;
@property(nonatomic) CGPoint cords;
@property(nonatomic) long long totalTouchEventCount;
@property(nonatomic) unsigned long long tapCount;
- (void)setYCords:(NSString *)arg1;
- (void)setXCords:(NSString *)arg1;
- (void)setTouchViewAddressString:(NSString *)arg1;
- (void)setTouchEventType:(NSString *)arg1;
- (void)setTimeStamp:(NSDate *)arg1;
@end

typedef void(^buildBlock)(id <CYFTouchDataBuilder_>);

@interface CYFTouchData_ : NSObject <CYFTouchDataBuilder_>

+ (id)build:(buildBlock)arg1;
@property(nonatomic) long long totalTouchEventCount; // @synthesize totalTouchEventCount=_totalTouchEventCount;
@property(retain, nonatomic) NSString *touchViewAddressString; // @synthesize touchViewAddressString=_touchViewAddressString;
@property(nonatomic) unsigned long long formatterType; // @synthesize formatterType=_formatterType;
@property(nonatomic) CGPoint cords; // @synthesize cords=_cords;
@property(nonatomic) unsigned long long tapCount; // @synthesize tapCount=_tapCount;
@property(retain, nonatomic) NSString *touchEventType; // @synthesize touchEventType=_touchEventType;
@property(retain, nonatomic) NSDate *timeStamp; // @synthesize timeStamp=_timeStamp;
@property(retain, nonatomic) NSString *yCords; // @synthesize yCords=_yCords;
@property(retain, nonatomic) NSString *xCords; // @synthesize xCords=_xCords;

- (id)initWithEventType:(id)arg1 tapCount:(unsigned long long)arg2 cordinates:(struct CGPoint)arg3 formatterType:(unsigned long long)arg4 touchAddString:(id)arg5 andTimeStamp:(id)arg6;
- (id)initWithEventType:(id)arg1 tapCount:(unsigned long long)arg2 cordinates:(struct CGPoint)arg3 formatterType:(unsigned long long)arg4 andTimeStamp:(id)arg5;
- (id)init;

@end

NS_ASSUME_NONNULL_END
