//
//  UITextFieldForActivityRegion.m
//  Football
//
//  Created by Andy Xu on 14-6-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "UITextFieldForActivityRegion.h"

@implementation UITextFieldForActivityRegion{
    NSArray *locationList;
    UIPickerView *locationPicker;
}
@synthesize selectedActivityRegionCode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)activityRegionTextField
{
    //Load ActivityRegions.json
    NSString *fileString = [[NSBundle mainBundle] pathForResource:@"ActivityRegions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fileString];
    locationList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    locationPicker = [[UIPickerView alloc] init];
    [locationPicker setDelegate:self];
    [locationPicker setDataSource:self];
    [self setInputView:locationPicker];
}

-(void)presetActivityRegionCode:(NSArray *)activityRegionCode
{
    NSMutableString *regionString;
    selectedActivityRegionCode = activityRegionCode;
    for (NSDictionary *province in locationList) {
        if ([[province objectForKey:@"id"] isEqualToString:selectedActivityRegionCode[0]]) {
            regionString = [[NSMutableString alloc] initWithString:[province objectForKey:@"name"]];
            [locationPicker selectRow:[locationList indexOfObject:province] inComponent:0 animated:NO];
            if (selectedActivityRegionCode.count > 1) {
                for (NSDictionary *city in [province objectForKey:@"city"]) {
                    if ([[city objectForKey:@"id"] isEqualToString:selectedActivityRegionCode[1]]) {
                        [regionString appendString:[NSString stringWithFormat:@" %@", [city objectForKey:@"name"]]];
                        [locationPicker selectRow:[[province objectForKey:@"city"] indexOfObject:city] inComponent:1 animated:NO];
                        if (selectedActivityRegionCode.count > 2) {
                            for (NSDictionary *district in [city objectForKey:@"district"]) {
                                if ([[district objectForKey:@"id"] isEqualToString:selectedActivityRegionCode[2]]) {
                                    [regionString appendString:[NSString stringWithFormat:@" %@", [district objectForKey:@"name"]]];
                                    [locationPicker selectRow:[[city objectForKey:@"district"] indexOfObject:district] inComponent:2 animated:NO];
                                    break;
                                }
                            }
                        }
                        break;
                    }
                }
            }
            break;
        }
    }
    [self setText:regionString];
}

#pragma UIPickerView Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return locationList.count;
        case 1:
            return [[[locationList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"city"] count];
        case 2:
            return [[[[[locationList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"city"] objectAtIndex:[pickerView selectedRowInComponent:1]] objectForKey:@"district"] count];
        default:
            return 0;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
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
    NSString *province = [[locationList objectAtIndex:[locationPicker selectedRowInComponent:0]] objectForKey:@"name"];
    NSString *city = [[[[locationList objectAtIndex:[locationPicker selectedRowInComponent:0]] objectForKey:@"city"] objectAtIndex:[locationPicker selectedRowInComponent:1]] objectForKey:@"name"];
    NSString *district = [[[[[[locationList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"city"] objectAtIndex:[pickerView selectedRowInComponent:1]] objectForKey:@"district"] objectAtIndex:[pickerView selectedRowInComponent:2]] objectForKey:@"name"];
    [self setText:[NSString stringWithFormat:@"%@ %@ %@", province, city?city:@"", district?district:@""]];
    
    NSString *provinceId = [[locationList objectAtIndex:[locationPicker selectedRowInComponent:0]] objectForKey:@"id"];
    NSString *cityId = [[[[locationList objectAtIndex:[locationPicker selectedRowInComponent:0]] objectForKey:@"city"] objectAtIndex:[locationPicker selectedRowInComponent:1]] objectForKey:@"id"];
    NSString *districtId = [[[[[[locationList objectAtIndex:[locationPicker selectedRowInComponent:0]] objectForKey:@"city"] objectAtIndex:[locationPicker selectedRowInComponent:1]] objectForKey:@"district"] objectAtIndex:[locationPicker selectedRowInComponent:2]] objectForKey:@"id"];
    
    //Save the code of selected ActivityRegion
    NSMutableArray *code = [[NSMutableArray alloc] init];
    if (provinceId) {
        [code addObject:provinceId];
        if (cityId) {
            [code addObject:cityId];
            if (districtId) {
                [code addObject:districtId];
            }
        }
    }
    selectedActivityRegionCode = [NSArray arrayWithArray:code];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 105, 30)];
    switch (component) {
        case 0:
            [label setText:[[locationList objectAtIndex:row] objectForKey:@"name"]];
            break;
        case 1:
            [label setText:[[[[locationList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"city"] objectAtIndex:row] objectForKey:@"name"]];
            break;
        case 2:
            [label setText:[[[[[[locationList objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"city"] objectAtIndex:[pickerView selectedRowInComponent:1]] objectForKey:@"district"] objectAtIndex:row] objectForKey:@"name"]];
            break;
        default:
            break;
    }
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setMinimumScaleFactor:0.5f];
    [label adjustsFontSizeToFitWidth];
    return label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
