//
//  Captain_NotifyPlayers.h
//  Football
//
//  Created by Andy Xu on 14-5-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_NotifyPlayers_Cell : UITableViewCell
@property IBOutlet UIImageView *playerIcon;
@property IBOutlet UILabel *playerName;
@end

@interface Captain_NotifyPlayers : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property IBOutlet UITableView *playersTableView;
@property IBOutlet UITextView *notificationTextView;
@property IBOutlet UIBarButtonItem *sendNotificationButton;
@property IBOutlet UIButton *selectAllButton;
@property IBOutlet UIButton *unselectAllButton;
@property NSArray *playerList;
@end
