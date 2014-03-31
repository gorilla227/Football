//
//  Captain_RootViewController.h
//  Football
//
//  Created by Andy on 14-3-15.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_MainMenu.h"
#import "Captain_TabBarController.h"
#import "Captain_Protocol.h"

@interface Captain_RootViewController : UIViewController<MenuSelected>
@property IBOutlet UIView *tabView;
@property IBOutlet UIView *mainMenuView;
@end
