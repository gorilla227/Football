//
//  BalanceManagement.h
//  Football
//
//  Created by Andy Xu on 14-5-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceTransactionDetails.h"
#import "Captain_EnterBalance.h"

@protocol SelectBalanceTransactionDelegate <NSObject>
- (void)showTransaction:(BalanceTransaction *)transaction;
@end

@interface BalanceManagement_Cell : UITableViewCell
@property IBOutlet UILabel *balanceType;
@property IBOutlet UILabel *balanceName;
@property IBOutlet UILabel *balanceDate;
@property IBOutlet UILabel *balanceAmount;
@end

@interface BalanceManagementTableView : TableViewController_More <JSONConnectDelegate>
@property id<SelectBalanceTransactionDelegate>delegateOfSelectTransaction;
@end

@interface BalanceManagement : UIViewController<SelectBalanceTransactionDelegate, JSONConnectDelegate>
@property IBOutlet UIImageView *teamLogo;
@property IBOutlet UILabel *lbTeamBalance;
@property IBOutlet UIToolbar *actionBar;
@end
