//
//  MatchDetails.m
//  Football
//
//  Created by Andy on 14/12/7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MatchDetails.h"
#import "TeamMarket.h"
#import "TeamDetails.h"
#import "StadiumDetails.h"

@interface MatchDetails_MatchScoreDetails_Cell ()
@property IBOutlet UILabel *goalPlayerName;
@property IBOutlet UILabel *assistPlayerName;
@end

@implementation MatchDetails_MatchScoreDetails_Cell
@synthesize goalPlayerName, assistPlayerName;
@end

@interface MatchDetails ()
@property IBOutlet UITextField *matchTimeTextField;
@property IBOutlet UITextField *matchOpponentTextField;
@property IBOutlet UITextFieldForStadiumSelection *matchStadiumTextFiedld;
@property IBOutlet UITextField *matchStandardTextField;
@property IBOutlet UITextField *costTextField;
@property IBOutlet UISwitch *costOption_Referee;
@property IBOutlet UISwitch *costOption_Water;
@property IBOutlet UITextFieldForMatchScore *scoreTextField;
@property IBOutlet UITableView *scoreDetailsTableView;
@property IBOutlet UIButton *inviteOpponentButton;
@property IBOutlet UIToolbar *createMatchActionBar;
@property IBOutlet UIBarButtonItem *createMatchButton;
@property IBOutlet UIToolbar *matchInvitationActionBar;
@property IBOutlet UIBarButtonItem *acceptMatchInvitationButton;
@property IBOutlet UIBarButtonItem *refuseMatchInvitationButton;
@property IBOutlet UIToolbar *matchNoticeActionBar;
@property IBOutlet UIBarButtonItem *acceptMatchNoticeButton;
@property IBOutlet UIBarButtonItem *refuseMatchNoticeButton;
@property IBOutlet UIGestureRecognizer *dismissKeyboardGestureRecognizer;
@end

@implementation MatchDetails{
    enum MatchDetailsCreationProgress creationProgress;
    UIDatePicker *matchTimePicker;
    UIStepper *matchStandardStepper;
    NSDateFormatter *dateFormatter;
    NSArray *textFields;
    Team *selectedOpponentTeam;
    JSONConnect *connection;
}
@synthesize matchTimeTextField, matchOpponentTextField, matchStadiumTextFiedld, matchStandardTextField, costTextField, costOption_Referee, costOption_Water, scoreTextField, scoreDetailsTableView, inviteOpponentButton, createMatchActionBar, createMatchButton, matchInvitationActionBar, acceptMatchInvitationButton, refuseMatchInvitationButton, matchNoticeActionBar, acceptMatchNoticeButton, refuseMatchNoticeButton, dismissKeyboardGestureRecognizer;
@synthesize viewType, matchData, message;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.scoreDetailsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Set dateformatter
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_MatchDateAndTimeformat];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    //Initial TextFields
    textFields = @[matchTimeTextField, matchOpponentTextField, matchStadiumTextFiedld, matchStandardTextField, costTextField, scoreTextField];
    [self initialMatchTime];
    [self initialMatchOpponent];
    [self initialMatchStadium];
    [self initialMatchStandard];
    [self initialCost];
    [self initialMatchScore];
    
    switch (viewType) {
        case MatchDetailsViewType_CreateMatch:
            [self setToolbarItems:createMatchActionBar.items animated:YES];
            [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_MatchDetails_Title_CreateMatch"]];
            break;
        case MatchDetailsViewType_ViewDetails:
            [self setToolbarItems:nil];
            [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_MatchDetails_Title_ViewDetails"]];
            [self presetMatchData];
            [dismissKeyboardGestureRecognizer setEnabled:NO];
            break;
        case MatchDetailsViewType_MatchInvitation:
            [self setToolbarItems:matchInvitationActionBar.items];
            [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_MatchDetails_Title_ViewDetails"]];
            [self presetMatchData];
            [dismissKeyboardGestureRecognizer setEnabled:NO];
            break;
        case MatchDetailsViewType_MatchNotice:
            [self setToolbarItems:matchNoticeActionBar.items];
            [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_MatchDetails_Title_ViewDetails"]];
            [self presetMatchData];
            [dismissKeyboardGestureRecognizer setEnabled:NO];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!self.toolbarItems.count];
}

-(void)presetMatchData {
    if (matchData) {
        selectedOpponentTeam = (matchData.homeTeam.teamId == gMyUserInfo.team.teamId)?matchData.awayTeam:matchData.homeTeam;
        
        [matchTimeTextField setText:[dateFormatter stringFromDate:matchData.beginTime]];
        [matchOpponentTextField setText:selectedOpponentTeam.teamName];
        [matchStadiumTextFiedld setText:matchData.matchField.stadiumName];
        [matchStandardTextField setText:[NSNumber numberWithInteger:matchData.matchStandard].stringValue];
        [costTextField setText:[NSString stringWithFormat:@"%.2f", matchData.cost.floatValue]];
        [costOption_Referee setOn:matchData.withReferee];
        [costOption_Water setOn:matchData.withWater];
        [scoreTextField setText:(selectedOpponentTeam.teamId == matchData.awayTeam.teamId)?[NSString stringWithFormat:@"%@ : %@", matchData.homeTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.homeTeamGoal], matchData.awayTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.awayTeamGoal]]:[NSString stringWithFormat:@"%@ : %@", matchData.awayTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.awayTeamGoal], matchData.homeTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.homeTeamGoal]]];
        switch (viewType) {
            case MatchDetailsViewType_MatchInvitation:
                [acceptMatchInvitationButton setEnabled:(matchData.matchMessage.status == 0 || matchData.matchMessage.status == 1)];
                [refuseMatchInvitationButton setEnabled:(matchData.matchMessage.status == 0 || matchData.matchMessage.status == 1)];
                break;
            case MatchDetailsViewType_MatchNotice:
                [acceptMatchNoticeButton setEnabled:(matchData.matchMessage.status == 0 || matchData.matchMessage.status == 1)];
                [refuseMatchNoticeButton setEnabled:(matchData.matchMessage.status == 0 || matchData.matchMessage.status == 1)];
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }
    else {
        //Request match data via matchId in message.
        [connection requestMatchesByMatchId:message.matchId];
    }
}

