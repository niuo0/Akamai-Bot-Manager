//
//  UIResponder+CYFInitialize_.m
//  nike
//
//  Created by niu_o0 on 2019/4/15.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "UIResponder+CYFInitialize_.h"
#import "CYFManager_.h"
#import "CYFGlobalManager_.h"

@implementation UIResponder (CYFInitialize_)

+ (void)load{
    [[NSNotificationCenter defaultCenter] addObserver:[self class] selector:@selector(_appDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

+ (void)_appDidFinishLaunching:(NSNotification *)noti {
    
    [CYFGlobalManager_ sharedGlobalManager];
    
    [[CYFManager_ sharedManager] initialSetUp];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidFinishLaunchingNotification object:nil];
    
}

@end
