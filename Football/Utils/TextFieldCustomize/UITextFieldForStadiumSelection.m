//
//  UITextFieldForStadiumSelection.m
//  SandBox_Map2
//
//  Created by Andy on 14-7-12.
//  Copyright (c) 2014年 Axu. All rights reserved.
//

#import "UITextFieldForStadiumSelection.h"

@implementation UITextFieldForStadiumSelection{
    NSArray *stadiumList;
    UIPickerView *staidumPicker;
    MKMapView *stadiumMap;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)textFieldInitialization:(NSArray *)stadiums
{
    stadiumList = stadiums;
    staidumPicker = [[UIPickerView alloc] init];
    [staidumPicker setDelegate:self];
    [staidumPicker setDataSource:self];
    stadiumMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    [stadiumMap setShowsUserLocation:YES];
    [self setInputView:staidumPicker];
    [self setInputAccessoryView:stadiumMap];
}

-(void)presetHomeStadium:(Stadium *)stadium
{
    if (stadium) {
        for (Stadium *stadiumInList in stadiumList) {
            if (stadiumInList.stadiumId == stadium.stadiumId) {
                [staidumPicker selectRow:[stadiumList indexOfObject:stadiumInList] + 1 inComponent:0 animated:NO];
                [self pickerView:staidumPicker didSelectRow:[stadiumList indexOfObject:stadiumInList] + 1 inComponent:0];
                return;
            }
        }
    }
    [staidumPicker selectRow:0 inComponent:0 animated:NO];
    [self pickerView:staidumPicker didSelectRow:0 inComponent:0];
}

-(Stadium *)selectedHomeStadium
{
    if ([staidumPicker selectedRowInComponent:0] == 0) {
        return nil;
    }
    else {
        return [stadiumList objectAtIndex:[staidumPicker selectedRowInComponent:0] - 1];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return stadiumList.count + 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"无";
    }
    else {
        Stadium *stadium = [stadiumList objectAtIndex:row - 1];
        return stadium.title;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
//        [stadiumMap removeAnnotations:stadiumMap.annotations];
//        [stadiumMap showAnnotations:@[stadiumMap.userLocation] animated:YES];
        [self setText:nil];
        [self setInputAccessoryView:nil];
        [self reloadInputViews];
    }
    else {
        Stadium *stadium = [stadiumList objectAtIndex:row - 1];
        [stadiumMap removeAnnotations:stadiumMap.annotations];
        [stadiumMap showAnnotations:@[stadium] animated:YES];
        [stadiumMap selectAnnotation:stadium animated:YES];
        [self setText:stadium.title];
        [self setInputAccessoryView:stadiumMap];
        [self reloadInputViews];
    }
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
