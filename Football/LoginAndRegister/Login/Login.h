//
//  Login.h
//  Football
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterProtocols.h"

@interface Login : UIViewController<JSONConnectDelegate, DismissKeyboard, UITextFieldDelegate>
@property IBOutlet UITextField *accountField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UIButton *registerButton;
@property IBOutlet UIButton *loginButton;
@property IBOutlet UIButton *qqAccountButton;
@property IBOutlet UIButton *sinaAccountButton;
@property IBOutlet UISegmentedControl *roleSegment;
@property IBOutlet UIView *loginContentView;

-(void)shiftUpViewForKeyboardShowing;
-(void)restoreViewForKeyboardHiding;
@end
