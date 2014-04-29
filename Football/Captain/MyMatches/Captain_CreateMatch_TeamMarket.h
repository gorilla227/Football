//
//  Captain_CreateMatch_TeamMarket.h
//  Football
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectOpponent <NSObject>
-(void)receiveSelectedOpponent:(NSDictionary *)opponentTeam;
@end

@interface Captain_CreateMatch_TeamMarket_Cell : UITableViewCell
@property IBOutlet UILabel *teamName;
@property IBOutlet UILabel *averAge;
@property IBOutlet UILabel *slogan;
@property IBOutlet UIImageView *teamLogo;
@property IBOutlet UIButton *inviteButton;
@end

@interface Captain_CreateMatch_TeamMarket : UITableViewController<WebUtilsDelegate, UISearchDisplayDelegate>
@property id<SelectOpponent>delegate;
@property NSDictionary *selectedTeam;

-(void)teamListDataReceived:(NSData *)data;
@end
