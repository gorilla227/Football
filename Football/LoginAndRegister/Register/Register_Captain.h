//
//  Register_Captain.h
//  Football
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterProtocols.h"

@interface Register_Captain : UIViewController<DismissKeyboard, UITextFieldDelegate>
@property IBOutlet UITextField *teamName;
@property IBOutlet UITextField *cellphoneNumber;
@property IBOutlet UITextField *password;
@property IBOutlet UIButton *registerButton;

-(void)shiftUpViewForKeyboardShowing;
-(void)restoreViewForKeyboardHiding;
@end
