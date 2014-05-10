//
//  Captain_CreateMatch_EnterScore.h
//  Football
//
//  Created by Andy Xu on 14-5-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HintTextView.h"

@protocol EnterScore <NSObject>
-(void)receiveScore:(MatchScore *)score;
@end

@interface Captain_CreateMatch_EnterScoreTableView_Cell : UITableViewCell<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property IBOutlet UITextField *goalPlayerName;
@property IBOutlet UITextField *assistPlayerName;
@property NSArray *playersCandidateList;
@end

@interface Captain_CreateMatch_EnterScore : UIViewController<UITableViewDataSource, UITableViewDelegate, JSONConnectDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property id<EnterScore>delegate;
@property IBOutlet UIView *summaryView;
@property IBOutlet UILabel *homeTeamLabel;
@property IBOutlet UILabel *awayTeamLabel;
@property IBOutlet UITextField *homeTeamScoreTextField;
@property IBOutlet UITextField *awayTeamScoreTextField;
@property IBOutlet UITableView *scoreDetailsTableView;
@property MatchScore *matchScore;
@end
