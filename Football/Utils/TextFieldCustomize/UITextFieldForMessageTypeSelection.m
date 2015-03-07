//
//  UITextFieldForMessageTypeSelection.m
//  Football
//
//  Created by Andy Xu on 15/3/5.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "UITextFieldForMessageTypeSelection.h"

@implementation UITextFieldForMessageTypeSelection {
    UIPickerView *messageTypePicker;
    NSArray *messageTypesList;
    NSDictionary *messageTypes;
    NSArray *selectedRowsInPickerView;
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [[messageTypesList objectAtIndex:row] objectForKey:@"TypeGroupName"];
        case 1:
            return [messageTypes objectForKey:[[[messageTypesList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:row]];
        default:
            return nil;
    }
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
//    [self setText:[NSString stringWithFormat:@"%@ - %@", [[messageTypesList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"TypeGroupName"], [messageTypes objectForKey:[[[messageTypesList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"Types"] objectAtIndex:[pickerView selectedRowInComponent:1]]]]];
}
@end
