//
//  Captain_TabBarController.h
//  Football
//
//  Created by Andy on 14-3-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_Protocol.h"

@interface Captain_TabBarController : UITabBarController
@property id<Captain_MainMenuDelegate>mainMenuDelegate;
@end
