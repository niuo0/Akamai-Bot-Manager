

#import "CYFBackgroundEvent_.h"
#import "CYFGlobalManager_.h"
#import "NSDate+CYFExtra_.h"

@implementation CYFBackgroundEvent_

- (instancetype)initWithEventType:(unsigned long long)arg1 andTimeStamp:(id)arg2 {
    
    if (self = [super init]) {
        
        NSDate * date = [[CYFGlobalManager_ sharedGlobalManager] startingDate];
        
        self.eventType = arg1;
        
        self.timeStamp = [arg2 timeIntervalSinceDateInMilliSeconds:date];
    }
    
    return self;
}

@end
