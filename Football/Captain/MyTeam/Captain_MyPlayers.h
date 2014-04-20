//
//  Captain_MyPlayers.h
//  Football
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_MainMenu.h"

@interface Captain_MyPlayerCell : UITableViewCell
@property IBOutlet UIImageView *playerIcon;
@property IBOutlet UILabel *playerName;
@property IBOutlet UILabel *signUpStatusOfNextMatch;
@property IBOutlet UILabel *signUpTitleOfLeague;
@property IBOutlet UILabel *signUpStatusOfLeague;
@property IBOutlet UILabel *likeScore;
@end

@interface Captain_MyPlayers : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@end
