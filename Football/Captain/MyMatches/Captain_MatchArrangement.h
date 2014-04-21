//
//  Captain_MatchArrangement.h
//  Football
//
//  Created by Andy on 14-3-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pre_Define.h"
#import "WebUtils.h"
#import "Captain_MainMenu.h"

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
@property BOOL announcable;
@property BOOL recordable;
@end

@interface Captain_MatchArrangementList : UITableViewController<WebUtilsDelegate, UIAlertViewDelegate>
-(void)matchesListDataReceived:(NSData *)data;
@end

@interface Captain_MatchArrangement : UIViewController
@property IBOutlet UIImageView *teamIcon;
@property IBOutlet UILabel *teamName;
@property IBOutlet UILabel *numberOfTeamMembers;
@end