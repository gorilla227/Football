//
//  NewPlayer.h
//  Soccer
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPlayer_Cell : UITableViewCell<UIAlertViewDelegate, JSONConnectDelegate>
@property Message *message;
@property UserInfo *player;
@end

@interface NewPlayerTableView : TableViewController_More<JSONConnectDelegate>

@end

@interface NewPlayer : UIViewController<UIActionSheetDelegate, JSONConnectDelegate>

@end
