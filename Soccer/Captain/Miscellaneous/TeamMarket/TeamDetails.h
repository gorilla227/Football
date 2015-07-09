//
//  TeamDetails.h
//  Soccer
//
//  Created by Andy Xu on 14/10/29.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
enum TeamDetailsViewType {
    TeamDetailsViewType_Default,
    TeamDetailsViewType_CreateMatch,
    TeamDetailsViewType_NoAction,
    TeamDetailsViewType_CallinTeamProfile
};

@protocol TeamMarketSelectionDelegate <NSObject>
-(void)selectedOpponentTeam:(Team *)selectedTeam;
@end

@interface TeamDetails : UITableViewController<JSONConnectDelegate, UIAlertViewDelegate>
@property Team *teamData;
@property enum TeamDetailsViewType viewType;
@property id<TeamMarketSelectionDelegate>delegate;
@property Message *message;
@end
