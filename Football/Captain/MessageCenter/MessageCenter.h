//
//  MessageCenter.h
//  Football
//
//  Created by Andy on 14-8-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@end

@interface MessageCenter : UITableViewController<JSONConnectDelegate, MessageTypeSelectionDelegate>

@end
