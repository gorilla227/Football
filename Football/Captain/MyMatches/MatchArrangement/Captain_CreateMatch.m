//
//  Captain_CreateMatch.m
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch.h"

@implementation Captain_CreateMatch_MatchScoreTableView_Cell
@synthesize goalPlayerName, assistPlayerName;
@end

@implementation Captain_CreateMatch{
    NSDateFormatter *dateFormatter;
    UIDatePicker *matchTimePicker;
    UIStepper *numOfPlayersStepper;
    HintTextView *hintView;
    NSMutableArray *enteringControllers;
    BOOL matchStarted;
    BOOL isOpponentTeamInSystem;
    Team *selectedOpponentTeam;
    NSInteger indexOfSelectedHomeStadium;
    Stadium *matchStadium;
    MatchScore *matchScore;
}
@synthesize matchTime, matchOpponent, matchPlace, numOfPlayers, cost, costOptions, costOption_Judge, costOption_Water, actionButton, toolBar;
@synthesize matchScoreTextField, matchScoreTableView, matchScoreTableViewHeader, matchScoreHeader_Goal, matchScoreHeader_Assist;
@synthesize viewMatchData, segueIdentifier;

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
    //Set variables
    enteringControllers = [[NSMutableArray alloc] init];
    hintView = [[HintTextView alloc] init];
    indexOfSelectedHomeStadium = -1;
    matchStadium = [[Stadium alloc] init];
    matchScore = [[MatchScore alloc] init];
    matchScore.home = myUserInfo.team;
    
    //Set dateformatter
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_MatchDateAndTimeformat];
    
    //Set controls
    [self.view addSubview:hintView];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self initialMatchTime];
    [self initialMatchOpponent];
    [self initialMatchPlace];
    [self initialNumOfPlayers];
    [self initialCost];
    [self initialMatchScore];
    [matchScoreTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Initial View base on different source
    if ([segueIdentifier isEqualToString:@"CreateMatch"]) {
        [self initialCreateMatchView];
    }
    else if([segueIdentifier isEqualToString:@"FillRecord"]) {
        [self initialFillRecordView];
    }
    else if([segueIdentifier isEqualToString:@"ViewRecord"]) {
        [self initialViewRecordView];
    }
    else if([segueIdentifier isEqualToString:@"CreateWarmupMatch"]) {
        [self initialCreateWarmupMatchView];
    }
}

-(void)initialCreateMatchView
{
    //Hide controllers except matchTime
    [matchOpponent setHidden:YES];
    [matchPlace setHidden:YES];
    [numOfPlayers setHidden:YES];
    [cost setHidden:YES];
    [costOptions setHidden:YES];
    [matchScoreTextField setHidden:YES];
    [matchScoreTableViewHeader setHidden:YES];
    [matchScoreTableView setHidden:YES];
    [toolBar setHidden:YES];
}

-(void)initialFillRecordView
{
    [matchTime setEnabled:NO];
    [matchOpponent setHidden:NO];
    [matchOpponent setEnabled:NO];
    [matchPlace setHidden:NO];
    [matchPlace setEnabled:NO];
    [numOfPlayers setHidden:NO];
    [numOfPlayers setEnabled:NO];
    [cost setHidden:NO];
    [costOptions setHidden:NO];
    [matchScoreTextField setHidden:NO];
    [matchScoreTableViewHeader setHidden:NO];
    [matchScoreTableView setHidden:NO];
    [toolBar setHidden:NO];
    [actionButton setTitle:def_createMatch_actionButton_started];
    [hintView showOrHideHint:NO];
    
    //Fill data
    [matchTime setText:[dateFormatter stringFromDate:viewMatchData.matchDate]];
}

-(void)initialViewRecordView
{
    [matchTime setEnabled:NO];
    [matchOpponent setHidden:NO];
    [matchOpponent setEnabled:NO];
    [matchPlace setHidden:NO];
    [matchPlace setEnabled:NO];
    [numOfPlayers setHidden:NO];
    [numOfPlayers setEnabled:NO];
    [cost setHidden:NO];
    [costOptions setHidden:NO];
    [matchScoreTextField setHidden:NO];
    [matchScoreTableViewHeader setHidden:NO];
    [matchScoreTableView setHidden:NO];
    [toolBar setHidden:NO];
    [actionButton setTitle:def_createMatch_actionButton_started];
    [hintView showOrHideHint:NO];
    
    //Fill data
    [matchTime setText:[dateFormatter stringFromDate:viewMatchData.matchDate]];
}

