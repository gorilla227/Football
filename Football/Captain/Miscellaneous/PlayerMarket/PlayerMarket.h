//
//  PlayerMarket.h
//  Football
//
//  Created by Andy on 14-8-25.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerMarket_SearchView : UIView
-(NSDictionary *)searchCriteria;
@end

@interface PlayerMarket_Cell : UITableViewCell
@property UserInfo *playerInfo;
@end

@interface PlayerMarket : UITableViewController<JSONConnectDelegate>

@end
