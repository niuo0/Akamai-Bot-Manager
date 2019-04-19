


#import "CYFBackgroundEventListener_.h"
#import <UIKit/UIKit.h>
#import "CYFBackgroundEvent_.h"


@implementation CYFBackgroundEventListener_

- (instancetype)init
{
    return [self initListener:nil];
}

- (id)initListener:(id)arg1 {
    
    if (self = [super init]) {
        
        self.eventDelegate = arg1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeInActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationBecomeActive:(id)arg1 {
    
    CYFBackgroundEvent_ * event = [[CYFBackgroundEvent_ alloc] initWithEventType:3 andTimeStamp:[NSDate date]];
    
    [self.eventDelegate onEvent:event];
}

- (void)applicationBecomeInActive:(id)arg1 {
    
    CYFBackgroundEvent_ * event = [[CYFBackgroundEvent_ alloc] initWithEventType:2 andTimeStamp:[NSDate date]];
    
    [self.eventDelegate onEvent:event];
}

@end