-(void)initialCreateWarmupMatchView
{
    [matchOpponent setHidden:NO];
    [matchScoreTextField setHidden:YES];
    [matchScoreTableViewHeader setHidden:YES];
    [matchScoreTableView setHidden:YES];
    
    //Set default match date (tomorrow) and  minDate of matchDatePicker
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    [matchTimePicker setMinimumDate:minDate];
    [matchTime setText:[dateFormatter stringFromDate:minDate]];
}

//-(void)initialLeftViewForTextField:(UITextField *)textFieldNeedLeftView labelName:(NSString *)labelName iconImage:(NSString *)imageFileName
//{
//    CGRect leftViewFrame = textFieldNeedLeftView.bounds;
//    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFileName]];
//    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftIcon.frame.size.width, 0, 45, leftViewFrame.size.height)];
//    leftViewFrame.size.width = leftIcon.frame.size.width + leftLabel.frame.size.width + 40;
//    [leftLabel setText:labelName];
//    [leftLabel setTextAlignment:NSTextAlignmentCenter];
//    UIView *leftView = [[UIView alloc] initWithFrame:leftViewFrame];
//    [leftView addSubview:leftIcon];
//    [leftView addSubview:leftLabel];
//    [textFieldNeedLeftView setLeftView:leftView];
//    [textFieldNeedLeftView setLeftViewMode:UITextFieldViewModeAlways];
//    [textFieldNeedLeftView setPlaceholder:nil];
//    [enteringControllers addObject:textFieldNeedLeftView];
//}

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
    
    [matchTime initialLeftViewWithLabelName:def_createMatch_time labelWidth:75 iconImage:@"leftIcon_createMatch_time.png"];
    [enteringControllers addObject:matchTime];
//    [self initialLeftViewForTextField:matchTime labelName:def_createMatch_time iconImage:@"leftIcon_createMatch_time.png"];
    
    //Initial hint
    [hintView settingHintWithTextKey:@"EnterTime" underView:matchTime wantShow:YES];
}

-(void)initialMatchOpponent
{
    [matchOpponent initialLeftViewWithLabelName:def_createMatch_opponent labelWidth:75 iconImage:@"leftIcon_createMatch_opponent.png"];
    [enteringControllers addObject:matchOpponent];
//    [self initialLeftViewForTextField:matchOpponent labelName:def_createMatch_opponent iconImage:@"leftIcon_createMatch_opponent.png"];
}

-(void)initialMatchPlace
{
    [matchPlace initialLeftViewWithLabelName:def_createMatch_place labelWidth:75 iconImage:@"leftIcon_createMatch_place.png"];
//    [self initialLeftViewForTextField:matchPlace labelName:def_createMatch_place iconImage:@"leftIcon_createMatch_place.png"];
}

-(void)initialNumOfPlayers
{
    [numOfPlayers initialLeftViewWithLabelName:def_createMatch_numOfPlayers labelWidth:75 iconImage:@"leftIcon_createMatch_numOfPlayers.png"];
    [enteringControllers addObject:numOfPlayers];
//    [self initialLeftViewForTextField:numOfPlayers labelName:def_createMatch_numOfPlayers iconImage:@"leftIcon_createMatch_numOfPlayers.png"];
    
    //Set UIStepper as rightView
    numOfPlayersStepper = [[UIStepper alloc] init];
    [numOfPlayersStepper setTintColor:[UIColor blackColor]];
    [numOfPlayersStepper setMinimumValue:1];
    [numOfPlayersStepper setMaximumValue:30];
    [numOfPlayersStepper setStepValue:1];
    [numOfPlayersStepper setValue:11];
    [numOfPlayersStepper addTarget:self action:@selector(numberOfPlayersStepperChanged) forControlEvents:UIControlEventValueChanged];
    [self numberOfPlayersStepperChanged];
    [numOfPlayers setRightView:numOfPlayersStepper];
    [numOfPlayers setRightViewMode:UITextFieldViewModeAlways];
}

