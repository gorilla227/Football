//
//  Captain_CreateMatch_EnterOpponent.h
//  Football
//
//  Created by Andy on 14-4-21.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pre_Define.h"
#import "HintTextView.h"
#import "Captain_CreateMatch_TeamMarket.h"

@protocol EnterOpponent <NSObject>
-(void)receiveNewOpponent:(NSString *)opponentName;
@end

@interface Captain_CreateMatch_EnterOpponent : UIViewController<UIActionSheetDelegate>
@property id<EnterOpponent>delegate;
@property BOOL matchStarted;
@property enum SelectedOpponentType type;
@property NSString *selectedTeamName;
@property IBOutlet UIToolbar *toolBar;
@property IBOutlet UIBarButtonItem *inviteOpponentButton;
@property IBOutlet UIBarButtonItem *teamMarketButton;
@property IBOutlet UITextField *matchOpponent;
@property IBOutlet UIBarButtonItem *saveButton;

@end
