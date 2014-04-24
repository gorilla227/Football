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
    HintTextView *hintView;
    NSMutableArray *enteringControllers;
    BOOL matchStarted;
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
    enteringControllers = [[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self initialMatchTime];
    [self initialMatchOpponent];
    [self initialMatchPlace];
    [self initialNumOfPlayers];
    [self initialCost];
    
    //Hide controllers except matchTime
    [matchOpponent setHidden:YES];
    [matchPlace setHidden:YES];
    [numOfPlayers setHidden:YES];
    [cost setHidden:YES];
    [costOptions setHidden:YES];
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
    [enteringControllers addObject:textFieldNeedLeftView];
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
    
    //Initial hint
    hintView = [[HintTextView alloc] initWithTextKey:@"EnterTime" underView:matchTime];
    [self.view addSubview:hintView];
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
        if (![textField hasText]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
        }
    }
    if ([textField isEqual:matchOpponent]) {
        [textField endEditing:YES];
    }
}

#pragma DatePicker
-(void)matchTimeSelected
{
    //Fill the date to matchTime textfield
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [matchTime setText:[dateFormatter stringFromDate:matchTimePicker.date]];

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //Remove the tint
    if (hintView && [textField hasText] && [hintView.boundedView isEqual:textField]) {
        [hintView removeFromSuperview];
    }
    
    //Refresh controller status after matchTime entered
    if ([textField isEqual:matchTime]) {
        NSTimeInterval timeInterval = [matchTimePicker.date timeIntervalSinceNow];
        matchStarted = timeInterval < 0;
        if (matchStarted) {
            //Match started
            [matchOpponent setHidden:NO];
        }
        else {
            //Match not start
            [matchOpponent setHidden:NO];
            
            //Initial tint
            if (![self.view.subviews containsObject:hintView]) {
                hintView = [[HintTextView alloc] initWithTextKey:@"EnterOpponent_MatchNotStarted" underView:matchOpponent];
                [self.view addSubview:hintView];
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    for (UIControl *controller in enteringControllers) {
        [controller resignFirstResponder];
    }
}

-(void)receiveOpponent:(NSString *)opponentName
{
    //Fill opponent
    [matchOpponent setText:opponentName];
    
    //Show other controllers
    [matchPlace setHidden:NO];
    [numOfPlayers setHidden:NO];
    [cost setHidden:NO];
    [costOptions setHidden:NO];
    [cost setPlaceholder:def_createMatch__notStarted_cost_ph];
    
    //Remove hint
    if ([self.view.subviews containsObject:hintView]) {
        [hintView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    Captain_CreateMatch_EnterOpponent *enterOpponentController = segue.destinationViewController;
    [enterOpponentController setMatchStarted:matchStarted];
    [enterOpponentController setDelegate:self];
}
@end
