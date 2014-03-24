//
//  Login.h
//  Football
//
//  Created by Andy on 14-3-16.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Register/Captain/Register_Captain.h"
#import "Register/Player/Register_Player.h"
#import "Login_Content.h"

@interface Login : UIViewController<LoginAndRegisterView>
@property IBOutlet UISegmentedControl *roleSegment;
@property IBOutlet UIView *contentView;
@end
