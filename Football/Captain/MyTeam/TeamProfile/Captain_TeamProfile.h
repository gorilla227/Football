//
//  Captain_TeamProfile.h
//  Football
//
//  Created by Andy on 14-4-6.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_TeamProfile : UIViewController
@property IBOutlet UIImageView *teamLogo;
@property IBOutlet UILabel *teamName;
@property IBOutlet UILabel *averageAge;
@property IBOutlet UILabel *activityRegion;
@property IBOutlet UITextView *pronouncement;
@property IBOutlet UIImageView *qqTwoDimensionalCode;
@property IBOutlet UIImageView *wechatTwoDimensionalCode;
@property IBOutlet UISwitch *recruitSwitch;
@property IBOutlet UITextView *recruitComment;
@property IBOutlet UILabel *totalMatches;
@property IBOutlet UILabel *winMatchesAndRate;
@property IBOutlet UILabel *totalGoal;
@property IBOutlet UILabel *totalLost;
@end
