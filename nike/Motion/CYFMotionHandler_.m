

#import "CYFMotionHandler_.h"
#import "CYFGlobalManager_.h"
#import "CYFMotionModelDelta_.h"
#import "CYFMotionModel_.h"
#import "NSDate+CYFExtra_.h"
#import <CoreMotion/CoreMotion.h>
#import "CYFManager_.h"

@implementation CYFMotionHandler_

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
    
    self.lastPhase3EventTime = [[CYFGlobalManager_ sharedGlobalManager] startingDate];
    
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
    
    [self.phaseTwoEvents enumerateObjectsUsingBlock:^(CYFMotionModelDelta_ *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.model];
    }];
    
    [array sortUsingComparator:^NSComparisonResult(CYFMotionModel_ *  _Nonnull obj1, CYFMotionModel_ *  _Nonnull obj2) {
        return  [obj1.timestamp compare:obj2.timestamp];
    }];
    
    NSDate * date = [[CYFGlobalManager_ sharedGlobalManager] startingDate];
    
    __block long v27 = 0;
    __block NSString * v21 = @"";
    
    [array enumerateObjectsUsingBlock:^(CYFMotionModel_ *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        long t = [obj.timestamp timeIntervalSinceDateInMilliSeconds:date];
        
        if (t <= 0) {
            t = 0;
        }
        
        NSString * s = [self formatEvent:obj timeStamp:t andTrigger:obj.touch];
        
        v21 = [v21 stringByAppendingString:s];
        
        v27 = t + lround(obj.agx*100) + lround(obj.agy*100) + lround(obj.agz*100) + lround(obj.ax*100) + lround(obj.ay*100) + lround(obj.az*100) + lround(obj.rx*100) + lround(obj.ry*100) + lround(obj.rz*100);
        
        [CYFGlobalManager_ sharedGlobalManager].startDate = obj.timestamp;
        
    }];
    
    
    NSArray * keys = @[@"sensorData", @"velocity", @"totalCount"];
    NSArray * values = @[v21, [NSNumber numberWithInteger:v27], [NSNumber numberWithInteger:array.count]];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (void)updateData:(CMDeviceMotion *)arg1 timeStamp:(id)arg2 andTrigger:(bool)arg3 {
    
    if (arg1) {
        
        self.totalEvents ++;
        CYFMotionModel_ * v14 = [self createMotionModel:arg1];
        v14.timestamp = arg2;
        v14.touch = arg3;
        
        if (self.phaseOneEvents.count > 9) {
            
            unsigned int t = [arg2 timeIntervalSinceDateInMilliSeconds:self.lastPhase3EventTime];
            
            if ((arg3 || t >= 0x3E8) &&
                self.phaseThreeEvents.count <= 9) {
                
                [self.phaseThreeEvents addObject:v14];
                self.lastPhase3EventTime = arg2;
                
            }else{
                
                double d = [self getMotionDelta:v14];
                
                if (d != 0.0) {
                    
                    CYFMotionModelDelta_ * delta = [[CYFMotionModelDelta_ alloc] init];
                    delta.model = v14;
                    delta.delta = d;
                    
                    [self.phaseTwoEvents addObject:delta];
                    
                    if (self.phaseTwoEvents.count >= 0xB) {
                        //TODO:
                        [self.phaseTwoEvents sortUsingComparator:^NSComparisonResult(CYFMotionModelDelta_ *  _Nonnull obj1, CYFMotionModelDelta_ *  _Nonnull obj2) {
                            
                            return obj1.delta > obj2.delta;
                        }];
                        
                        [self.phaseTwoEvents removeLastObject];
                        
                    }
                    
                }
                
            }
            
        }else{
            
            [self.phaseOneEvents addObject:v14];
            
        }
        
        self.lastMotionOb = v14;
    }
    
}

- (CYFMotionModel_ *)createMotionModel:(CMDeviceMotion *)arg1 {
    
    CYFMotionModel_ * _model = [[CYFMotionModel_ alloc] init];
    
    if (arg1) {
        
        CMAcceleration ac = arg1.userAcceleration;
        
        _model.ax = ac.x;
        _model.ay = ac.y;
        _model.az = ac.z;
        
        CMAcceleration ag = arg1.gravity;
        
        _model.agx = ag.x;
        _model.agy = ag.y;
        _model.agz = ag.z;
        
        CMRotationRate r = arg1.rotationRate;
        
        _model.rx = r.x;
        _model.ry = r.y;
        _model.rz = r.z;
    }
    
    return _model;
}

//TODO:
- (double)getMotionDelta:(CYFMotionModel_ *)arg1 {
    
    return  fabs(arg1.agx - self.lastMotionOb.agx) +
            fabs(arg1.agy - self.lastMotionOb.agy) +
            fabs(arg1.agz - self.lastMotionOb.agz) +
            fabs(arg1.ax - self.lastMotionOb.ax) +
            fabs(arg1.ay - self.lastMotionOb.ay) +
            fabs(arg1.az - self.lastMotionOb.az) +
            fabs(arg1.rx - self.lastMotionOb.rx) +
            fabs(arg1.ry - self.lastMotionOb.ry) +
            fabs(arg1.rz - self.lastMotionOb.rz);
    
}

- (void)autoPostSensorDataForMotionEvent{
    
    NSString * v6 = [NSString stringWithFormat:@"%lu", [self getTotalEventCount]];
    
    NSDictionary * v8 = @{@"autoposttype" : @"2", @"totaleventcount" : v6};
    
    [[CYFManager_ sharedManager] executeAutoPost:v8];
}

- (id)formatEvent:(CYFMotionModel_ *)arg1 timeStamp:(long long)arg2 andTrigger:(bool)arg3 {
    
    NSString * v25 = @"0";
    
    if (arg3) v25 = @"1";
    
    return [NSString stringWithFormat:@"%ld,%.02f,%.02f,%.02f,%.02f,%.02f,%.02f,%.02f,%.02f,%.02f,%@;", arg2, arg1.agx, arg1.agy, arg1.agz, arg1.ax, arg1.ay, arg1.az, arg1.rx, arg1.ry, arg1.rz, v25];
}

@end
