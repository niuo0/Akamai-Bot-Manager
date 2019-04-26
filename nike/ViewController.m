//
//  ViewController.m
//  nike
//
//  Created by niu_o0 on 2019/4/9.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "ViewController.h"
#include <objc/message.h>
#import "CYFGlobalManager_.h"
#import <AkamaiBMP/CYFMonitor.h>
#import "CYFManager_.h"
#import "RSACrypt_.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    id m = objc_msgSend(NSClassFromString(@"CYFGlobalManager"), @selector(sharedGlobalManager));
    
    id b = objc_msgSend(m, @selector(deviceInfoBuildingBlock));
    
    NSString *(^buildingBlock)(void) = b;
    
    NSString * s1 = buildingBlock();
    
    NSLog(@"%@", s1);
    
    NSString * s2 = [[CYFGlobalManager_ sharedGlobalManager] deviceInfoBuildingBlock]();
    
    NSLog(@"%@", s2);
    
    id ma = objc_msgSend(NSClassFromString(@"CYFManager"), @selector(sharedManager));

    [ma initialSetUp];
    NSString * s = [CYFMonitor getSensorData];
    NSLog(@"or = %@", s);
    
    
    NSString * s_ =  [[CYFManager_ sharedManager] getSensorData];
    
    NSLog(@"self = %@",s_);
    
}


@end
