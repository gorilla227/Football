//
//  UITextFieldForMessageTypeSelection.m
//  Football
//
//  Created by Andy Xu on 15/3/5.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "UITextFieldForMessageTypeSelection.h"

@implementation UILabelForMessageTypePicker {
    UILabel *unreadMessageAmountLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextAlignment:NSTextAlignmentCenter];
        unreadMessageAmountLabel = [UILabel new];
        [unreadMessageAmountLabel setBackgroundColor:[UIColor redColor]];
        [unreadMessageAmountLabel setTextAlignment:NSTextAlignmentCenter];
        [unreadMessageAmountLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [unreadMessageAmountLabel setTextColor:[UIColor whiteColor]];
        [unreadMessageAmountLabel.layer setCornerRadius:self.bounds.size.height / 4];
        [unreadMessageAmountLabel.layer setMasksToBounds:YES];
        [self addSubview:unreadMessageAmountLabel];
    }
    return self;
}

- (void)configurePickerTitle:(NSString *)messageTypeName unreadMessages:(NSNumber *)unreadMessages isTypeGroup:(BOOL)isTypeGroup {
    [self setText:messageTypeName];
    [unreadMessageAmountLabel setText:unreadMessages.stringValue];
    if (unreadMessages && unreadMessages.integerValue == 0) {
        [unreadMessageAmountLabel setFrame:CGRectZero];
    }
    else {
        if (isTypeGroup) {
            [unreadMessageAmountLabel setFrame:CGRectMake(self.bounds.size.height / 2, self.bounds.size.height / 4, self.bounds.size.height / 2, self.bounds.size.height / 2)];
        }
        else {
            [unreadMessageAmountLabel setFrame:CGRectMake(self.bounds.size.width - self.bounds.size.height, self.bounds.size.height / 4, self.bounds.size.height / 2, self.bounds.size.height / 2)];
        }
    }
}

@end

@implementation UITextFieldForMessageTypeSelection {
    UIPickerView *messageTypePicker;
    NSArray *messageTypesList;
    NSDictionary *messageTypes;
    NSArray *selectedRowsInPickerView;
    BOOL shouldShowUnreadMessageAmount;
}
@synthesize messageTypesSelectionDelegate;

- (void)drawRect:(CGRect)rect {
    //Initial Picker
    messageTypePicker = [UIPickerView new];
    [messageTypePicker setDelegate:self];
    [messageTypePicker setDataSource:self];
    [messageTypePicker setShowsSelectionIndicator:YES];
    [self setInputView:messageTypePicker];
    [self setTintColor:[UIColor clearColor]];
    [self setDelegate:self];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, messageTypePicker.bounds.size.width, 30)];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButton_OnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundColor:[UIColor lightGrayColor]];
    [confirmButton setShowsTouchWhenHighlighted:YES];
    [confirmButton.layer setBorderColor:cLightBlue(1.0).CGColor];
    [confirmButton.layer setBorderWidth:1.0f];
    [self setInputAccessoryView:confirmButton];
}

- (void)initialMessageTypes:(NSInteger)boxType userType:(NSInteger)userType {
    messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes"];
    selectedRowsInPickerView = @[[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0]];
    
    NSString *keyForUserType;
    switch (userType) {
        case 0://Captain
            keyForUserType = @"UI_MessageTypes_ForCaptain";
            break;
        case 1://PlayerWithTeam
            keyForUserType = @"UI_MessageTypes_ForPlayerWithTeam";
            break;
        case 2://PlayerWithoutTeam
            keyForUserType = @"UI_MessageTypes_ForPlayerWithoutTeam";
            break;
        default:
            break;
    }
    
    if (keyForUserType) {
        messageTypesList = [[[gUIStrings objectForKey:keyForUserType] objectAtIndex:boxType] objectForKey:@"TypeGroups"];
        [self setText:[NSString stringWithFormat:@"%@ - %@", [[messageTypesList objectAtIndex:0] objectForKey:@"TypeGroupName"], [messageTypes objectForKey:[[[messageTypesList objectAtIndex:0] objectForKey:@"Types"] objectAtIndex:0]]]];
    }
    
    shouldShowUnreadMessageAmount = (boxType == 0);
    if (shouldShowUnreadMessageAmount) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadMessageAmount) name:@"MessageStatusUpdated" object:nil];
    }
}

