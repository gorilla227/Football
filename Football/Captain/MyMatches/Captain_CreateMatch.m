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
@synthesize matchTime, matchOpponent, matchPlace, numOfPlayers, cost, costOptions, costOption_Judge, costOption_Water;

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self initialMatchTime];
    [self initialMatchOpponent];
    [self initialMatchPlace];
    [self initialNumOfPlayers];
    [self initialCost];
    [self.view addSubview:tintView];
}

-(void)initialLeftViewForTextField:(UITextField *)textFieldNeedLeftView labelName:(NSString *)labelName iconImage:(NSString *)imageFileName
{
    CGRect leftViewFrame = textFieldNeedLeftView.bounds;
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFileName]];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftIcon.frame.size.width, 0, 45, leftViewFrame.size.height)];
    leftViewFrame.size.width = leftIcon.frame.size.width + leftLabel.frame.size.width;
    [leftLabel setText:labelName];
    [leftLabel setTextAlignment:NSTextAlignmentCenter];
    UIView *leftView = [[UIView alloc] initWithFrame:leftViewFrame];
    [leftView addSubview:leftIcon];
    [leftView addSubview:leftLabel];
    [textFieldNeedLeftView setLeftView:leftView];
    [textFieldNeedLeftView setLeftViewMode:UITextFieldViewModeAlways];
    [textFieldNeedLeftView setPlaceholder:nil];
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
    
    [self initialLeftViewForTextField:matchTime labelName:def_createMatch_time iconImage:@"leftIcon_createMatch_time.png"];
    
    //Initial tint
//    tintView = [[TintTextView alloc] initWithTextKey:@"EnterTime" underView:matchTime];
}

-(void)initialMatchOpponent
{
    [self initialLeftViewForTextField:matchOpponent labelName:def_createMatch_opponent iconImage:@"leftIcon_createMatch_opponent.png"];
}

-(void)initialMatchPlace
{
    [self initialLeftViewForTextField:matchPlace labelName:def_createMatch_place iconImage:@"leftIcon_createMatch_place.png"];
}

-(void)initialNumOfPlayers
{
    [self initialLeftViewForTextField:numOfPlayers labelName:def_createMatch_numOfPlayers iconImage:@"leftIcon_createMatch_numOfPlayers.png"];
}

-(void)initialCost
{
    [self initialLeftViewForTextField:cost labelName:def_createMatch_cost iconImage:@"leftIcon_createMatch_cost.png"];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:matchTime]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
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
