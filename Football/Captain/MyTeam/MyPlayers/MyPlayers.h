//
//  MyPlayers.h
//  Football
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyPlayerDelegate <NSObject>
-(void)pushPlayerDetails:(UserInfo *)player;
@end

@interface MyPlayerCell : UITableViewCell
@property UserInfo *myPlayer;
@property id<MyPlayerDelegate>delegate;
@end

@interface MyPlayers : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, JSONConnectDelegate, MyPlayerDelegate>

@end
