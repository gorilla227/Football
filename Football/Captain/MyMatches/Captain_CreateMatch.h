//
//  Captain_CreateMatch.h
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pre_Define.h"
#import "TintTextView.h"

@interface Captain_CreateMatch : UIViewController<UITextFieldDelegate>
@property IBOutlet UITextField *matchTime, *matchOpponent, *matchPlace, *numOfPlayers, *cost;
@property IBOutlet UIView *costOptions;
@property IBOutlet UISwitch *costOption_Judge, *costOption_Water;
-(void)matchTimeSelected;
-(void)initialLeftViewForTextField:(UITextField *)textFieldNeedLeftView labelName:(NSString *)labelName iconImage:(NSString *)imageFileName;
-(void)initialMatchTime;
-(void)initialMatchOpponent;
-(void)initialMatchPlace;
-(void)initialNumOfPlayers;
-(void)initialCost;
@end
