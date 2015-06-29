//
//  BalanceTransactionDetails.h
//  Soccer
//
//  Created by Andy on 15/4/9.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
enum BalanceTransactionDetailsViewType {
    BalanceTransactionDetailsViewType_Add,
    BalanceTransactionDetailsViewType_View
};

@interface BalanceTransactionDetails_StatCell : UITableViewCell

@end

@interface BalanceTransactionDetails : UITableViewController<UITextFieldDelegate, UIAlertViewDelegate, JSONConnectDelegate>
@property enum BalanceTransactionDetailsViewType viewType;
@property BalanceTransaction *transaction;
@property NSArray *playerList;
@end
