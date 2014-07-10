//
//  Captain_TeamFundInquiry.h
//  Football
//
//  Created by Andy on 14-6-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_PlayerDetails.h"
#import "Captain_NotifyPlayers.h"

@interface Captain_TeamFundInquiry_CollectionCell : UICollectionViewCell
@property IBOutlet UIImageView *playerPortrait;
@property IBOutlet UILabel *playerName;
@end

@interface Captain_TeamFundInquiry_TableCell : UITableViewCell
@property IBOutlet UICollectionView *playerCollectionView;
@end

@interface Captain_TeamFundInquiry : UIViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property IBOutlet UISegmentedControl *playListType;
@property IBOutlet UITextField *startDateTextField;
@property IBOutlet UITextField *endDateTextField;
@property IBOutlet UITableView *paidPlayerTableView;
@property IBOutlet UICollectionView *unpaidPlayerCollectionView;
@property IBOutlet UIBarButtonItem *notifyUnpaidPlayers;

-(void)initialStartDate;
-(void)initialEndDate;
@end
