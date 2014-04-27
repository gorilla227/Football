//
//  Captain_CreateMatch_SelectPlayground.h
//  Football
//
//  Created by Andy on 14-4-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HintTextView.h"

@interface Captain_CreateMatch_SelectPlayground : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UITableView *mainPlayground;
@property IBOutlet UITextField *matchPlaceTextField;
@end
