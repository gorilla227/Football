//
//  Captain_MatchArrangementListCell.h
//  Football
//
//  Created by Andy on 14-4-6.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_MatchArrangementListCell : UITableViewCell
@property IBOutlet UILabel *numberOfAcceptPlayers;
@property IBOutlet UIProgressView *progressOfAcceptPlayers;
@property IBOutlet UILabel *matchDate;
@property IBOutlet UILabel *matchTime;
@property IBOutlet UILabel *matchOpponent;
@property IBOutlet UILabel *matchPlace;
@property IBOutlet UILabel *matchType;
@property IBOutlet UIButton *noticePlayer;
@end
