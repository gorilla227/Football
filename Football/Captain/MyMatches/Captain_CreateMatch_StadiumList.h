//
//  Captain_CreateMatch_StadiumList.h
//  Football
//
//  Created by Andy on 14-5-7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectStadium <NSObject>
-(void)notSelectStadium;
-(void)stadiumSelected:(Stadium *)selectedStadium;
@end

@interface Captain_CreateMatch_StadiumList_Cell : UITableViewCell
@property IBOutlet UILabel *stadiumName;
@property IBOutlet UILabel *phoneNumber;
@property IBOutlet UIButton *phoneIcon;
@end

@interface Captain_CreateMatch_StadiumList : UIViewController<UITableViewDataSource, UITableViewDelegate, JSONConnectDelegate, UISearchDisplayDelegate>
@property IBOutlet UITableView *stadiumTable;
@property id<SelectStadium>delegate;
@end
