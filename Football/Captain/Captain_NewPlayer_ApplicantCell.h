//
//  Captain_NewPlayer_ApplicantCell.h
//  Football
//
//  Created by Andy on 14-4-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_NewPlayer_ApplicantCell : UITableViewCell<UIAlertViewDelegate>
@property IBOutlet UILabel *playerID;
@property IBOutlet UILabel *postion;
@property IBOutlet UILabel *age;
@property IBOutlet UILabel *team;
@property IBOutlet UITextView *comment;
@property IBOutlet UILabel *status;
@property IBOutlet UISegmentedControl *agreementSegment;
@end
