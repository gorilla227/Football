//
//  Captain_NewPlayer.h
//  Football
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallFriends.h"
#import "Captain_PlayerDetails.h"

@interface Captain_NewPlayer_ApplyinCell : UITableViewCell<UIAlertViewDelegate>

@end

@interface Captain_NewPlayer_CallinCell : UITableViewCell<UIAlertViewDelegate>

@end

@interface Captain_NewPlayer : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, JSONConnectDelegate>

@end
