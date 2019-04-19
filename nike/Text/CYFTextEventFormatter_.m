

#import "CYFTextEventFormatter_.h"
#import "NSDate+CYFExtra_.h"
#import "CYFTextEvent_.h"

@implementation CYFTextEventFormatter_

- (id)formatTextData:(CYFTextEvent_ *)arg1 withLastEventTime:(id)arg2 {
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    [dic setObject:@"" forKey:@"datastring"];
    [dic setObject:[NSNumber numberWithLong:0] forKey:@"eventvelocity"];
    
    if (arg1) {
        
        long v17 = [arg1.timeStamp timeIntervalSinceDateInMilliSeconds:arg2];
        
        NSString * v20 = [NSString stringWithFormat:@"%lu", arg1.eventType];
        
        NSString * v23 = [NSString stringWithFormat:@"%@,%ld,%@;", v20, v17, arg1.textElementAddressString];
        
        if (arg1.isCopy) {
            
            v23 = [v23 stringByReplacingOccurrencesOfString:@";" withString:@",1;"];
            
        }
        
        [dic setObject:v23 forKey:@"datastring"];
        
        NSNumber * v33 = [NSNumber numberWithInteger:[v20 integerValue] + v17 + [arg1.textElementAddressString integerValue]];
        
        [dic setObject:v33 forKey:@"eventvelocity"];
    }
    
    return dic;
}

@end
