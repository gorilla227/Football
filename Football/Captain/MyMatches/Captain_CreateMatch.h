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

@interface Captain_CreateMatch : UIViewController<UITextFieldDelegate, EnterOpponent, SelectOpponent, SelectPlayground>
@property IBOutlet UITextField *matchTime, *matchOpponent, *matchPlace, *numOfPlayers, *cost;
@property IBOutlet UIView *costOptions;
@property IBOutlet UISwitch *costOption_Judge, *costOption_Water;
@property IBOutlet UIBarButtonItem *actionButton;
@property IBOutlet UIToolbar *toolBar;
-(void)matchTimeSelected;
-(void)initialLeftViewForTextField:(UITextField *)textFieldNeedLeftView labelName:(NSString *)labelName iconImage:(NSString *)imageFileName;
-(void)initialMatchTime;
-(void)initialMatchOpponent;
-(void)initialMatchPlace;
-(void)initialNumOfPlayers;
-(void)initialCost;
-(void)numberOfPlayersStepperChanged;
@end
