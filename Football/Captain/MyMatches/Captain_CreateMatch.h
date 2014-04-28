//
//  Captain_CreateMatch.h
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pre_Define.h"
#import "HintTextView.h"
#import "Captain_CreateMatch_EnterOpponent.h"
#import "Captain_CreateMatch_SelectPlayground.h"

@interface Captain_CreateMatch_MatchScoreTableView_Cell : UITableViewCell
@property IBOutlet UILabel *goalPlayerName;
@property IBOutlet UILabel *assistPlayerName;
@end
@interface Captain_CreateMatch : UIViewController<UITextFieldDelegate, EnterOpponent, SelectOpponent, SelectPlayground, UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UITextField *matchTime, *matchOpponent, *matchPlace, *numOfPlayers, *cost;
@property IBOutlet UIView *costOptions;
@property IBOutlet UISwitch *costOption_Judge, *costOption_Water;
@property IBOutlet UIBarButtonItem *actionButton;
@property IBOutlet UIToolbar *toolBar;
//Controls for score
@property IBOutlet UITextField *matchScore;
@property IBOutlet UITableView *matchScoreTableView;
@property IBOutlet UIView *matchScoreTableViewHeader;
@property IBOutlet UILabel *matchScoreHeader_Goal;
@property IBOutlet UILabel *matchScoreHeader_Assist;

-(void)matchTimeSelected;
-(void)initialLeftViewForTextField:(UITextField *)textFieldNeedLeftView labelName:(NSString *)labelName iconImage:(NSString *)imageFileName;
-(void)initialMatchTime;
-(void)initialMatchOpponent;
-(void)initialMatchPlace;
-(void)initialNumOfPlayers;
-(void)initialCost;
-(void)initialMatchScore;
-(void)numberOfPlayersStepperChanged;
-(void)checkActionButtonStatus;
@end
