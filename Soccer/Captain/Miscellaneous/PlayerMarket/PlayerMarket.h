//
//  PlayerMarket.h
//  Soccer
//
//  Created by Andy on 14-8-25.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

enum PlayerMarketViewType {
    PlayerMarketViewType_Default,
    PlayerMarketViewType_FromMatchArrangement
};

@protocol PlayerMarketDelegate <NSObject>
-(void)pushPlayerDetails:(UserInfo *)player;
@end

@interface PlayerMarket_SearchView : UIView
-(NSDictionary *)searchCriteria;
@end

@interface PlayerMarket_Cell : UITableViewCell
@property UserInfo *playerInfo;
@property id<PlayerMarketDelegate>delegate;
@end

@interface PlayerMarket : TableViewController_More<JSONConnectDelegate, PlayerMarketDelegate>
@property enum PlayerMarketViewType viewType;
@property Match *matchData;
@end
