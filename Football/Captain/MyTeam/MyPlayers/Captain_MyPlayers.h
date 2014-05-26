//
//  Captain_MyPlayers.h
//  Football
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_MyPlayerCell : UITableViewCell
@property IBOutlet UIImageView *playerIcon;
@property IBOutlet UILabel *playerName;
@property IBOutlet UILabel *signUpStatusOfNextMatch;
@property IBOutlet UIView *likeView;
@property IBOutlet UIImageView *likeIcon;
@property IBOutlet UILabel *likeScore;
@property IBOutlet UIButton *actionButton;
@end

@interface Captain_MyPlayers : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>
@property IBOutlet UITableView *playersTableView;
@end
