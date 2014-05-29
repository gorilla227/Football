//
//  Captain_PlayerMarket.h
//  Football
//
//  Created by Andy Xu on 14-5-29.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_PlayerDetails.h"

@interface Captain_PlayerMarket_Cell : UITableViewCell
@property IBOutlet UIImageView *playerIcon;
@property IBOutlet UILabel *nickName;
@property IBOutlet UILabel *playerRole;
@property IBOutlet UILabel *age;
@property IBOutlet UILabel *teamName;
@end

@interface Captain_PlayerMarket : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UITableView *playerMarketTableView;
@end
