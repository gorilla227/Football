//
//  UITextFieldForActivityRegion.m
//  Soccer
//
//  Created by Andy Xu on 14-6-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "UITextFieldForActivityRegion.h"

@implementation UITextFieldForActivityRegion{
    NSArray *locationList;
    ActivityRegionPicker *locationPicker;
}
@synthesize selectedActivityRegionCode;

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.

- (void)awakeFromNib {
    //Load ActivityRegions.json
    NSString *fileString = [[NSBundle mainBundle] pathForResource:@"ActivityRegions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fileString];
    locationList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    locationPicker = [[ActivityRegionPicker alloc] init];
    [locationPicker setDelegate:self];
    [locationPicker setDataSource:self];
    [self setInputView:locationPicker];
}

- (void)presetActivityRegionCode:(NSArray *)activityRegionCode {
    NSMutableString *regionString;
    selectedActivityRegionCode = activityRegionCode;
    NSMutableArray *selectedRows;
    for (NSDictionary *province in locationList) {
        if ([[province objectForKey:@"id"] isEqualToString:selectedActivityRegionCode[0]]) {
            regionString = [[NSMutableString alloc] initWithString:[province objectForKey:@"name"]];
            selectedRows = [NSMutableArray arrayWithObject:[NSNumber numberWithInteger:[locationList indexOfObject:province] + 1]];
            if (selectedActivityRegionCode.count > 1) {
                for (NSDictionary *city in [province objectForKey:@"city"]) {
                    if ([[city objectForKey:@"id"] isEqualToString:selectedActivityRegionCode[1]]) {
                        [regionString appendString:[NSString stringWithFormat:@" %@", [city objectForKey:@"name"]]];
                        [selectedRows addObject:[NSNumber numberWithInteger:[[province objectForKey:@"city"] indexOfObject:city] + 1]];
                        if (selectedActivityRegionCode.count > 2) {
                            for (NSDictionary *district in [city objectForKey:@"district"]) {
                                if ([[district objectForKey:@"id"] isEqualToString:selectedActivityRegionCode[2]]) {
                                    [regionString appendString:[NSString stringWithFormat:@" %@", [district objectForKey:@"name"]]];
                                    [selectedRows addObject:[NSNumber numberWithInteger:[[city objectForKey:@"district"] indexOfObject:district] + 1]];
                                    break;
                                }
                            }
                        }
                        else {
                            [selectedRows addObject:[NSNumber numberWithInteger:0]];
                        }
                        break;
                    }
                }
            }
            else {
                [selectedRows addObjectsFromArray:@[[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0]]];
            }
            break;
        }
    }
    [self setText:regionString];
    [locationPicker setSelectedRows:selectedRows];
    for (NSNumber *selectedRow in selectedRows) {
        if ([locationPicker selectedRowInComponent:[selectedRows indexOfObject:selectedRow]] != selectedRow.integerValue) {
            [locationPicker drawRect:locationPicker.bounds];
            break;
        }
    }
}

#pragma UIPickerView Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return locationList.count + 1;
        case 1:
            if ([pickerView selectedRowInComponent:0] == 0) {
                return 1;
            }
            else {
                return [[[locationList objectAtIndex:[pickerView selectedRowInComponent:0] - 1] objectForKey:@"city"] count] + 1;
            }
        case 2:
            if ([pickerView selectedRowInComponent:1] == 0) {
                return 1;
            }
            else {
                return [[[[[locationList objectAtIndex:[pickerView selectedRowInComponent:0] - 1] objectForKey:@"city"] objectAtIndex:[pickerView selectedRowInComponent:1] - 1] objectForKey:@"district"] count] + 1;
            }
        default:
            return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        case 1:
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        default:
            break;
    }
    
    NSMutableArray *code = [NSMutableArray new];
    if ([locationPicker selectedRowInComponent:0] != 0) {
        NSString *province = [[locationList objectAtIndex:[locationPicker selectedRowInComponent:0] - 1] objectForKey:@"name"];
        [code addObject:[[locationList objectAtIndex:[locationPicker selectedRowInComponent:0] - 1] objectForKey:@"id"]];
        [self setText:[NSString stringWithFormat:@"%@", province?province:@""]];
        if ([locationPicker selectedRowInComponent:1] != 0) {
            NSString *city = [[[[locationList objectAtIndex:[locationPicker selectedRowInComponent:0] - 1] objectForKey:@"city"] objectAtIndex:[locationPicker selectedRowInComponent:1] - 1] objectForKey:@"name"];
            [code addObject:[[[[locationList objectAtIndex:[locationPicker selectedRowInComponent:0] - 1] objectForKey:@"city"] objectAtIndex:[locationPicker selectedRowInComponent:1] - 1] objectForKey:@"id"]];
            [self setText:[NSString stringWithFormat:@"%@ %@", province, city?city:@""]];
            if ([locationPicker selectedRowInComponent:2] != 0) {
                NSString *district = [[[[[[locationList objectAtIndex:[locationPicker selectedRowInComponent:0] - 1] objectForKey:@"city"] objectAtIndex:[locationPicker selectedRowInComponent:1] - 1] objectForKey:@"district"] objectAtIndex:[locationPicker selectedRowInComponent:2] - 1] objectForKey:@"name"];
                [code addObject:[[[[[[locationList objectAtIndex:[locationPicker selectedRowInComponent:0] - 1] objectForKey:@"city"] objectAtIndex:[locationPicker selectedRowInComponent:1] - 1] objectForKey:@"district"] objectAtIndex:[locationPicker selectedRowInComponent:2] - 1] objectForKey:@"id"]];
                [self setText:[NSString stringWithFormat:@"%@ %@ %@", province, city?city:@"", district?district:@""]];
            }
        }
    }
    else {
        [self setText:@""];
    }

    //Save the code of selected ActivityRegion
    selectedActivityRegionCode = [NSArray arrayWithArray:code];
    [locationPicker setSelectedRows:@[[NSNumber numberWithInteger:[locationPicker selectedRowInComponent:0]], [NSNumber numberWithInteger:[locationPicker selectedRowInComponent:1]], [NSNumber numberWithInteger:[locationPicker selectedRowInComponent:2]]]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setMinimumScaleFactor:0.5f];
        [label adjustsFontSizeToFitWidth];
    }
    
    if (row == 0) {
        [label setText:[gUIStrings objectForKey:@"UI_ActivityRegion_UnselectedTitle"]];
    }
    else {
        switch (component) {
            case 0:
                [label setText:[[locationList objectAtIndex:row - 1] objectForKey:@"name"]];
                break;
            case 1:
                [label setText:[[[[locationList objectAtIndex:[pickerView selectedRowInComponent:0] - 1] objectForKey:@"city"] objectAtIndex:row - 1] objectForKey:@"name"]];
                break;
            case 2:
                [label setText:[[[[[[locationList objectAtIndex:[pickerView selectedRowInComponent:0] - 1] objectForKey:@"city"] objectAtIndex:[pickerView selectedRowInComponent:1] - 1] objectForKey:@"district"] objectAtIndex:row - 1] objectForKey:@"name"]];
                break;
            default:
                break;
        }
    }
    
    return label;
}
@end

@implementation ActivityRegionPicker
@synthesize selectedRows;

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (selectedRows) {
        for (int i = 0; i < selectedRows.count; i++) {
            [self selectRow:[[selectedRows objectAtIndex:i] integerValue] inComponent:i animated:NO];
            if (i < selectedRows.count - 1) {
                [self reloadComponent:i + 1];
            }
        }
    }
}
@end