-(void)initialCost
{
    [cost initialLeftViewWithLabelName:def_createMatch_cost labelWidth:75 iconImage:@"leftIcon_createMatch_cost.png"];
    [enteringControllers addObject:cost];
//    [self initialLeftViewForTextField:cost labelName:def_createMatch_cost iconImage:@"leftIcon_createMatch_cost.png"];
}

-(void)initialMatchScore
{
    [matchScoreTextField initialLeftViewWithLabelName:def_createMatch_score labelWidth:75 iconImage:@"leftIcon_createMatch_score.png"];
    [enteringControllers addObject:matchScoreTextField];
//    [self initialLeftViewForTextField:matchScoreTextField labelName:def_createMatch_score iconImage:@"leftIcon_createMatch_score.png"];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:matchTime]) {
        if (![textField hasText]) {
            [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
        }
    }
    else if ([textField isEqual:matchOpponent]) {
        if (isOpponentTeamInSystem) {
            [self performSegueWithIdentifier:@"SelectOpponent" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"EnterOpponent" sender:self];
        }
    }
    else if ([textField isEqual:matchPlace]) {
        [self performSegueWithIdentifier:@"SelectMatchStadium" sender:self];
    }
    else if ([textField isEqual:numOfPlayers]) {
        return NO;
    }
    else if ([textField isEqual:matchScoreTextField]) {
        [self performSegueWithIdentifier:@"EnterScore" sender:self];
    }
    return YES;
}

-(void)checkActionButtonStatus
{
    for (UITextField *textField in enteringControllers) {
        if (![textField hasText]) {
            return;
        }
    }
    [actionButton setEnabled:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self checkActionButtonStatus];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    for (UITextField *textField in enteringControllers) {
        [textField resignFirstResponder];
    }
    if ([matchOpponent isHidden] && [matchTime hasText]) {
        [self matchTimeSelected];
    }
}

-(void)receiveNewOpponent:(NSString *)opponentName
{
    //Fill opponent
    [matchOpponent setText:opponentName];
    
    //Show other controllers
    [matchPlace setHidden:NO];
    [numOfPlayers setHidden:NO];
    [cost setHidden:NO];
    [costOptions setHidden:NO];
    
    //Hide hint
    [hintView showOrHideHint:NO];
    
    //Update controllers' status and action button name
    [toolBar setHidden:NO];
    if (!matchStarted) {
        [actionButton setTitle:def_createMatch_actionButton_new];
    }
    [cost setPlaceholder:def_createMatch_cost_ph_self];
    [self checkActionButtonStatus];
}

-(void)receiveSelectedOpponent:(Team *)opponentTeam
{
    //Fill opponent
    [matchOpponent setText:opponentTeam.teamName];
    
    //Set selectedOpponentTeam
    selectedOpponentTeam = opponentTeam;
    
    //Save the selected opponent type
    isOpponentTeamInSystem = YES;
    
    //Show other controllers
    [matchPlace setHidden:NO];
    [numOfPlayers setHidden:NO];
    [cost setHidden:NO];
    [costOptions setHidden:NO];
    
    //Hide hint
    [hintView showOrHideHint:NO];
    
    //Update controllers' status and action button name
    [toolBar setHidden:NO];
    [actionButton setTitle:def_createMatch_actionButton_existed];
    [cost setPlaceholder:def_createMatch_cost_ph_opponent];
    [self checkActionButtonStatus];
}

-(void)receiveSelectedOpponentForWarmupMatch:(Team *)opponentTeam
{
    [self setSegueIdentifier:@"CreateWarmupMatch"];
//    [self loadView];
    [self viewDidLoad];
    [self receiveSelectedOpponent:opponentTeam];
}

-(void)receiveSelectedStadium:(Stadium *)selectedStadium indexOfHomeStadium:(NSInteger)index
{
    //Fill matchPlace;
    [matchPlace setText:selectedStadium.stadiumName];
    matchStadium = selectedStadium;
    
    //Save the indexOfMainPlayground
    indexOfSelectedHomeStadium = index;
    
    //Update action button status
    [self checkActionButtonStatus];
}

-(void)receiveScore:(MatchScore *)score
{
    matchScore = score;
    [matchScoreTextField setText:[NSString stringWithFormat:@"%@:%@", matchScore.homeScore, matchScore.awayScore]];
    [matchScoreTableView reloadData];
}

