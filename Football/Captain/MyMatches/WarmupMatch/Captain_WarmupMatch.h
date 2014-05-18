//
//  Captain_WarmupMatch.h
//  Football
//
//  Created by Andy Xu on 14-5-17.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageConvert.h"

@interface Captain_WarmupMatch_Cell : UITableViewCell
@property IBOutlet UIImageView *opponentTeamIcon;
@property IBOutlet UILabel *invitationStatusText;
@property IBOutlet UIView *invitationStatusBackgroundView;
@property IBOutlet UILabel *matchPlace;
@property IBOutlet UILabel *matchDate;
@property IBOutlet UILabel *matchTime;
@property IBOutlet UILabel *matchCost;
@property IBOutlet UILabel *matchType;
@property IBOutlet UIView *actionView_beInvited;
@property IBOutlet UIView *actionView_invitationAccepted;
@property IBOutlet UIView *actionView_invitationRejected;
@property IBOutlet UILabel *beInvited;
@property IBOutlet UIButton *acceptInvitation;
@property IBOutlet UIButton *rejectInvitation;
@property IBOutlet UIImageView *stamp_cancelled;
@property IBOutlet UIImageView *stamp_rejected;
@property IBOutlet UITextView *acceptOrRejectInvitationTextView;
@property IBOutlet UIView *invitationDetailsView;
@end

@interface Captain_WarmupMatch : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UIView *announcementBar;
@property IBOutlet UITableView *invitaionTableView;
@property IBOutlet UITextView *announcementTextView;
@end
