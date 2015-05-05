//
//  Soccer_BaseNavigationController.h
//  Soccer
//
//  Created by Andy on 14-4-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenu.h"
#import "MessageBarButtonItem.h"

@interface Soccer_BaseNavigationController : UINavigationController<MainMenuSwitchViewControllerDelegate, MainMenuAppearenceDelegate, MessageBarButtonDelegate, BusyIndicatorDelegate, JSONConnectDelegate>
-(void)refreshUnreadMessageAmount;
@end
