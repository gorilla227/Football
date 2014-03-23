//
//  Captain_MainMenu.h
//  Football
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuSelected <NSObject>

-(void)menuSwitch:(BOOL)showMenu;

@end
@interface Captain_MainMenu : UITableViewController
@property id<MenuSelected>delegate;
@end
