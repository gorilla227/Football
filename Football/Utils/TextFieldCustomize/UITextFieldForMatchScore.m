//
//  UITextFieldForMatchScore.m
//  Football
//
//  Created by Andy on 15/1/24.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "UITextFieldForMatchScore.h"

@implementation UITextFieldForMatchScore{
    UIPickerView *scorePicker;
    NSInteger homeTeamScore;
    NSInteger awayTeamScore;
}
@synthesize isRegularMatch;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initialTextFieldForMatchScore
{
    scorePicker = [[UIPickerView alloc] init];
    [scorePicker setDelegate:self];
    [scorePicker setDataSource:self];
    [self setInputView:scorePicker];
    [self setTintColor:[UIColor clearColor]];
}

-(void)presetHomeScore:(NSInteger)homeScore andAwayScore:(NSInteger)awayScore
{
    homeTeamScore = homeScore;
    awayTeamScore = awayScore;
    if (awayTeamScore < 0) {
        [self setText:[NSString stringWithFormat:@"%@ : --", [NSNumber numberWithInteger:homeTeamScore]]];
    }
    else {
        [self setText:[NSString stringWithFormat:@"%@ : %@", [NSNumber numberWithInteger:homeTeamScore], [NSNumber numberWithInteger:awayTeamScore]]];
    }
    
    [scorePicker selectRow:homeTeamScore inComponent:0 animated:NO];
    if (!isRegularMatch) {
        [scorePicker selectRow:awayTeamScore inComponent:1 animated:NO];
    }
}

//UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return isRegularMatch?1:2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 30;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSNumber numberWithInteger:row].stringValue;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        homeTeamScore = [pickerView selectedRowInComponent:0];
    }
    else {
        awayTeamScore = [pickerView selectedRowInComponent:1];
    }
    
    [self setText:[NSString stringWithFormat:@"%@ : %@", [NSNumber numberWithInteger:homeTeamScore], [NSNumber numberWithInteger:awayTeamScore]]];
}

@end
