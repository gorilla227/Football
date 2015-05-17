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
    UIButton *selectHomeStadiumButton;
    Stadium *myHomeStadium;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)textFieldInitialization:(NSArray *)stadiums homeStadium:(Stadium *)homeStadium showSelectHomeStadium:(BOOL)shouldShowHomeStadium
{
    myHomeStadium = homeStadium;
    
    //Set Picker
    stadiumList = stadiums;
    staidumPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height / 3)];
    [staidumPicker setDelegate:self];
    [staidumPicker setDataSource:self];
    stadiumMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, windowSize.height / 4)];
    [stadiumMap setShowsUserLocation:YES];
    [self setInputView:staidumPicker];
    [self setInputAccessoryView:stadiumMap];
    
    //Set SelectHomeStadiumButton
    selectHomeStadiumButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectHomeStadiumButton setShowsTouchWhenHighlighted:YES];
    [selectHomeStadiumButton addTarget:self action:@selector(selectHomeStadium) forControlEvents:UIControlEventTouchUpInside];
    [selectHomeStadiumButton.titleLabel setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
    [selectHomeStadiumButton setTitle:[gUIStrings objectForKey:@"UI_StadiumSelection_Home"] forState:UIControlStateNormal];
    [selectHomeStadiumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectHomeStadiumButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [selectHomeStadiumButton setBackgroundColor:cLightBlue(1.0)];
    [selectHomeStadiumButton.layer setCornerRadius:8.0f];
    [selectHomeStadiumButton.layer setMasksToBounds:YES];
    [selectHomeStadiumButton sizeToFit];
    [selectHomeStadiumButton.titleLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
    [self setRightView:selectHomeStadiumButton];
    [self setRightViewMode:(shouldShowHomeStadium && homeStadium)?UITextFieldViewModeWhileEditing:UITextFieldViewModeNever];
}

-(void)presetStadium:(Stadium *)stadium
{
    if (stadium) {
        if (myHomeStadium) {
            [selectHomeStadiumButton setEnabled:(stadium.stadiumId != myHomeStadium.stadiumId)];
        }
        
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

-(Stadium *)selectedStadium
{
    if ([staidumPicker selectedRowInComponent:0] == 0) {
        return nil;
    }
    else {
        return [stadiumList objectAtIndex:[staidumPicker selectedRowInComponent:0] - 1];
    }
}

-(void)selectHomeStadium
{
    for (Stadium *stadium in stadiumList) {
        if (stadium.stadiumId == myHomeStadium.stadiumId) {
            [self presetStadium:stadium];
            [self resignFirstResponder];
        }
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
        return [gUIStrings objectForKey:@"UI_StadiumSelection_None"];
    }
    else {
        Stadium *stadium = [stadiumList objectAtIndex:row - 1];
        return stadium.title;
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        [self setText:nil];
        [self setInputAccessoryView:nil];
        [self reloadInputViews];
        [selectHomeStadiumButton setEnabled:YES];
    }
    else {
        Stadium *stadium = [stadiumList objectAtIndex:row - 1];
        [stadiumMap removeAnnotations:stadiumMap.annotations];
        [stadiumMap showAnnotations:@[stadium] animated:YES];
        [stadiumMap selectAnnotation:stadium animated:YES];
        [self setText:stadium.title];
        [self setInputAccessoryView:stadiumMap];
        [self reloadInputViews];
        if (myHomeStadium) {
            [selectHomeStadiumButton setEnabled:(stadium.stadiumId != myHomeStadium.stadiumId)];
        }
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
