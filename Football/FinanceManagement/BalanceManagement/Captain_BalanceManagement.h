//
//  Captain_BalanceManagement.h
//  Football
//
//  Created by Andy Xu on 14-5-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_BalanceManagement_Cell : UITableViewCell
@property IBOutlet UILabel *balanceType;
@property IBOutlet UILabel *balanceName;
@property IBOutlet UILabel *balanceDate;
@property IBOutlet UILabel *balanceAmount;
@end

@interface Captain_BalanceManagement : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UIBarButtonItem *addBalanceRecordButton;
@property IBOutlet UIImageView *teamIcon;
@property IBOutlet UITableView *balanceTableView;
@property IBOutlet UIView *balanceTableViewHeaderView;
-(void)drawLineForHeaderView;
@end
