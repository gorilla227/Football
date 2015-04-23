//
//  MessageCenter_Compose.m
//  Football
//
//  Created by Andy Xu on 14-8-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenter_Compose.h"

@interface MessageCenter_Compose ()
@property IBOutlet UITableView *playerListTableView;
@property IBOutlet UITextView *composeTextView;
@property IBOutlet UISegmentedControl *selectionSegment;
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *sendNotificationButton;
@property IBOutlet UIView *sendingProgressView;
@property IBOutlet UIProgressView *sendingProgressBar;
@property IBOutlet UILabel *sendingProgressLabel;
@property IBOutlet UIButton *sendingProgressCancelButton;
@property IBOutlet UIView *sendingProgressBackgroundView;
@property IBOutlet UITextField *matchTextField;
@end

@implementation MessageCenter_Compose{
    JSONConnect *connection;
    NSInteger numOfCompletedMessages;
    NSInteger numOfFailedMessages;
    UIPickerView *matchPicker;
    NSArray *matchList;
    NSDateFormatter *dateFormatter;
    Match *matchData;
}
@synthesize composeType, toList, otherParameters, viewControllerAfterSending;
@synthesize playerListTableView, composeTextView, selectionSegment, actionBar, sendNotificationButton, sendingProgressView, sendingProgressBar, sendingProgressCancelButton, sendingProgressLabel, sendingProgressBackgroundView, matchTextField;

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
    [self setToolbarItems:actionBar.items];
    [composeTextView initializeUITextFieldRoundCornerStyle];
    [playerListTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [matchTextField setTintColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonsStatus) name:UITableViewSelectionDidChangeNotification object:nil];
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:def_MatchDateAndTimeformat];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    [sendingProgressBackgroundView setHidden:YES];
    
    [self presetNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
    
    [self updateButtonsStatus];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [composeTextView resignFirstResponder];
    [matchTextField resignFirstResponder];
}

-(void)presetNotification
{
    NSString *messageTemplateFile = [[NSBundle mainBundle] pathForResource:@"MessageTemplate" ofType:@"plist"];
    NSDictionary *messageTemplate = [[NSDictionary alloc] initWithContentsOfFile:messageTemplateFile];
    
    switch (composeType) {
        case MessageComposeType_Blank:
            if (toList) {
                [self selectAllInToList];
            }
            else {
                [connection requestTeamMembers:gMyUserInfo.team.teamId withTeamFundHistory:NO isSync:YES];
            }
            [playerListTableView setTableHeaderView:nil];
            break;
        case MessageComposeType_Trial:
            [composeTextView setText:[messageTemplate objectForKey:@"Trial_Default"]];
            [self selectAllInToList];
            [playerListTableView setTableHeaderView:nil];
            break;
        case MessageComposeType_Recurit:
            [composeTextView setText:[messageTemplate objectForKey:@"Recruit_Default"]];
            [self selectAllInToList];
            [playerListTableView setTableHeaderView:nil];
            break;
        case MessageComposeType_TemporaryFavor:
            [composeTextView setText:[messageTemplate objectForKey:@"TemporaryFavor_Default"]];
            [self selectAllInToList];
            [playerListTableView setTableHeaderView:matchTextField];
            matchPicker = [UIPickerView new];
            [matchPicker setDelegate:self];
            [matchPicker setDataSource:self];
            [matchTextField setInputView:matchPicker];
            break;
        case MessageComposeType_Applyin:
            [composeTextView setText:[messageTemplate objectForKey:@"Applyin_Default"]];
            [self selectAllInToList];
            [playerListTableView setTableHeaderView:nil];
            break;
        case MessageComposeType_MatchNotice:
            [composeTextView setText:[messageTemplate objectForKey:@"MatchNotice_Default"]];
            [self selectAllInToList];
            [selectionSegment setUserInteractionEnabled:NO];
            [playerListTableView setAllowsSelection:NO];
            [playerListTableView setAllowsMultipleSelection:NO];
            [playerListTableView setTableHeaderView:matchTextField];
            break;
        case MessageComposeType_TeamFundNotice:
            [composeTextView setText:[messageTemplate objectForKey:@"TeamFundNotice_Default"]];
            [self selectAllInToList];
            [selectionSegment setUserInteractionEnabled:YES];
            [playerListTableView setAllowsSelection:YES];
            [playerListTableView setAllowsMultipleSelection:YES];
            [playerListTableView setTableHeaderView:nil];
            break;
        default:
            break;
    }
    
    if (composeType == MessageComposeType_MatchNotice || composeType == MessageComposeType_TemporaryFavor) {
        matchData = [otherParameters objectForKey:@"matchData"];
        if (matchData) {
            [matchTextField setText:[NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:matchData.beginTime], (matchData.homeTeam.teamId == gMyUserInfo.team.teamId)?matchData.awayTeam.teamName:matchData.homeTeam.teamName]];
        }
        else {
            [connection requestMatchesByPlayer:gMyUserInfo.userId forTeam:gMyUserInfo.userId inStatus:@[[NSNumber numberWithInteger:3]] sort:0 count:5 startIndex:0 isSync:YES];
        }
    }
}

