//
//  Captain_RootViewController.h
//  Football
//
//  Created by Andy on 14-3-15.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pre_Define.h"
#import "Captain_Protocol.h"
#import "Captain_MainMenu.h"
#import "Captain_MatchArrangement.h"
#import "Captain_MyPlayers.h"
#import "Captain_NewPlayer.h"
#import "Captain_TeamProfile.h"

@interface Captain_RootViewController : UIViewController<MenuSelected>
@property IBOutlet UIView *mainView;
@property IBOutlet UIView *mainMenuView;
@end
