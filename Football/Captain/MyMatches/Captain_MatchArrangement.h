//
//  Captain_MatchArrangement.h
//  Football
//
//  Created by Andy on 14-3-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebUtils.h"

@interface Captain_TeamInfo : UIViewController
@property IBOutlet UIImageView *teamIcon;
@property IBOutlet UILabel *teamName;
@property IBOutlet UILabel *numberOfTeamMembers;
@end

@interface Captain_MatchArrangementListCell : UITableViewCell
@property IBOutlet UILabel *numberOfPlayers;
@property IBOutlet UILabel *typeOfPlayerNumber;
@property IBOutlet UILabel *matchDate;
@property IBOutlet UILabel *matchTime;
@property IBOutlet UILabel *matchOpponent;
@property IBOutlet UILabel *matchPlace;
@property IBOutlet UILabel *matchType;
@property IBOutlet UIImageView *actionIcon;
@property IBOutlet UIButton *actionButton;
@property IBOutlet UILabel *matchResult;
@end

@interface Captain_MatchArrangementList : UITableViewController<DataReady>
-(void)refreshData;
@end

@interface Captain_MatchArrangement : UIViewController
@property IBOutlet UIView *teamInfoView;
@property IBOutlet UIView *matchesView;
@end