#pragma JSONConnectDelegate
-(void)receiveMatch:(Match *)match {
    matchData = match;
    [matchData setMatchMessage:message];
    [self presetMatchData];
}

-(void)createMatchWithRealTeam:(NSInteger)matchId {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer isSent:(BOOL)result {
    if (result) {
        [matchData.matchMessage setStatus:answer?2:3];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:result?[gUIStrings objectForKey:@"UI_ReplyMatchNoticeAlertView_Title_Succ"]:[gUIStrings objectForKey:@"UI_ReplyMatchNoticeAlertView_Title_Fail"]
                                                        message:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_ReplyMatchNoticeAlertView_Message"], answer?[gUIStrings objectForKey:@"UI_ReplyMatchNoticeAlertView_Message_Accept"]:[gUIStrings objectForKey:@"UI_ReplyMatchNoticeAlertView_Message_Refuse"]]
                                                       delegate:self
                                              cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"]
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)replyMatchInvitation:(Message *)message withAnswer:(BOOL)answer isSent:(BOOL)result {
    if (result) {
        [matchData.matchMessage setStatus:answer?2:3];
        [matchData setStatus:answer?3:2];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:result?[gUIStrings objectForKey:@"UI_ReplyMatchInvitationAlertView_Title_Succ"]:[gUIStrings objectForKey:@"UI_ReplyMatchInvitationAlertView_Title_Fail"]
                                                        message:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_ReplyMatchInvitationAlertView_Message"], answer?[gUIStrings objectForKey:@"UI_ReplyMatchInvitationAlertView_Message_Accept"]:[gUIStrings objectForKey:@"UI_ReplyMatchInvitationAlertView_Message_Refuse"], matchData.homeTeam.teamName]
                                                       delegate:self
                                              cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"]
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageStatusUpdated" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Initial TextFields
-(void)initialMatchTime
{
    matchTimePicker = [[UIDatePicker alloc] init];
    [matchTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [matchTimePicker setLocale:[NSLocale currentLocale]];
    
    //Set minimumdate and Maximumdate for datepicker
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-1];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    [comps setYear:1];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    [matchTimePicker setMinimumDate:minDate];
    [matchTimePicker setMaximumDate:maxDate];
    [matchTimePicker addTarget:self action:@selector(matchTimeSelected) forControlEvents:UIControlEventValueChanged];
    [matchTimeTextField setInputView:matchTimePicker];
    [matchTimeTextField setUserInteractionEnabled:(viewType == MatchDetailsViewType_CreateMatch)];
    [matchTimeTextField setTintColor:[UIColor clearColor]];
}

-(void)initialMatchOpponent
{
    [inviteOpponentButton.layer setCornerRadius:5.0f];
    [inviteOpponentButton.layer setMasksToBounds:YES];
    [matchOpponentTextField setRightView:inviteOpponentButton];
    [matchOpponentTextField setRightViewMode:UITextFieldViewModeWhileEditing];
    [matchOpponentTextField setLeftViewMode:UITextFieldViewModeAlways];
    [matchOpponentTextField setUserInteractionEnabled:(viewType == MatchDetailsViewType_CreateMatch)];
}

-(void)initialMatchStadium
{
    [matchStadiumTextFiedld textFieldInitialization:gStadiums homeStadium:gMyUserInfo.team.homeStadium showSelectHomeStadium:YES];
    [matchStadiumTextFiedld setUserInteractionEnabled:(viewType == MatchDetailsViewType_CreateMatch)];
}

-(void)initialMatchStandard
{
    //Set UIStepper as rightView
    matchStandardStepper = [[UIStepper alloc] init];
    [matchStandardStepper setTintColor:cLightBlue(1.0)];
    [matchStandardStepper setMinimumValue:3];
    [matchStandardStepper setMaximumValue:11];
    [matchStandardStepper setStepValue:1];
    [matchStandardStepper setValue:11];
    [matchStandardStepper addTarget:self action:@selector(standardStepperChanged) forControlEvents:UIControlEventValueChanged];
    [matchStandardTextField setRightView:matchStandardStepper];
    [matchStandardTextField setRightViewMode:UITextFieldViewModeAlways];
    [matchStandardTextField setText:[NSNumber numberWithDouble:matchStandardStepper.value].stringValue];
    [matchStandardTextField setUserInteractionEnabled:(viewType == MatchDetailsViewType_CreateMatch)];
    [matchStandardStepper setHidden:(viewType != MatchDetailsViewType_CreateMatch)];
}

-(void)initialCost
{
    [costTextField setUserInteractionEnabled:(viewType == MatchDetailsViewType_CreateMatch)];
    [costOption_Referee setEnabled:(viewType == MatchDetailsViewType_CreateMatch)];
    [costOption_Water setEnabled:(viewType == MatchDetailsViewType_CreateMatch)];
}

-(void)initialMatchScore
{
    [scoreTextField initialTextFieldForMatchScore];
    [scoreTextField setIsRegularMatch:(viewType != MatchDetailsViewType_CreateMatch)];
    [scoreTextField presetHomeScore:3 andAwayScore:1];
    [scoreTextField setUserInteractionEnabled:(viewType == MatchDetailsViewType_CreateMatch)];
}

-(void)matchTimeSelected
{
    //Fill the date to matchTime textfield
    [matchTimeTextField setText:[dateFormatter stringFromDate:matchTimePicker.date]];
    
    //Refresh controller status after matchTime entered
    NSTimeInterval timeInterval = [matchTimePicker.date timeIntervalSinceNow];
    if (timeInterval < 0) {
        //MatchTime is Passed now
        if (creationProgress == MatchDetailsCreationProgress_Future_WithOppo) {
            //MatchTime is changed from Future
            [matchOpponentTextField setText:nil];
        }
        creationProgress = MatchDetailsCreationProgress_Passed;
    }
    else {
        //MatchTime is Future now
        if (creationProgress == MatchDetailsCreationProgress_Passed) {
            [matchOpponentTextField setText:nil];
            [self formatMatchOpponent:NO];
        }
        if (creationProgress != MatchDetailsCreationProgress_Future_WithOppo) {
            creationProgress = MatchDetailsCreationProgress_Future_WithoutOppo;
        }
    }
    [self.tableView reloadData];
}

-(void)standardStepperChanged
{
    [matchStandardTextField setText:[NSNumber numberWithDouble:matchStandardStepper.value].stringValue];
}

-(IBAction)dismissKeyboard:(UITapGestureRecognizer *)tapGestureRecognizer
{
    for (UITextField *textField in textFields) {
        [textField resignFirstResponder];
    }
}

-(IBAction)acceptMatchNoticeButtonOnClicked:(id)sender {
    [connection replyMatchNotice:matchData.matchMessage.messageId withAnswer:YES];
}

-(IBAction)refuseMatchNoticeButtonOnClicked:(id)sender {
    [connection replyMatchNotice:matchData.matchMessage.messageId withAnswer:NO];
}

-(IBAction)acceptMatchInvitationButtonOnClicked:(id)sender {
    [connection replyMatchInvitation:matchData.matchMessage withAnswer:YES];
}

-(IBAction)refuseMatchInvitationButtonOnClicked:(id)sender {
    [connection replyMatchInvitation:matchData.matchMessage withAnswer:NO];
}

-(IBAction)createMatchButtonOnClicked:(id)sender {
    NSMutableDictionary *newMatch = [NSMutableDictionary new];
    [newMatch setObject:@"" forKey:kMatch_matchTitle];
    [newMatch setObject:[NSNumber numberWithInteger:[matchTimePicker.date timeIntervalSince1970]] forKey:kMatch_beginTime];
    [newMatch setObject:[NSNumber numberWithInteger:gMyUserInfo.team.teamId] forKey:kMatch_homeTeamId];
    [newMatch setObject:[NSNumber numberWithInteger:selectedOpponentTeam.teamId] forKey:kMatch_awayTeamId];
    [newMatch setObject:matchStandardTextField.text forKey:kMatch_matchStandard];
    [newMatch setObject:costTextField.text forKey:kMatch_cost];
    [newMatch setObject:[NSNumber numberWithBool:costOption_Referee.isOn] forKey:kMatch_withReferee];
    [newMatch setObject:[NSNumber numberWithBool:costOption_Water.isOn] forKey:kMatch_withWater];
    [newMatch setObject:[NSNumber numberWithInteger:gMyUserInfo.userId] forKey:kMatch_organizerId];
    [newMatch setObject:[NSNumber numberWithInteger:matchStadiumTextFiedld.selectedStadium.stadiumId] forKey:kMatch_fieldId];
    [connection createMatchWithRealTeam:newMatch];
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:matchOpponentTextField]) {
        if ([textField hasText] && creationProgress == MatchDetailsCreationProgress_Future_WithoutOppo) {
            creationProgress = MatchDetailsCreationProgress_Future_WithOppo;
            [self.tableView reloadData];
        }
        else if (![textField hasText] && creationProgress == MatchDetailsCreationProgress_Future_WithOppo) {
            creationProgress = MatchDetailsCreationProgress_Future_WithoutOppo;
            [self.tableView reloadData];
        }
        if (![textField.text isEqualToString:selectedOpponentTeam.teamName]) {
            selectedOpponentTeam = nil;
        }
    }
    else if ([textField isEqual:costTextField]) {
        [costTextField setText:[NSString stringWithFormat:@"%.2f", costTextField.text.floatValue]];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:matchStandardTextField]) {
        return NO;
    }
    else {
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            if ([cell.contentView.subviews containsObject:textField]) {
                [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
        return YES;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:costTextField]) {
        NSString *potentialString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *potentialStringArray = [potentialString componentsSeparatedByString:@"."];
        if (potentialStringArray.count > 2) {
            return NO;
        }
        else if (potentialStringArray.count < 2) {
            return YES;
        }
        else {
            NSString *decimalString = potentialStringArray.lastObject;
            return decimalString.length <= 2;
        }
    }
    else if ([textField isEqual:matchOpponentTextField]) {
        [self formatMatchOpponent:[[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:selectedOpponentTeam.teamName]];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!matchData && viewType != MatchDetailsViewType_CreateMatch) {
        return 0;
    }
    
    if ([tableView isEqual:self.tableView]) {
        switch (viewType) {
            case MatchDetailsViewType_CreateMatch:
                switch (creationProgress) {
                    case MatchDetailsCreationProgress_Initial:
                        [createMatchButton setTitle:[gUIStrings objectForKey:@"UI_MatchDetails_ActionButton_CreateFinishedMatch"]];
                        return 1;
                    case MatchDetailsCreationProgress_Passed:
                        [createMatchButton setTitle:[gUIStrings objectForKey:@"UI_MatchDetails_ActionButton_CreateFinishedMatch"]];
                        return [super numberOfSectionsInTableView:tableView];
                    case MatchDetailsCreationProgress_Future_WithoutOppo:
                        [createMatchButton setTitle:[gUIStrings objectForKey:@"UI_MatchDetails_ActionButton_CreateRegularMatch"]];
                        return 1;
                    case MatchDetailsCreationProgress_Future_WithOppo:
                        [createMatchButton setTitle:[gUIStrings objectForKey:@"UI_MatchDetails_ActionButton_CreateRegularMatch"]];
                        return 2;
                    default:
                        return 0;
                }
            case MatchDetailsViewType_ViewDetails:
                if (matchData.status == 4 || matchData.status == 5) {
                    return [super numberOfSectionsInTableView:tableView];
                }
                else {
                    return [super numberOfSectionsInTableView:tableView] - 1;
                }
            case MatchDetailsViewType_MatchInvitation:
            case MatchDetailsViewType_MatchNotice:
                switch (matchData.status) {
                    case 1:
                    case 2:
                    case 3:
                        return [super numberOfSectionsInTableView:tableView] - 1;
                        break;
                    default:
                        return [super numberOfSectionsInTableView:tableView];
                        break;
                }
                break;
            default:
                return [super numberOfSectionsInTableView:tableView];
        }
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        switch (viewType) {
            case MatchDetailsViewType_CreateMatch:
                switch (creationProgress) {
                    case MatchDetailsCreationProgress_Initial:
                        return 1;
                    case MatchDetailsCreationProgress_Passed:
                        return [super tableView:tableView numberOfRowsInSection:section];
                    case MatchDetailsCreationProgress_Future_WithoutOppo:
                        return 2;
                    case MatchDetailsCreationProgress_Future_WithOppo:
                        return [super tableView:tableView numberOfRowsInSection:section];
                    default:
                        return 0;
                }
            case MatchDetailsViewType_ViewDetails:
                return [super tableView:tableView numberOfRowsInSection:section];
            default:
                return [super tableView:tableView numberOfRowsInSection:section];
        }
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

        return cell;
    }
    else {
        static NSString *CellIdentifier = @"MatchScoreCell";
        MatchDetails_MatchScoreDetails_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (viewType == MatchDetailsViewType_ViewDetails) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.contentView.subviews containsObject:matchOpponentTextField]) {
            TeamDetails *teamDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamDetails"];
            [teamDetails setViewType:TeamDetailsViewType_NoAction];
            [teamDetails setTeamData:selectedOpponentTeam];
            [self.navigationController pushViewController:teamDetails animated:YES];
        }
        else if ([cell.contentView.subviews containsObject:matchStadiumTextFiedld]) {
            StadiumDetails *stadiumDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"StadiumDetails"];
            [stadiumDetails setStadium:matchData.matchField];
            [self.navigationController pushViewController:stadiumDetails animated:YES];
        }
    }
    else {
        [self dismissKeyboard:nil];
    }
}

