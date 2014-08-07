//
//  MessageCenter.h
//  Football
//
//  Created by Andy on 14-8-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MessageBodyFormat_Receiver(sender, date) [NSString stringWithFormat:@"发送者：%@ 发送时间：%@", sender, date]
#define MessageBodyFormat_Sender(receiver, date) [NSString stringWithFormat:@"接收者：%@ 发送时间：%@", receiver, date]

@interface MessageCell : UITableViewCell
@end

@interface MessageCenter : UITableViewController<JSONConnectDelegate>

@end
