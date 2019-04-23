

#import "CaptainHook/CaptainHook.h"
#import <Foundation/Foundation.h>


CHDeclareClass(SecureSensorData);

CHMethod2(id, SecureSensorData, build, id, arg1, error, void *, arg2) {
    
    
    objc_msgSend(self, @selector(setHmacKey:), nil);
    
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

CHDeclareClass(CYFMotionHandler);

CHMethod0(id, CYFMotionHandler, getSensorData) {
    
    NSDictionary * dic = CHSuper0(CYFMotionHandler, getSensorData);
    
    NSLog(@"%@", dic);
    
    return dic;
    
}


CHConstructor {
    
    @autoreleasepool {
        
        
        CHLoadLateClass(SecureSensorData);
        CHHook2(SecureSensorData, build, error);
        
        CHLoadLateClass(CYFManager);
        CHHook3(CYFManager, performSelector, withObject, afterDelay);
        CHHook1(CYFManager, buildSensorData);
        CHHook1(CYFManager, collectSensorData);
        
        CHLoadLateClass(CYFMotionHandler);
        CHHook0(CYFMotionHandler, getSensorData);
        
    }
    
}
