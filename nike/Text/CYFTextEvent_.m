

#import "CYFTextEvent_.h"


@implementation CYFTextEvent_

- (instancetype)initWithEventType:(unsigned long long)arg1 eventCount:(long long)arg2 addressString:(id)arg3 andTimeStamp:(id)arg4 isCopy:(bool)arg5 {
    
    if (self = [super init]) {
        
        self.eventType = arg1;
        self.totalTextChangeEventCount = arg2;
        self.textElementAddressString = arg3;
        self.timeStamp = arg4;
        self.isCopy = arg5;
    }
    return self;
}

@end
