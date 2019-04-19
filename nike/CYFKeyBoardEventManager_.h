//
//  CYFKeyBoardEventManager_.h
//  nike
//
//  Created by niu_o0 on 2019/4/15.
//  Copyright © 2019年 niu_o0. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYFKeyBoardEventManager_ : NSObject

- (void)removeGestureOnKeyboardWindow:(id)arg1;
- (void)removeGestureOnKeyboardWindow;
- (void)attachGestureOnKeyboardWindow;
- (void)keyboardDidHide:(id)arg1;
- (void)keyboardDidAppear:(id)arg1;
- (void)configureKeyBoardTouchEvents;

@end

NS_ASSUME_NONNULL_END
