//
//  Captain_MyPlayers.h
//  Football
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captain_PlayerDetails.h"
#import "Captain_NotifyPlayers.h"

@interface Captain_MyPlayerCell : UITableViewCell

@end

@interface Captain_MyPlayers : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, JSONConnectDelegate>

@end
