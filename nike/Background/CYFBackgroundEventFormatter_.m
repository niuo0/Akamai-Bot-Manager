

#import "CYFBackgroundEventFormatter_.h"
#import "CYFBackgroundEvent_.h"

@implementation CYFBackgroundEventFormatter_

+ (id)formatEvent:(CYFBackgroundEvent_ *)arg1 {
    
    
    if (arg1) {
        
        return [NSString stringWithFormat:@"%lu,%ld", arg1.eventType, arg1.timeStamp];
        
    }
    
    return nil;
}

@end
