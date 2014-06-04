//
//  Captain_TeamFundInquiry.h
//  Football
//
//  Created by Andy on 14-6-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_TeamFundInquiry_CollectionCell : UICollectionViewCell
@property IBOutlet UIImageView *playerIcon;
@property IBOutlet UILabel *playerName;
@end

@interface Captain_TeamFundInquiry_TableCell : UITableViewCell
@property IBOutlet UICollectionView *playerCollectionView;
@end

@interface Captain_TeamFundInquiry : UIViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property IBOutlet UISegmentedControl *playListType;
@property IBOutlet UITableView *paidPlayerTableView;
@property IBOutlet UICollectionView *unpaidPlayerCollectionView;
@end
