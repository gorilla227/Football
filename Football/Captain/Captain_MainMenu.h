//
//  Captain_MainMenu.h
//  Football
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_Protocol.h"

@interface Captain_MainMenu : UITableViewController<Captain_MainMenuDelegate>
@property id<MenuSelected>delegate;
@end
