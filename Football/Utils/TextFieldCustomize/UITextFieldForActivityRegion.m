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
    }
    if (cityId) {
        [code addObject:cityId];
    }
    if (districtId) {
        [code addObject:districtId];
    }
    selectedActivityRegionCode = [NSArray arrayWithArray:code];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view) {
        NSLog(@"%f, %f, %f, %f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
    
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
