//
//  Register_Captain_Advance.h
//  Football
//
//  Created by Andy on 14-3-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterView.h"
#import "CallFriendsMenu.h"

@interface Register_Captain_Advance : UIViewController<DismissCallFriendsMenu, DismissCallFriendsMenu>
@property IBOutlet UIView *callFriendsMenuView;
@end
