

#import "CaptainHook/CaptainHook.h"
#import <Foundation/Foundation.h>


CHDeclareClass(SecureSensorData);

CHMethod2(id, SecureSensorData, build, id, arg1, error, void *, arg2) {
    
    NSLog(@"%@", arg1);
    
    return CHSuper2(SecureSensorData, build, arg1, error, arg2);
    
}

CHDeclareClass(CYFManager);

CHMethod3(void, CYFManager, performSelector, SEL, arg1, withObject, id, arg2, afterDelay, double, arg3) {
    
    NSLog(@"``%f",arg3);
    
    return CHSuper3(CYFManager, performSelector, arg1, withObject, arg2, afterDelay, arg3);
    
}

CHMethod1(id, CYFManager, buildSensorData, long long , arg1) {
    
    NSString * s = CHSuper1(CYFManager, buildSensorData, arg1);
    
    NSLog(@"--%lld", arg1);
    
    return s;
    
}

CHMethod1(id, CYFManager, collectSensorData, long long , arg1) {
    
    NSString * s = CHSuper1(CYFManager, collectSensorData, arg1);
    
    NSLog(@"--%lld", arg1);
    
    return s;
    
}

CHMethod1(long long , CYFManager, getMilliSecondsFromSeconds, double, arg1) {
    
    long long r = CHSuper1(CYFManager, getMilliSecondsFromSeconds, arg1);
    
    return r;
}

CHDeclareClass(CYFMotionHandler);

CHMethod0(id, CYFMotionHandler, getSensorData) {
    
    NSDictionary * dic = CHSuper0(CYFMotionHandler, getSensorData);
    
    NSLog(@"%@", dic);
    
    return dic;
    
}

CHDeclareClass(FeistelCipher);

CHClassMethod2(ull, FeistelCipher, encode, ulong, arg1, withKey, uint, arg2) {
    
    ull l = CHSuper2(FeistelCipher, encode, arg1, withKey, arg2);
    
    return l;
    
}



CHConstructor {
    
    @autoreleasepool {
        
        
        CHLoadLateClass(SecureSensorData);
        CHHook2(SecureSensorData, build, error);
        
        CHLoadLateClass(CYFManager);
        CHHook3(CYFManager, performSelector, withObject, afterDelay);
        CHHook1(CYFManager, buildSensorData);
        CHHook1(CYFManager, collectSensorData);
        CHHook1(CYFManager, getMilliSecondsFromSeconds);
        
        CHLoadLateClass(CYFMotionHandler);
        CHHook0(CYFMotionHandler, getSensorData);
        
        
        CHLoadLateClass(FeistelCipher);
        CHClassHook2(FeistelCipher, encode, withKey);
        
    }
    
}
