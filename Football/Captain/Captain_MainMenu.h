//
//  Captain_MainMenu.h
//  Football
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainMenuAppearenceDelegate <NSObject>
-(void)menuSwitch;
@end

@protocol MainMenuSwitchViewControllerDelegate <NSObject>
-(void)switchSelectMenuView:(NSString *)selectedView;
-(void)logout;
@end

@interface Captain_MainMenu : UITableViewController
@property id<MainMenuAppearenceDelegate>delegateOfMenuAppearance;
@property id<MainMenuSwitchViewControllerDelegate>delegateOfViewSwitch;
-(void)formatCell:(UITableViewCell *)cell withFont:(UIFont *)font;
-(void)menuListGeneration;
-(void)resetMenuFolder;
@end