-(void)updateButtonsStatus
{
    [self updateSelectionButtonStatus];
    [self updateSendNotificationButtonStatus];
}
-(void)updateSendNotificationButtonStatus
{
    NSString *notificationText = [[composeTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    switch (composeType) {
        case MessageComposeType_MatchNotice:
        case MessageComposeType_TemporaryFavor:
            [sendNotificationButton setEnabled:(playerListTableView.indexPathsForSelectedRows.count && notificationText.length && (matchData || matchList[[matchPicker selectedRowInComponent:0]]))];
            break;
        default:
            [sendNotificationButton setEnabled:(playerListTableView.indexPathsForSelectedRows.count && notificationText.length)];
            break;
    }
    
    if (sendNotificationButton.isEnabled && composeType == MessageComposeType_TemporaryFavor) {
        Match *match = matchData?matchData:matchList[[matchPicker selectedRowInComponent:0]];
        Team *opponentTeam = (match.homeTeam.teamId == gMyUserInfo.team.teamId)?match.awayTeam:match.homeTeam;
        for (NSIndexPath *indexPath in playerListTableView.indexPathsForSelectedRows) {
            UserInfo *selectedPlayer = toList[indexPath.row];
            if (selectedPlayer.team.teamId == opponentTeam.teamId || selectedPlayer.team.teamId == gMyUserInfo.team.teamId) {
                [sendNotificationButton setEnabled:NO];
                return;
            }
        }
    }
}

-(void)updateSelectionButtonStatus
{
    if (toList.count == 0) {
        [selectionSegment setSelectedSegmentIndex:-1];
        [selectionSegment setEnabled:NO];
    }
    else {
        [selectionSegment setEnabled:YES];
        if (playerListTableView.indexPathsForSelectedRows.count == 0) {
            [selectionSegment setSelectedSegmentIndex:1];
        }
        else if (playerListTableView.indexPathsForSelectedRows.count == toList.count) {
            [selectionSegment setSelectedSegmentIndex:0];
        }
        else {
            [selectionSegment setSelectedSegmentIndex:-1];
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self updateSendNotificationButtonStatus];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [playerListTableView setUserInteractionEnabled:NO];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [playerListTableView setUserInteractionEnabled:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !matchData;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return matchList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Match *match = matchList[row];
    return [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:match.beginTime], (match.homeTeam.teamId == gMyUserInfo.team.teamId)?match.awayTeam.teamName:match.homeTeam.teamName];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Match *match = matchList[row];
    [matchTextField setText:[NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:match.beginTime], (match.homeTeam.teamId == gMyUserInfo.team.teamId)?match.awayTeam.teamName:match.homeTeam.teamName]];
    [self updateSendNotificationButtonStatus];
    [matchTextField resignFirstResponder];
}

-(IBAction)selectAllOrSelectNone:(id)sender
{
    switch (selectionSegment.selectedSegmentIndex) {
        case 0:
            [self selectAllInToList];
            break;
        case 1:
            [self unselectAllInToList];
            break;
        default:
            break;
    }
}

-(void)selectAllInToList
{
    for (int i = 0; i < toList.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [playerListTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell = [playerListTableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UITableViewSelectionDidChangeNotification object:nil];
}

-(void)unselectAllInToList
{
    for (NSIndexPath *indexPath in playerListTableView.indexPathsForSelectedRows) {
        [playerListTableView deselectRowAtIndexPath:indexPath animated:NO];
        UITableViewCell *cell = [playerListTableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UITableViewSelectionDidChangeNotification object:nil];
}

-(void)receiveTeamMembers:(NSArray *)players
{
    toList = players;
    [playerListTableView reloadData];
    [self selectAllInToList];
    [self updateButtonsStatus];
}

-(void)receiveMatchesSuccessfully:(NSArray *)matches {
    matchList = matches;
}

-(IBAction)sendNotificationButtonOnClicked:(id)sender
{
    [sendingProgressBackgroundView setHidden:NO];
    [sendingProgressBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [sendingProgressView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.85]];
    [sendingProgressView.layer setCornerRadius:20.0f];
    [sendingProgressView.layer setMasksToBounds:YES];
    [sendingProgressView setOpaque:YES];
    [sendingProgressBar setProgress:0];
    [sendingProgressLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_Message_SendingProgress_Label"], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:toList.count]]];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [self.navigationController.toolbar setUserInteractionEnabled:NO];
    numOfCompletedMessages = 0;
    numOfFailedMessages = 0;
    
    switch (composeType) {
        case MessageComposeType_Blank:
            break;
        case MessageComposeType_Trial:
            break;
        case MessageComposeType_Recurit:
            for (UserInfo *playerForMessage in toList) {
                [connection callinFromTeam:gMyUserInfo.team.teamId toPlayer:playerForMessage.userId withMessage:composeTextView.text];
            }
            break;
        case MessageComposeType_TemporaryFavor:
            if (!matchData) {
                matchData = matchList[[matchPicker selectedRowInComponent:0]];
            }
            for (UserInfo *playerForMessage in toList) {
                [connection sendMatchNotice:matchData.matchId fromTeam:gMyUserInfo.team.teamId toPlayer:playerForMessage.userId withMessage:composeTextView.text];
            }
            break;
        case MessageComposeType_Applyin:
            for (Team *teamForMessage in toList) {
                [connection applyinFromPlayer:gMyUserInfo.userId toTeam:teamForMessage.teamId withMessage:composeTextView.text];
            }
            break;
        case MessageComposeType_MatchNotice:
            for (UserInfo *playerForMessage in toList) {
                [connection sendMatchNotice:matchData.matchId fromTeam:gMyUserInfo.team.teamId toPlayer:playerForMessage.userId withMessage:composeTextView.text];
            }
            break;
        case MessageComposeType_TeamFundNotice:
            
            break;
        default:
            break;
    }
}

-(IBAction)sendingProgressCancelButtonOnClicked:(id)sender
{
    [connection cancelAllOperations];
    [sendingProgressBackgroundView setHidden:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [self.navigationController.toolbar setUserInteractionEnabled:YES];
    if (viewControllerAfterSending) {
        [self.navigationController popToViewController:viewControllerAfterSending animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//-(void)playerApplyinSent
//{
//    numOfCompletedMessages++;
//    [sendingProgressLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_Message_SendingProgress_Label"], [NSNumber numberWithInteger:numOfCompletedMessages], [NSNumber numberWithInteger:toList.count]]];
//    [sendingProgressBar setProgress:numOfCompletedMessages/toList.count animated:YES];
//    if (numOfCompletedMessages + numOfFailedMessages == toList.count) {
//        [sendingProgressBackgroundView setHidden:YES];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_FindTeam_Successful_Message"]         delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
//        [alertView show];
//    }
//}
//
//-(void)playerApplyinFailed
//{
//    numOfFailedMessages++;
//    if (numOfCompletedMessages + numOfFailedMessages == toList.count) {
//        [sendingProgressBackgroundView setHidden:YES];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_FindTeam_SendingResultMessage"], [NSNumber numberWithInteger:numOfCompletedMessages], [NSNumber numberWithInteger:toList.count]] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
//        [alertView show];
//    }
//}

//-(void)teamCallinSent
//{
//    numOfCompletedMessages++;
//    [sendingProgressLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_Message_SendingProgress_Label"], [NSNumber numberWithInteger:numOfCompletedMessages], [NSNumber numberWithInteger:toList.count]]];
//    [sendingProgressBar setProgress:numOfCompletedMessages/toList.count animated:YES];
//    if (numOfCompletedMessages + numOfFailedMessages == toList.count) {
//        [sendingProgressBackgroundView setHidden:YES];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_Callin_SendingResultMessage"], [NSNumber numberWithInteger:numOfCompletedMessages], [NSNumber numberWithInteger:toList.count]] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
//        [alertView show];
//    }
//}
//
//-(void)teamCallinFailed
//{
//    numOfFailedMessages++;
//    if (numOfCompletedMessages + numOfFailedMessages == toList.count) {
//        [sendingProgressBackgroundView setHidden:YES];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_Callin_SendingResultMessage"], [NSNumber numberWithInteger:numOfCompletedMessages], [NSNumber numberWithInteger:toList.count]] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
//        [alertView show];
//    }
//}

-(void)playerApplyinSent:(BOOL)result
{
    [self updateMessageProgress:result];
    
    if (numOfCompletedMessages + numOfFailedMessages == toList.count) {
        [self composeSent:@"UI_FindTeam_Successful_Message"];
    }
}

-(void)teamCallinSent:(BOOL)result
{
    [self updateMessageProgress:result];
    
    if (numOfCompletedMessages + numOfFailedMessages == toList.count) {
        [self composeSent:@"UI_Callin_SendingResultMessage"];
    }
}

-(void)matchNoticeSent:(BOOL)result
{
    [self updateMessageProgress:result];
    
    if (numOfCompletedMessages + numOfFailedMessages == toList.count) {
        [self composeSent:@"UI_MatchNotice_SendingResultMessage"];
    }
}

-(void)updateMessageProgress:(BOOL)messageResult
{
    if (messageResult) {
        numOfCompletedMessages++;
        [sendingProgressLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_Message_SendingProgress_Label"], [NSNumber numberWithInteger:numOfCompletedMessages], [NSNumber numberWithInteger:toList.count]]];
        [sendingProgressBar setProgress:numOfCompletedMessages/toList.count animated:YES];
    }
    else {
        numOfFailedMessages++;
    }
}

-(void)composeSent:(NSString *)alertMessageKey
{
    [sendingProgressBackgroundView setHidden:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:[gUIStrings objectForKey:alertMessageKey], [NSNumber numberWithInteger:numOfCompletedMessages], [NSNumber numberWithInteger:toList.count]] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    [self.navigationController.toolbar setUserInteractionEnabled:YES];
    if (viewControllerAfterSending) {
        [self.navigationController popToViewController:viewControllerAfterSending animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return toList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (composeType == MessageComposeType_Applyin) {
        Team *teamData = [toList objectAtIndex:indexPath.row];
        [cell.textLabel setText:teamData.teamName];
        [cell.imageView setImage:teamData.teamLogo?teamData.teamLogo:def_defaultTeamLogo];
        [cell.imageView.layer setCornerRadius:10.0f];
        [cell.imageView.layer setMasksToBounds:YES];
    }
    else {
        UserInfo *playerData = [toList objectAtIndex:indexPath.row];
        [cell.textLabel setText:playerData.nickName];
        [cell.imageView setImage:playerData.playerPortrait?playerData.playerPortrait:def_defaultPlayerPortrait];
        [cell.imageView.layer setCornerRadius:10.0f];
        [cell.imageView.layer setMasksToBounds:YES];
    }
    if ([tableView.indexPathsForSelectedRows containsObject:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
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
