//
//  TeamMarket.h
//  Football
//
//  Created by Andy on 14-10-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TeamMarket_SearchView : UIView
@property NSInteger flag;
-(NSDictionary *)searchCriteria;
@end

@interface TeamMarket_Cell : UITableViewCell

@end

@interface TeamMarket : UITableViewController<JSONConnectDelegate>

@end