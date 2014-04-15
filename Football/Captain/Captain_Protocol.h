//
//  Captain_Protocol.h
//  Football
//
//  Created by Andy on 14-3-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol Captain_MainMenuDelegate <NSObject>
//-(void)changeRootMenuToIndex:(NSInteger)rootMenuIndex;
//@end

@protocol MenuSelected <NSObject>
-(void)menuSwitch:(BOOL)showMenu;
-(void)switchSelectMenuView:(NSString *)selectedView;
@end

@protocol SwitchSelectedMenuView <NSObject>
-(void)switchSelectMenuView:(NSString *)selectedView;
@end