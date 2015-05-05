//
//  LoginAndRegisterView.h
//  Soccer
//
//  Created by Andy on 14-3-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DismissKeyboard <NSObject>
-(void)dismissKeyboard;
@end

@protocol MoveTextFieldForKeyboardShowing <NSObject>
-(void)keyboardWillShow:(CGAffineTransform)transform;
-(void)keyboardWillHide;
@end