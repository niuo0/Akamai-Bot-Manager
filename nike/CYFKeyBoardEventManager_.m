//
//  CYFKeyBoardEventManager_.m
//  nike
//
//  Created by niu_o0 on 2019/4/15.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import "CYFKeyBoardEventManager_.h"
#import <UIKit/UIKit.h>
#import "UIApplication+CYFKeyboard_.h"
#import "CYFManager_.h"

@implementation CYFKeyBoardEventManager_

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureKeyBoardTouchEvents];
    }
    return self;
}

- (void)configureKeyBoardTouchEvents {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardDidHide:(id)arg1 {
    [self removeGestureOnKeyboardWindow];
}

- (void)keyboardDidAppear:(id)arg1 {
    [self attachGestureOnKeyboardWindow];
}

- (void)attachGestureOnKeyboardWindow {
    
    UIWindow * window = [UIApplication extractKeyBoardWindow];
    
    if (window) {
        
        [self removeGestureOnKeyboardWindow:window];
        
        [[CYFManager_ sharedManager] startCollectingTouchEventsOnWindow:window withType:2];
        
    }
    
}

- (void)removeGestureOnKeyboardWindow {
    
    UIWindow * window = [UIApplication extractKeyBoardWindow];
    
    if (window) {
        
        [self removeGestureOnKeyboardWindow:window];
        
    }
    
}

- (void)removeGestureOnKeyboardWindow:(id)arg1 {
    
    [[CYFManager_ sharedManager] stopCollectingTouchEventsOnWindow:arg1];
    
}

@end
