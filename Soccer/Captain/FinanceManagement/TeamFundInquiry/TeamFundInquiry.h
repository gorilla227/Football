//
//  TeamFundInquiry.h
//  Soccer
//
//  Created by Andy on 15/4/17.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamFundInquiry_CollectionViewCell : UICollectionViewCell
@property IBOutlet UIImageView *ivPlayerPortrait;
@property IBOutlet UILabel *lbPlayerName;
@end

@interface TeamFundInquiry_TableViewCell : UITableViewCell
@property IBOutlet UICollectionView *playerCollectionView;
@end

@interface TeamFundInquiry : UITableViewController<UICollectionViewDataSource, UICollectionViewDelegate, JSONConnectDelegate>
@property IBOutlet UITextField *tfStartDate;
@property IBOutlet UITextField *tfEndDate;
@property IBOutlet UIButton *btnSearch;
@property IBOutlet UISegmentedControl *scPlayerList;
@property IBOutlet UIToolbar *tbNotice;
@property IBOutlet UIBarButtonItem *btnNotice;
@property IBOutlet UILabel *lbNoRecord;
@end
