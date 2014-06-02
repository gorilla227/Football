//
//  Captain_EnterBalance.h
//  Football
//
//  Created by Andy on 14-5-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_EnterBalance : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property IBOutlet UISegmentedControl *balanceTypeSegment;
@property IBOutlet UIView *playerListHeader;
@property IBOutlet UITableView *playerListTableView;
@property IBOutlet UIView *teamFundView;
@property IBOutlet UILabel *totalPlayers;
@property IBOutlet UILabel *totalTeamFund;
@property IBOutlet UITextField *balanceName;
@property IBOutlet UITextField *balanceDate;
@property IBOutlet UITextField *balanceAmount;

-(void)calculateTotal;
-(void)balanceDateSelected;
-(void)initialBalanceDate;
-(void)initialBalanceAmount;
-(void)initialBalanceName;
-(void)initialLeftViewForTextField:(UITextField *)textFieldNeedLeftView labelName:(NSString *)labelName iconImage:(NSString *)imageFileName;
@end
