//
//  Captain_TeamFundInquiry.h
//  Football
//
//  Created by Andy on 14-6-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Captain_TeamFundInquiry_Cell : UITableViewCell
@property IBOutlet UIScrollView *playerScrollView;
@end

@interface Captain_TeamFundInquiry : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UITableView *teamFundTableView;
@end
