//
//  Captain_CreateMatch_StadiumList.h
//  Football
//
//  Created by Andy on 14-5-7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_CreateMatch_StadiumList : UIViewController<UITableViewDataSource, UITableViewDelegate, JSONConnectDelegate>
@property IBOutlet UITableView *stadiumTable;
@end