- (void)refreshUnreadMessageAmount {
    [messageTypePicker reloadAllComponents];
}

- (NSString *)selectedMessageType {
    return [[[messageTypesList objectAtIndex:[messageTypePicker selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:[messageTypePicker selectedRowInComponent:1]];
}

- (IBAction)confirmButton_OnClicked:(id)sender {
    if ([messageTypePicker selectedRowInComponent:0] != [selectedRowsInPickerView[0] integerValue] || [messageTypePicker selectedRowInComponent:1] != [selectedRowsInPickerView[1] integerValue]) {
        selectedRowsInPickerView = @[[NSNumber numberWithInteger:[messageTypePicker selectedRowInComponent:0]], [NSNumber numberWithInteger:[messageTypePicker selectedRowInComponent:1]]];
        [messageTypesSelectionDelegate didSelectMessageType:[[[messageTypesList objectAtIndex:[messageTypePicker selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:[messageTypePicker selectedRowInComponent:1]]];
        [self setText:[NSString stringWithFormat:@"%@ - %@", [[messageTypesList objectAtIndex:[messageTypePicker selectedRowInComponent:0]] objectForKey:@"TypeGroupName"], [messageTypes objectForKey:[[[messageTypesList objectAtIndex:[messageTypePicker selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:[messageTypePicker selectedRowInComponent:1]]]]];
    }
    [self resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([messageTypePicker selectedRowInComponent:0] != [selectedRowsInPickerView[0] integerValue]) {
        [messageTypePicker selectRow:[selectedRowsInPickerView[0] integerValue] inComponent:0 animated:NO];
        [messageTypePicker reloadComponent:1];
    }
    if ([messageTypePicker selectedRowInComponent:1] != [selectedRowsInPickerView[1] integerValue]) {
        [messageTypePicker selectRow:[selectedRowsInPickerView[1] integerValue] inComponent:1 animated:NO];
    }
}

#pragma UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return messageTypesList.count;
        case 1:
            return [[[messageTypesList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"Types"] count];
        default:
            return 0;
    }
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    switch (component) {
//        case 0:
//            return [[messageTypesList objectAtIndex:row] objectForKey:@"TypeGroupName"];
//        case 1:
//            return [messageTypes objectForKey:[[[messageTypesList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:row]];
//        default:
//            return nil;
//    }
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabelForMessageTypePicker *titleLabel = (UILabelForMessageTypePicker *)view;
    if (!titleLabel) {
        titleLabel = [[UILabelForMessageTypePicker alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    
    if (shouldShowUnreadMessageAmount) {
        if (component == 0) {
            NSInteger unreadMessageAmount = 0;
            for (NSString *messageTypeId in [[messageTypesList objectAtIndex:row] objectForKey:@"Types"]) {
                unreadMessageAmount = unreadMessageAmount + [[gUnreadMessageAmount objectForKey:messageTypeId] integerValue];
            }
            [titleLabel configurePickerTitle:[[messageTypesList objectAtIndex:row] objectForKey:@"TypeGroupName"] unreadMessages:[NSNumber numberWithInteger:unreadMessageAmount] isTypeGroup:YES];
        }
        else {
            [titleLabel configurePickerTitle:[messageTypes objectForKey:[[[messageTypesList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:row]] unreadMessages:[gUnreadMessageAmount objectForKey:[[[messageTypesList objectAtIndex:[messageTypePicker selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:row]] isTypeGroup:NO];
        }
    }
    else {
        if (component == 0) {
            [titleLabel configurePickerTitle:[[messageTypesList objectAtIndex:row] objectForKey:@"TypeGroupName"] unreadMessages:[NSNumber numberWithInteger:0] isTypeGroup:YES];
        }
        else {
            [titleLabel configurePickerTitle:[messageTypes objectForKey:[[[messageTypesList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:row]] unreadMessages:[NSNumber numberWithInteger:0] isTypeGroup:NO];
        }
    }
    
    return titleLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            break;
        default:
            break;
    }
}
@end
