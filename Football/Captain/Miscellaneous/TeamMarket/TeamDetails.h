//
//  TeamDetails.h
//  Football
//
//  Created by Andy Xu on 14/10/29.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
enum TeamDetailsViewType {
    TeamDetailsViewTypeViewType_Default,
    TeamDetailsViewTypeViewType_CreateMatch
};

@protocol TeamMarketSelectionDelegate <NSObject>
-(void)selectedOpponentTeam:(Team *)selectedTeam;
@end

@interface TeamDetails : UITableViewController<JSONConnectDelegate>
@property Team *teamData;
@property enum TeamDetailsViewType viewType;
@property id<TeamMarketSelectionDelegate>delegate;
@end
