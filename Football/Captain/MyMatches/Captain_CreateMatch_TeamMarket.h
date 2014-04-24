//
//  Captain_CreateMatch_SelectPlace.h
//  Football
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TeamMarket <NSObject>
-(void)receiveTeam:(NSString *)teamName;
@end

@interface Captain_CreateMatch_TeamMarket : UITableViewController
@property id<TeamMarket>delegate;
@end
