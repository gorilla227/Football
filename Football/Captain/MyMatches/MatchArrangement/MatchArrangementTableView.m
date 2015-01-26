//
//  MatchArrangementTableView.m
//  Football
//
//  Created by Andy on 14/11/17.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MatchArrangementTableView.h"

#pragma MatchArrangementTableView_Cell
@interface MatchArrangementTableView_Cell ()
@property IBOutlet UILabel *numberOfPlayersLabel;
@property IBOutlet UILabel *matchOpponentLabel;
@property IBOutlet UILabel *matchStadiumLabel;
@property IBOutlet UILabel *matchStandardLabel;
@property IBOutlet UIImageView *actionIcon;
@property IBOutlet UIButton *actionButton;
@property IBOutlet UILabel *matchDateAndTimeLabel;
@end

@implementation MatchArrangementTableView_Cell@synthesize numberOfPlayersLabel, matchOpponentLabel, matchStadiumLabel, matchStandardLabel, actionIcon, actionButton, matchDateAndTimeLabel;
@synthesize matchData, delegate;

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    [actionButton.layer setCornerRadius:5.0f];
    [actionButton.layer setMasksToBounds:YES];
    
    [actionButton setBackgroundColor:cMatchCellNoticeButtonBG];
    [matchDateAndTimeLabel setBackgroundColor:cMatchCellMatchTimeBG];
    [matchDateAndTimeLabel setTextColor:cMatchCellMatchTimeFont];
}

-(IBAction)actionButtonOnClicked:(id)sender {
    UIActionSheet *activeSheet = [[UIActionSheet alloc] initWithTitle:@"请选择要通知的人员" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我的队员", @"临时帮忙", nil];
    [activeSheet showInView:actionButton];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [delegate noticeTeamMembers:matchData];
            break;
            
        default:
            break;
    }
}
@end

#pragma MatchArrangementTableView
@interface MatchArrangementTableView ()

@end

@implementation MatchArrangementTableView{
    JSONConnect *connection;
    NSMutableArray *matchesList;
    NSInteger cancelledMatchIndex;
    NSDictionary *attri_NumberOfNotices;
    NSDictionary *attri_DescOfNotices;
    NSInteger tabViewControllerIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    matchesList = [NSMutableArray new];
    attri_NumberOfNotices = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:28] forKey:NSFontAttributeName];
    attri_DescOfNotices = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    
    //Request matches
    tabViewControllerIndex = [self.tabBarController.viewControllers indexOfObject:self];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    switch (tabViewControllerIndex) {
        case 0:
            [connection requestMatchesByTeamId:gMyUserInfo.team.teamId inStatus:@[[NSNumber numberWithInteger:3]] sort:1 count:5 startIndex:0 isSync:YES];
            break;
        case 1:
            [connection requestMatchesByTeamId:gMyUserInfo.team.teamId inStatus:@[[NSNumber numberWithInteger:4], [NSNumber numberWithInteger:5]] sort:2 count:5 startIndex:0 isSync:YES];
            break;
        default:
            break;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveMatchesSuccessfully:(NSArray *)matches
{
    [matchesList addObjectsFromArray:matches];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return matchesList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"MatchArrangementCell_%@", self.restorationIdentifier];
    MatchArrangementTableView_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Match *matchData = [matchesList objectAtIndex:indexPath.section];
    Team *opponent = (matchData.homeTeam.teamId == gMyUserInfo.team.teamId)?matchData.awayTeam:matchData.homeTeam;
    
    // Configure the cell...
    [cell setDelegate:(id)self.parentViewController.parentViewController];
    [cell setMatchData:matchData];
    [cell.matchOpponentLabel setText:opponent.teamName];
    [cell.matchStadiumLabel setText:matchData.matchField.stadiumName];
    [cell.matchStandardLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MatchArrangement_MatchType"], [NSNumber numberWithInteger:matchData.matchStandard].stringValue]];
    [cell.matchDateAndTimeLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MatchArrangement_BeginTimeString"], matchData.beginTimeLocal]];
    
    NSString *numberOfNoticeString = [NSString stringWithFormat:@"%@/%@/%@", matchData.confirmedMember, matchData.confirmedTemp, matchData.sentMatchNotices];
    NSString *descOfNoticeString = @" - 参加/临时/通知";
    NSMutableAttributedString *numberOfPlayersString = [[NSMutableAttributedString alloc] initWithString:[numberOfNoticeString stringByAppendingString:descOfNoticeString]];
    [numberOfPlayersString setAttributes:attri_NumberOfNotices range:[numberOfPlayersString.string rangeOfString:numberOfNoticeString]];
    [numberOfPlayersString setAttributes:attri_DescOfNotices range:[numberOfPlayersString.string rangeOfString:descOfNoticeString]];
    [cell.numberOfPlayersLabel setAttributedText:numberOfPlayersString];
    
    
    [cell.actionIcon setTintColor:[UIColor whiteColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    [cell setBackgroundColor:cMatchCellBG];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (tabViewControllerIndex == 0) {
        return YES;
    }
    else {
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        UIAlertView *confirmMatchCancel = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:[gUIStrings objectForKey:@"UI_MatchArrangement_ConfirmMessage"]
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:[gUIStrings objectForKey:@"UI_MatchArrangement_ConfirmOK"],[gUIStrings objectForKey:@"UI_MatchArrangement_ConfirmCancel"], nil];
        cancelledMatchIndex = indexPath.section;
        [confirmMatchCancel setCancelButtonIndex:1];
        [confirmMatchCancel show];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
     return [gUIStrings objectForKey:@"UI_MatchArrangement_CancelTitle"];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HeaderView"];
    }
    [headerView setBackgroundView:[[UIView alloc] initWithFrame:headerView.bounds]];
    [headerView.backgroundView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}
 
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //Cancel the match
        Match *cancelMatch = [matchesList objectAtIndex:cancelledMatchIndex];
        [connection updateMatchStatus:6 organizer:gMyUserInfo.userId match:cancelMatch.matchId];
    }
    else {
        [self.tableView setEditing:NO animated:YES];
    }
}

-(void)updateMatchStatusSuccessfully
{
    [matchesList removeObjectAtIndex:cancelledMatchIndex];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:cancelledMatchIndex] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:cancelledMatchIndex]] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)updateMatchStatusFailed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[gUIStrings objectForKey:@"UI_MatchArrangement_CancelFailedMessage"]
                                                       delegate:nil
                                              cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"]
                                              otherButtonTitles:nil];
    [alertView show];
    [self.tableView setEditing:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