-(IBAction)confirmCreateMatchButtonSetEnabled:(id)sender
{
    [actionButton setEnabled:[matchTime hasText] && [matchOpponent hasText] && [matchPlace hasText] && [numOfPlayers hasText] && [cost hasText]];
}

-(void)numberOfPlayersStepperChanged
{
    [numOfPlayers setText:[NSNumber numberWithDouble:numOfPlayersStepper.value].stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma DatePicker
-(void)matchTimeSelected
{
    //Fill the date to matchTime textfield
    [matchTime setText:[dateFormatter stringFromDate:matchTimePicker.date]];
    
    //Remove the tint
    if (hintView) {
        [hintView showOrHideHint:NO];
    }
    
    //Refresh controller status after matchTime entered
    NSTimeInterval timeInterval = [matchTimePicker.date timeIntervalSinceNow];
    if (matchStarted != timeInterval < 0) {
        matchStarted = timeInterval < 0;
        [matchOpponent setText:nil];
        [matchPlace setText:nil];
        
        if (matchStarted) {
            //Match started
            [matchOpponent setHidden:NO];
            [matchPlace setHidden:NO];
            [numOfPlayers setHidden:NO];
            [cost setHidden:NO];
            [costOptions setHidden:NO];
            [toolBar setHidden:NO];
            [matchScoreTextField setHidden:NO];
            [matchScoreTableViewHeader setHidden:YES];
            [matchScoreTableView setHidden:YES];
            [actionButton setTitle:def_createMatch_actionButton_started];
        }
        else {
            //Match not start
            [matchOpponent setHidden:NO];
            [matchPlace setHidden:YES];
            [numOfPlayers setHidden:YES];
            [cost setHidden:YES];
            [costOptions setHidden:YES];
            [matchScoreTextField setHidden:YES];
            [matchScoreTableViewHeader setHidden:YES];
            [matchScoreTableView setHidden:YES];
            [toolBar setHidden:YES];
            
            //Initial tint
            [hintView settingHintWithTextKey:@"EnterOpponent_MatchNotStarted" underView:matchOpponent wantShow:YES];
        }
    }
}

#pragma matchScore tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [matchScoreTableView setHidden:matchScore.homeScore.integerValue==0];
    [matchScoreTableViewHeader setHidden:matchScore.homeScore.integerValue==0];
    return matchScore.homeScore.integerValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Captain_CreateMatch_MatchScoreTableView_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchScoreCell"];
    UserInfo *goalPlayer = [matchScore.goalPlayers objectAtIndex:indexPath.row];
    UserInfo *assistPlayer = [matchScore.assistPlayers objectAtIndex:indexPath.row];
    [cell.goalPlayerName setText:goalPlayer.name];
    [cell.assistPlayerName setText:assistPlayer.name];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EnterOpponent"]) {
        //Enter Opponent
        Captain_CreateMatch_EnterOpponent *enterOpponentController = segue.destinationViewController;
        [enterOpponentController setMatchStarted:matchStarted];
        [enterOpponentController setSelectedTeamName:matchOpponent.text];
        [enterOpponentController setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"SelectOpponent"]) {
        //Select Opponent
        Captain_CreateMatch_TeamMarket *selectOpponentController = segue.destinationViewController;
        [selectOpponentController setDelegate:self];
        [selectOpponentController setSelectedTeam:selectedOpponentTeam];
    }
    else if ([segue.identifier isEqualToString:@"SelectMatchStadium"]) {
        //Select Playground
        Captain_CreateMatch_SelectMatchStadium *selectMatchStadium = segue.destinationViewController;
        [selectMatchStadium setDelegate:self];
        [selectMatchStadium setIndexOfSelectedHomeStadium:indexOfSelectedHomeStadium];
        [selectMatchStadium setMatchStadium:matchStadium];
    }
    else if ([segue.identifier isEqualToString:@"EnterScore"]) {
        //Enter Score
        Captain_CreateMatch_EnterScore *enterScore = segue.destinationViewController;
        [enterScore setDelegate:self];
        if (selectedOpponentTeam) {
            [matchScore setAwayTeamName:selectedOpponentTeam.teamName];
        }
        else {
            [matchScore setAwayTeamName:matchOpponent.text];
        }
        [enterScore setMatchScore:matchScore];
    }
}
@end
