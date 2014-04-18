//
//  Captain_Protocol.h
//  Football
//
//  Created by Andy on 14-3-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MenuSelected <NSObject>
-(void)menuSwitch:(BOOL)showMenu;
-(void)switchSelectMenuView:(NSString *)selectedView;
@end