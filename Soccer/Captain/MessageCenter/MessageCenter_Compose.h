//
//  MessageCenter_Compose.h
//  Soccer
//
//  Created by Andy Xu on 14-8-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

enum MessageComposeType
{
    MessageComposeType_Blank,
    MessageComposeType_Trial,
    MessageComposeType_Recurit,
    MessageComposeType_TemporaryFavor,
    MessageComposeType_Applyin,
    MessageComposeType_MatchNotice,
    MessageComposeType_TeamFundNotice
};

@interface MessageCenter_Compose : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, JSONConnectDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property enum MessageComposeType composeType;
@property NSArray *toList;
@property NSDictionary *otherParameters;
@property UIViewController *viewControllerAfterSending;

-(void)updateButtonsStatus;
-(void)updateSendNotificationButtonStatus;
-(void)updateSelectionButtonStatus;
-(void)presetNotification;
-(void)selectAllInToList;
-(void)unselectAllInToList;
-(void)composeSent:(NSString *)alertMessageKey;
-(void)updateMessageProgress:(BOOL)messageResult;
@end
