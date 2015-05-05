//
//  StadiumDetails.h
//  Soccer
//
//  Created by Andy Xu on 14-7-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StadiumDetails : UITableViewController<UIAlertViewDelegate, JSONConnectDelegate>
@property Stadium *stadium;
-(void)actionButtonInitialization;
@end
