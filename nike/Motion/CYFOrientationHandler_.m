


#import "CYFOrientationHandler_.h"
#import "CYFGlobalManager_.h"
#import <CoreMotion/CoreMotion.h>
#import "CYFOriModelDelta_.h"
#import "NSDate+CYFExtra_.h"

@implementation CYFOrientationHandler_

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.phaseOneEvents = [NSMutableArray new];
        self.phaseTwoEvents = [NSMutableArray new];
        self.phaseThreeEvents = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [self reset];
}

- (void)create {
    self.lastPhase3EventTime = [[CYFGlobalManager_ sharedGlobalManager] startDate];
}

- (void)reset {
    
    [self.phaseOneEvents removeAllObjects];
    [self.phaseTwoEvents removeAllObjects];
    [self.phaseThreeEvents removeAllObjects];
}

- (id)getSensorData {
    
    NSMutableArray * array = [NSMutableArray new];
    
    [array addObjectsFromArray:self.phaseOneEvents];
    [array addObjectsFromArray:self.phaseThreeEvents];
    
    [self.phaseTwoEvents enumerateObjectsUsingBlock:^(CYFOriModelDelta_ *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.model];
    }];
    
    [array sortUsingComparator:^NSComparisonResult(CYFOriModel_ * _Nonnull obj1, CYFOriModel_ * _Nonnull obj2) {
        return [obj1.timestamp compare:obj2.timestamp];
    }];
    
    NSDate * date = [[CYFGlobalManager_ sharedGlobalManager] startingDate];
    
    __block long v27 = 0;
    __block NSString * v21 = @"";
    
    [array enumerateObjectsUsingBlock:^(CYFOriModel_ *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        long t = [obj.timestamp timeIntervalSinceDateInMilliSeconds:date];
        
        if (t <= 0) {
            t = 0;
        }
        
        NSString * s = [self formatEvent:obj timeStamp:t andTrigger:obj.touch];
        
        v21 = [v21 stringByAppendingString:s];
        
        v27 = t + lround(obj.yaw*100) + lround(obj.pitch*100) + lround(obj.roll*100);
        
        [CYFGlobalManager_ sharedGlobalManager].startDate = obj.timestamp;
        
    }];
    
    
    NSArray * keys = @[@"sensorData", @"velocity", @"totalCount"];
    NSArray * values = @[v21, [NSNumber numberWithInteger:v27], [NSNumber numberWithInteger:array.count]];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
}

- (long long)getTotalEventCount{
    return self.totalEvents;
}

- (void)updateData:(CMDeviceMotion *)arg1 timeStamp:(id)arg2 andTrigger:(bool)arg3 {
    
    if (arg1) {
        
        self.totalEvents ++ ;
        
        CYFOriModel_ * model = [self createOrientationModel:arg1];
        model.timestamp = arg2;
        model.touch = arg3;
        
        if (self.phaseOneEvents.count < 9) {
            
            long t = [arg2 timeIntervalSinceDateInMilliSeconds:self.lastPhase3EventTime];
            
            if ((arg3 || t >= 0x3E8) &&
                self.phaseThreeEvents.count <= 9) {
                
                [self.phaseThreeEvents addObject:model];
                self.lastPhase3EventTime = arg2;
                
            }else{
                
                double d = [self getOrientationDelta:model];
                
                if (d != 0.0) {
                    CYFOriModelDelta_ * delta = [[CYFOriModelDelta_ alloc] init];
                    delta.model = model;
                    delta.delta = d;
                    [self.phaseTwoEvents addObject:delta];
                    
                    if (self.phaseTwoEvents.count >= 0xB) {
                        
                        [self.phaseTwoEvents sortUsingComparator:^NSComparisonResult(CYFOriModelDelta_ *  _Nonnull obj1, CYFOriModelDelta_ *  _Nonnull obj2) {
                            return obj1.delta > obj2.delta;
                        }];
                        
                        [self.phaseTwoEvents removeLastObject];
                    }
                    
                }
            }
            
        }else {
            [self.phaseOneEvents addObject:model];
        }
        
        self.lastoriOb = model;
    }
    
}

- (CYFOriModel_ *)createOrientationModel:(CMDeviceMotion *)arg1 {
    
    CYFOriModel_ * model = [[CYFOriModel_ alloc] init];
    
    model.yaw = arg1.attitude.yaw*180/M_PI;
    model.pitch = arg1.attitude.pitch*180/M_PI;
    model.roll = arg1.attitude.roll*180/M_PI;
    
    return model;
}

- (double)getOrientationDelta:(CYFOriModel_ *)arg1 {
    return fabs(arg1.yaw - self.lastoriOb.yaw) +
            fabs(arg1.pitch - self.lastoriOb.pitch) +
            fabs(arg1.roll - self.lastoriOb.roll);
}

- (void)autoPostSensorDataForOrientationEvent {
    
}

- (id)formatEvent:(CYFOriModel_ *)arg1 timeStamp:(long long)arg2 andTrigger:(bool)arg3 {
    
    NSString * v17 = @"0";
    
    if (arg3) v17 = @"1";
    
    return [NSString stringWithFormat:@"%ld,%.02f,%.02f,%.02f,%@;", arg2, arg1.yaw, arg1.pitch, arg1.roll, v17];
    
}

@end
