//
//  Login_Content.h
//  Football
//
//  Created by Andy on 14-3-22.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pre_Define.h"
#import "WebUtils.h"
#import "Register_Captain.h"
#import "LoginAndRegisterView.h"

@interface Login_Content : UIViewController<DismissKeyboard, WebUtilsDelegate>
@property IBOutlet UITextField *accountField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UIButton *registerButton;
@property IBOutlet UIButton *loginButton;
@property IBOutlet UIButton *qqAccountButton;
@property IBOutlet UIButton *sinaAccountButton;

-(void)loginWithUser:(NSData *)userData;
@end
