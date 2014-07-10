//
//  Captain_PlayerMarket.h
//  Football
//
//  Created by Andy Xu on 14-5-29.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_PlayerDetails.h"
@protocol PlayerMarketCellDelegate <NSObject>
-(void)showPlayerDetails:(NSInteger)index;
@end

@interface Captain_PlayerMarket_Cell : UITableViewCell
@property IBOutlet UIImageView *playerPortrait;
@property IBOutlet UILabel *nickName;
@property IBOutlet UILabel *playerRole;
@property IBOutlet UILabel *age;
@property id<PlayerMarketCellDelegate>delegate;
@end

@interface Captain_PlayerMarket : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, PlayerMarketCellDelegate>
@property IBOutlet UITableView *playerMarketTableView;
@property IBOutlet UIBarButtonItem *recruitButton;
@property IBOutlet UIBarButtonItem *temporaryButton;
@end
