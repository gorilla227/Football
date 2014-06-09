//
//  Login.h
//  Football
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Register.h"
#import "LoginAndRegisterProtocols.h"

@interface Login : UIViewController<JSONConnectDelegate, DismissKeyboard, UITextFieldDelegate>

-(void)initialTextFields;
-(void)shiftUpViewForKeyboardShowing;
-(void)restoreViewForKeyboardHiding;
@end
