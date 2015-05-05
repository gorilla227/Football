//
//  Captain_CreateMatch_StadiumList.h
//  Soccer
//
//  Created by Andy on 14-5-7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Captain_CreateMatch_StadiumList;

@protocol SelectStadium <NSObject>
-(void)notSelectStadium:(Captain_CreateMatch_StadiumList *)sender;
-(void)stadiumSelected:(Stadium *)selectedStadium;
@end

@interface Captain_CreateMatch_StadiumList_Cell : UITableViewCell
@property IBOutlet UILabel *stadiumName;
@property IBOutlet UILabel *phoneNumber;
@property IBOutlet UIButton *phoneIcon;
@end

@interface Captain_CreateMatch_StadiumList : UITableViewController<JSONConnectDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
@property id<SelectStadium>delegate;
@end

@interface Captain_CreateMatch_StadiumList_Base : UIViewController
@property id<SelectStadium>delegate;
@end