//
//  Captain_CreateMatch_EnterOpponent.h
//  Football
//
//  Created by Andy on 14-4-21.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HintTextView.h"
#import "Captain_CreateMatch_TeamMarket.h"

@protocol EnterOpponent <NSObject>
-(void)receiveOpponent:(NSString *)opponentName opponentExisted:(BOOL)existed;
@end

@interface Captain_CreateMatch_EnterOpponent : UIViewController
@property id<EnterOpponent>delegate;
@property BOOL matchStarted;
@property IBOutlet UIToolbar *toolBar;
@property IBOutlet UIBarButtonItem *inviteOpponentButton;
@property IBOutlet UIBarButtonItem *teamMarketButton;
@property IBOutlet UITextField *matchOpponent;
@property IBOutlet UIBarButtonItem *saveButton;

@end
