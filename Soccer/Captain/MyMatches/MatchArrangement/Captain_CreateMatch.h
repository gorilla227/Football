//
//  Captain_CreateMatch.h
//  Soccer
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HintTextView.h"
#import "Captain_CreateMatch_EnterOpponent.h"
#import "Captain_CreateMatch_SelectMatchStadium.h"
#import "Captain_CreateMatch_EnterScore.h"

@interface Captain_CreateMatch_MatchScoreTableView_Cell : UITableViewCell
@property IBOutlet UILabel *goalPlayerName;
@property IBOutlet UILabel *assistPlayerName;
@end

@interface Captain_CreateMatch : UIViewController<UITextFieldDelegate, EnterOpponent, SelectOpponent, SelectMatchPlace, EnterScore, UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UITextField *matchTime, *matchOpponent, *matchPlace, *numOfPlayers, *cost;
@property IBOutlet UIView *costOptions;
@property IBOutlet UISwitch *costOption_Judge, *costOption_Water;
@property IBOutlet UIBarButtonItem *actionButton;
@property IBOutlet UIToolbar *toolBar;
//Controls for score
@property IBOutlet UITextField *matchScoreTextField;
@property IBOutlet UITableView *matchScoreTableView;
@property IBOutlet UIView *matchScoreTableViewHeader;
@property IBOutlet UILabel *matchScoreHeader_Goal;
@property IBOutlet UILabel *matchScoreHeader_Assist;
//Variable for view/fill record
@property Match *viewMatchData;
@property NSString *segueIdentifier;

-(void)matchTimeSelected;
//-(void)initialLeftViewForTextField:(UITextField *)textFieldNeedLeftView labelName:(NSString *)labelName iconImage:(NSString *)imageFileName;
-(void)initialMatchTime;
-(void)initialMatchOpponent;
-(void)initialMatchPlace;
-(void)initialNumOfPlayers;
-(void)initialCost;
-(void)initialMatchScore;
-(void)numberOfPlayersStepperChanged;
-(void)checkActionButtonStatus;
-(void)initialCreateMatchView;
-(void)initialViewRecordView;
-(void)initialFillRecordView;
@end
