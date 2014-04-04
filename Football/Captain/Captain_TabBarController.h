//
//  Captain_TabBarController.h
//  Football
//
//  Created by Andy on 14-3-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_Protocol.h"
#import "Captain_MatchArrangement.h"
#import "Captain_MyTeam.h"

@interface Captain_TabBarController : UITabBarController<SwitchSelectedMenuView>
@property id<Captain_MainMenuDelegate>mainMenuDelegate;
@end
