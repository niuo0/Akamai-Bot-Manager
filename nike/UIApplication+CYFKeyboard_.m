//
//  UIApplication+CYFKeyboard_.m
//  nike
//
//  Created by niu_o0 on 2019/4/19.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "UIApplication+CYFKeyboard_.h"
#import "CYFUtilities_.h"

@implementation UIApplication (CYFKeyboard_)

+ (id)extractKeyBoardWindow {
    
    __block UIWindow * window = nil;
    
    [[[UIApplication sharedApplication] windows] enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![CYFUtilities_ IOS9OrHigher]) {
            
            if ([NSStringFromClass([obj class]) isEqualToString:@"UITextEffectsWindow"]) {
                
                window = obj;
                *stop = YES;
                return ;
            }
            
        }else {
            
            if ([NSStringFromClass([obj class]) isEqualToString:@"UIRemoteKeyboardWindow"]) {
                
                window = obj;
                *stop = YES;
                return ;
            }
            
        }
        
    }];
    
    return window;
}

@end
