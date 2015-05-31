//
//  TableViewCell_CheckMark.h
//  Soccer
//
//  Created by Andy on 15/5/28.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell_CheckMark : UITableViewCell
- (void)changeCheckMarkStatus:(BOOL)status;
- (void)shouldHiddenCheckMarkBackground:(BOOL)shouldHidden;
@end
