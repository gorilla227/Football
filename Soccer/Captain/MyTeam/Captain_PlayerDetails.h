//
//  Captain_PlayerDetails.h
//  Soccer
//
//  Created by Andy Xu on 14-5-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_NotifyPlayers.h"
#import "PlayerDetails.h"
@interface Captain_PlayerDetails : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UITableView *playerDetailsTableView;
@property IBOutlet UIView *summaryView;
@property IBOutlet UITextView *playerCommentTextView;
@property IBOutlet UIToolbar *actionToolBar;
@property IBOutlet UILabel *nickNameTitle;
@property IBOutlet UILabel *nickName;
@property IBOutlet UILabel *playerNameTitle;
@property IBOutlet UILabel *playerName;
@property IBOutlet UILabel *nextMatchStatusTitle;
@property IBOutlet UILabel *nextMatchStatus;
@property IBOutlet UILabel *playerTeamTitle;
@property IBOutlet UILabel *playerTeam;
@property IBOutlet UIBarButtonItem *notifyTrialButton;
@property IBOutlet UIBarButtonItem *agreeButton;
@property IBOutlet UIBarButtonItem *declineButton;
@property IBOutlet UIBarButtonItem *recruitButton;
@property IBOutlet UIBarButtonItem *temporaryButton;

@property enum PlayerDetails_ViewTypes viewType;
@property BOOL hasTeam;

-(void)initialViewForMyPlayer;
-(void)initialViewForApplicant;
-(void)initialViewForPlayerMarket;
@end
