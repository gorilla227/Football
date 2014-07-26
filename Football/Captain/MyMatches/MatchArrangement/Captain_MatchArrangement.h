//
//  Captain_MatchArrangement.h
//  Football
//
//  Created by Andy on 14-3-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenu.h"
#import "Captain_CreateMatch.h"

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

@interface Captain_MatchArrangement : UIViewController<JSONConnectDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
-(void)actionButtonOnClicked_announce:(UIButton *)sender;
-(void)actionButtonOnClicked_viewRecord:(UIButton *)sender;
-(void)actionButtonOnClicked_fillRecord:(UIButton *)sender;
@end