//
//  Register_Player.h
//  Football
//
//  Created by Andy on 14-3-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterView.h"

@interface Register_Player : UIViewController<DismissKeyboard>
@property IBOutlet UITextField *personalID;
@property IBOutlet UITextField *cellphoneNumber;
@property IBOutlet UITextField *qqNumber;
@property IBOutlet UITextField *birthday;
@property IBOutlet UITextField *activityRegion;
@property IBOutlet UITextField *password;
@end
