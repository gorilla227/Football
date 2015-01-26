//
//  Staring.h
//  Football
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Register.h"

@interface Login : UIViewController<UITextFieldDelegate, JSONConnectDelegate>
-(void)keyboardWillShow;
-(void)keyboardWillHide;
-(void)initialTextFields;
-(void)dismissKeyboard;
-(void)enterMainScreen;
@end
