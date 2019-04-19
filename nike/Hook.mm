

#import "CaptainHook/CaptainHook.h"



CHDeclareClass(SecureSensorData);

CHMethod2(id, SecureSensorData, build, id, arg1, error, void *, arg2) {
    
    
    objc_msgSend(self, @selector(setHmacKey:), nil);
    
    return CHSuper2(SecureSensorData, build, arg1, error, arg2);
    
}

CHConstructor {
    
    @autoreleasepool {
        
        
        CHLoadLateClass(SecureSensorData);
        CHHook2(SecureSensorData, build, error);
    }
    
}
