//
//  VC_Login.h
//  Football
//
//  Created by Andy on 14-3-9.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_Login : UIViewController<UITextFieldDelegate>
@property IBOutlet UITextField *accountName;
@property IBOutlet UITextField *password;
@property IBOutlet UIButton *loginButton;
@property IBOutlet UIButton *registerButton;
@property IBOutlet UISwitch *rememberSwitch;
@property IBOutlet UIButton *forgetPasswordButton;

@end
