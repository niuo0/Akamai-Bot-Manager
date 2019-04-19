//
//  CYFGlobalManager.m
//  nike
//
//  Created by niu_o0 on 2019/4/10.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFGlobalManager_.h"
#import <UIKit/UIKit.h>
#import "NSString+CYFExtra_.h"
#import <sys/utsname.h>


@implementation CYFGlobalManager_

+ (instancetype)sharedGlobalManager {
    
    static id mananer = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mananer = [[CYFGlobalManager_ alloc] initPrivate];
        
        [mananer buildDeviceInfo:NO];
        
    });
    
    return mananer;
}

- (id)initPrivate {
    
    if (self == [super init]) {
        
        self.startDate = [NSDate date];
        
        self.deviceInfo = @"-1";
        
        self.isDeviceInfoCalculated = FALSE;
        
        self.dInfoInitTime = 0;
        
        self.sessionId = 0;
        
        self.enableFrontEndPost = 0;
        
        self.apiUrl = @"https://apim.cformanalytics.com/";
        
        self.sensorDataFieldName = @"sensor_data";
        
        self.autoPostWakeUpTime = 0;
        
        self.autoPostMaxTransmissionLimit = 50000;
        
        self.testMode = NO;
    }
    
    return self;
}

- (NSDate *)startingDate {
    
    if (!self.startDate) {
        
        self.startDate = [NSDate date];
        
    }
    
    return self.startDate;
}

- (void)resetStartingDate {
    
    self.startDate = nil;
    
    self.startDate = [NSDate date];
    
}

- (void)buildDeviceInfo:(BOOL)info {
    
    if (info){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!self.isDeviceInfoCalculated) {
                    
                    NSString * info = [self deviceInfoBuildingBlock]();
                    
                    CFTimeInterval time = CACurrentMediaTime();
                    
                    [self deviceInfoAssignmentBlock](info, time);
                }
                
            });
            
        });
        
    }else{
        
        NSString * info = [self deviceInfoBuildingBlock]();
        
        CFTimeInterval time = CACurrentMediaTime();
        
        [self deviceInfoAssignmentBlock](info, time);
    }
    
}

- (buildingBlock)deviceInfoBuildingBlock {
    
    return ^ NSString * (void){
        
        NSString * version = [[UIDevice currentDevice] systemVersion];
        NSString * model = [[UIDevice currentDevice] model];
        NSString * type = [self getDeviceHardwareType];
        CGSize size = [self getCurrentScreenSize];
        NSString * broken = [self isDeviceJailBroken];
        
        NSDictionary * batter = [self getBatteryInfo];
        NSString * batteryState = [batter objectForKey:@"batteryState"];
        batteryState = [batteryState percentEncode];
        NSString * batteryLevel = [batter objectForKey:@"batteryLevel"];
        batteryLevel = [batteryLevel percentEncode];
        
        NSInteger or = [self getCurrentStatusBarOrientation];
        
        NSString * l = [self getCurrentLanguage];
        
        NSString * i = [self getAppIdentifier];
        
        NSString * u = [self fetchIdentifierForTheVendor];
        
        /*sp  sp-4  sp-8-0xc4  sp-16--0xbc  sp-24--0xb4  sp-28-0xb0 sp-32--0xac sp-36--0xa8 sp-40--0xa4 0x2c sp-48-0x34 sp-56-0x90*/
        NSString * deviceInfo = [NSString stringWithFormat:@"%@,%@,%@,%.0f,%.0f,%@,%@,%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%ld,%@,%@,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1",@"-1",@"uaend",@"-1", floorf(size.height), floorf(size.width), batteryState, batteryLevel, or, l, version, @"-1", model, @"-1", type, @"-1", i, @"-1", broken, u, 0, @"-1", @"-1"];
        
        return deviceInfo;
    };
    
}

- (assignmentBlock)deviceInfoAssignmentBlock {
    
    return ^(NSString * str, float x) {
        
        if (!self.isDeviceInfoCalculated) {
            
            self.deviceInfo = str;
            self.dInfoInitTime = CACurrentMediaTime() -x;
            self.isDeviceInfoCalculated = YES;
            
        }
        
    };
}

- (NSString *)getDeviceHardwareType {
    
    struct utsname systemInfo;
    uname(&systemInfo); // 获取系统设备信息
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    return [platform stringByReplacingOccurrencesOfString:@"," withString:@"/"];
}

- (CGSize)getCurrentScreenSize{
    
    return [UIScreen mainScreen].bounds.size;
    
}


- (id)isDeviceJailBroken{
    return @"-1";
}

- (NSDictionary *)getBatteryInfo{
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
    
    NSString * s = @"-1";
    
    if (state == UIDeviceBatteryStateUnplugged){
        s = @"0";
    } else if (state == UIDeviceBatteryStateCharging ||
        state == UIDeviceBatteryStateFull){
        s = @"1";
    }
    
    float f = [[UIDevice currentDevice] batteryLevel];
    
    NSString * sf = [NSString stringWithFormat:@"%.0f", f*100];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:s, @"batteryState", sf, @"batteryLevel", nil];
    
    return dic;
}

- (NSInteger)getCurrentStatusBarOrientation{
    
    UIInterfaceOrientation or = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (or-1 >= 2){
        return -1;
    }else{
        return 1;
    }
    
}

- (NSString *)getCurrentLanguage {
    
    NSString * l = [[NSLocale preferredLanguages] firstObject];
    
    l = [[NSLocale currentLocale] displayNameForKey:NSLocaleLanguageCode value:l];
    
    l = [NSLocale canonicalLanguageIdentifierFromString:l];
    
    if ([NSString isEmptyOrNil:l]){
        return @"en";
    }
    
    return l;
}

- (NSString *)getAppIdentifier {
    
    NSDictionary * dic = [[NSBundle mainBundle] infoDictionary];
    
    NSString * identifier = [dic objectForKey:@"CFBundleIdentifier"];
    
    if (identifier) {
        return identifier;
    }else{
         identifier = [dic objectForKey:@"CFBundleName"];
        
        if (identifier) {
            return identifier;
        }else{
            identifier = [dic objectForKey:@"CFBundleDisplayName"];
            return identifier;
        }
        
    }
}

- (NSString *)fetchIdentifierForTheVendor {
    
    NSString * uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if (uuid == nil) {
        return  @"-1";
    }
    return uuid;
}

- (id)getDeviceInfoString {
    
    if (self.isDeviceInfoCalculated) {
        return self.deviceInfo;
    }else{
        
        NSString * info = [self deviceInfoBuildingBlock]();
        
        CFTimeInterval time = CACurrentMediaTime();
        
        [self deviceInfoAssignmentBlock](info, time);
        
        return @"-1";
    }
    
}

@end
