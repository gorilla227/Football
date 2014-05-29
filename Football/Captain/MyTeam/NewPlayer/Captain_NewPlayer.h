//
//  Captain_NewPlayer.h
//  Football
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallFriends.h"
#import "Captain_PlayerDetails.h"

@interface Captain_NewPlayer_ApplicantCell : UITableViewCell<UIAlertViewDelegate>
@property IBOutlet UILabel *playerID;
@property IBOutlet UILabel *postion;
@property IBOutlet UILabel *age;
@property IBOutlet UILabel *team;
@property IBOutlet UITextView *comment;
@property IBOutlet UILabel *status;
@property IBOutlet UISegmentedControl *agreementSegment;
@end

@interface Captain_NewPlayer_InviteeCell : UITableViewCell<UIAlertViewDelegate>
@property IBOutlet UILabel *playerName;
@property IBOutlet UILabel *postion;
@property IBOutlet UILabel *age;
@property IBOutlet UILabel *team;
@property IBOutlet UITextView *comment;
@property IBOutlet UILabel *status;
@property IBOutlet UIButton *cancelInvitationButton;
@end

@interface Captain_NewPlayer : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property IBOutlet UITableView *playerNewTableView;
@end
