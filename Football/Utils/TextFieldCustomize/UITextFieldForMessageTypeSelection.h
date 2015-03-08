//
//  UITextFieldForMessageTypeSelection.h
//  Football
//
//  Created by Andy Xu on 15/3/5.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageTypeSelectionDelegate <NSObject>
- (void)didSelectMessageType:(NSString *)messageTypeId;
@end

@interface UILabelForMessageTypePicker : UILabel
- (void)configurePickerTitle:(NSString *)messageTypeName unreadMessages:(NSNumber *)unreadMessages isTypeGroup:(BOOL)isTypeGroup;
@end

@interface UITextFieldForMessageTypeSelection : UITextField <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property IBOutlet id<MessageTypeSelectionDelegate>messageTypesSelectionDelegate;
- (void)initialMessageTypes:(NSInteger)boxType userType:(NSInteger)userType;//boxType: 0-Inbox 1-Outbox; userType: 0-Captain 1-PlayerWithTeam 2-PlayerWithoutTeam
- (NSString *)selectedMessageType;
@end
