//
//  Register.h
//  Football
//
//  Created by Andy Xu on 14-6-8.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterProtocols.h"

@interface Register : UITableViewController<DismissKeyboard, UITextFieldDelegate>
@property NSInteger roleCode;
-(void)shiftUpViewForKeyboardShowing;
-(void)restoreViewForKeyboardHiding;
@end
