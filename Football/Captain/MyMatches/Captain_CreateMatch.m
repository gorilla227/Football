//
//  Captain_CreateMatch.m
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch.h"

@interface Captain_CreateMatch ()

@end

@implementation Captain_CreateMatch{
    UIDatePicker *matchTimePicker;
    TintTextView *tintView;
}
@synthesize matchTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialMatchTime];
    [self.view addSubview:tintView];
}

-(void)initialMatchTime
{
    matchTimePicker = [[UIDatePicker alloc] init];
    [matchTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [matchTimePicker setLocale:[NSLocale currentLocale]];
    
    //Set minimumdate and Maximumdate for datepicker
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-1];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    [comps setYear:1];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    [matchTimePicker setMinimumDate:minDate];
    [matchTimePicker setMaximumDate:maxDate];
    [matchTimePicker addTarget:self action:@selector(matchTimeSelected) forControlEvents:UIControlEventValueChanged];
    [matchTime setInputView:matchTimePicker];
    
    //Set left view for matchTime
    CGRect matchTimeLeftViewFrame = matchTime.bounds;
    UIImageView *matchTimeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftIcon_createMatch_time.png"]];
    UILabel *matchTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(matchTimeIcon.frame.size.width, 0, 40, matchTimeLeftViewFrame.size.height)];
    matchTimeLeftViewFrame.size.width = matchTimeIcon.frame.size.width + 40;
    [matchTimeTitle setText:def_createMatch_time];
    [matchTimeTitle setTextAlignment:NSTextAlignmentCenter];
    UIView *matchTimeLeftView = [[UIView alloc] initWithFrame:matchTimeLeftViewFrame];
    [matchTimeLeftView addSubview:matchTimeIcon];
    [matchTimeLeftView addSubview:matchTimeTitle];
    [matchTime setLeftView:matchTimeLeftView];
    [matchTime setLeftViewMode:UITextFieldViewModeAlways];
    
    //Initial tint
    tintView = [[TintTextView alloc] initWithTextKey:@"EnterTime" underView:matchTime];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:matchTime]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        [matchTime setText:[dateFormatter stringFromDate:[NSDate date]]];
    }
}

#pragma DatePicker
-(void)matchTimeSelected
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [matchTime setText:[dateFormatter stringFromDate:matchTimePicker.date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
