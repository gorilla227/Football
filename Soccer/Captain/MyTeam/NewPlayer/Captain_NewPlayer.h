//
//  Captain_NewPlayer.h
//  Soccer
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_NewPlayer_Cell : UITableViewCell<UIAlertViewDelegate, JSONConnectDelegate>
@property Message *message;
@property UserInfo *player;
@property UINavigationController *navigationController;
@end

@interface Captain_NewPlayer : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, JSONConnectDelegate>
-(void)refreshTableView;
@end
