//
//  Captain_MatchArrangement.h
//  Soccer
//
//  Created by Andy on 14-3-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenu.h"
#import "Captain_CreateMatch.h"

@interface Captain_MatchArrangementListCell : UITableViewCell
@property BOOL announcable;
@property BOOL recordable;
@end

@interface Captain_MatchArrangement : UIViewController<JSONConnectDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
-(void)actionButtonOnClicked_announce:(UIButton *)sender;
-(void)actionButtonOnClicked_viewRecord:(UIButton *)sender;
-(void)actionButtonOnClicked_fillRecord:(UIButton *)sender;
@end