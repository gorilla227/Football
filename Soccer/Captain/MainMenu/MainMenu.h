//
//  MainMenu.h
//  Soccer
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

@interface MainMenuCell_WithBadge : UITableViewCell

@end

@interface MainMenu : UITableViewController
@property id<MainMenuAppearenceDelegate>delegateOfMenuAppearance;
@property id<MainMenuSwitchViewControllerDelegate>delegateOfViewSwitch;
@property IBOutlet UIToolbar *toolBar;

-(void)formatCell:(UITableViewCell *)cell withFont:(UIFont *)font;
-(void)menuListGeneration;
-(void)resetMenuFolder;
-(void)initialFirtSelection:(NSIndexPath *)initialIndexPath;
@end
