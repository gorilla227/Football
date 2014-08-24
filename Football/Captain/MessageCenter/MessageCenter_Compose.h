//
//  MessageCenter_Compose.h
//  Football
//
//  Created by Andy Xu on 14-8-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MessageComposeType
{
    MessageComposeType_Blank,
    MessageComposeType_Trial
};

@interface MessageCenter_Compose : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property enum MessageComposeType composeType;
@property NSArray *playerList;

-(void)updateButtonsStatus;
-(void)updateSendNotificationButtonStatus;
-(void)updateSelectionButtonStatus;
-(void)presetNotification;
@end