//HintText
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        if (viewType == MatchDetailsViewType_CreateMatch && section == 0) {
            switch (creationProgress) {
                case MatchDetailsCreationProgress_Initial:
                    return [gUIStrings objectForKey:@"Hint_CreateMatch_MatchTime"];
                case MatchDetailsCreationProgress_Future_WithoutOppo:
                    return [gUIStrings objectForKey:@"Hint_CreateMatch_MatchOpponent"];
                default:
                    return nil;
            }
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)view;
    [footerView.textLabel setTextColor:[UIColor whiteColor]];
    [footerView.contentView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f]];
    [footerView.layer setCornerRadius:10.0f];
    [footerView.layer setMasksToBounds:YES];
}

-(void)formatMatchOpponent:(BOOL)isRealTeam
{
    if (isRealTeam) {
        [matchOpponentTextField setTextColor:[UIColor orangeColor]];
        UIImageView *selectedTeamLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, matchOpponentTextField.frame.size.height, matchOpponentTextField.frame.size.height)];
        [selectedTeamLogo setImage:selectedOpponentTeam.teamLogo?selectedOpponentTeam.teamLogo:def_defaultTeamLogo];
        [selectedTeamLogo.layer setCornerRadius:5.0f];
        [selectedTeamLogo.layer setMasksToBounds:YES];
        [matchOpponentTextField setLeftView:selectedTeamLogo];
    }
    else {
        [matchOpponentTextField setTextColor:[UIColor blackColor]];
        [matchOpponentTextField setLeftView:nil];
    }
}

//TeamMarketSelectionDelegate
-(void)selectedOpponentTeam:(Team *)selectedTeam
{
    [matchOpponentTextField setText:selectedTeam.teamName];
    selectedOpponentTeam = selectedTeam;
    [self formatMatchOpponent:YES];
    [self textFieldDidEndEditing:matchOpponentTextField];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SelectOpponentViaTeamMarket"]) {
        TeamMarket *teamMarket = (TeamMarket *)segue.destinationViewController;
        [teamMarket setViewType:TeamMarketViewType_CreateMatch];
    }
}

@end
