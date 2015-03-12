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
@property IBOutlet UIView *actionView;
@end

@implementation MatchArrangementTableView_Cell
@synthesize numberOfPlayersLabel, matchOpponentLabel, matchStadiumLabel, matchStandardLabel, actionIcon, actionButton, matchDateAndTimeLabel, actionView;
@synthesize responseType, matchData, delegate, replyMatchInvitationAndNoticeDelegate;

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    [actionButton.layer setCornerRadius:5.0f];
    [actionButton.layer setMasksToBounds:YES];
    
    [actionButton setBackgroundColor:cMatchCellNoticeButtonBG];
    [matchDateAndTimeLabel setBackgroundColor:cMatchCellMatchTimeBG];
    [matchDateAndTimeLabel setTextColor:cMatchCellMatchTimeFont];
    
    [self setAccessoryView:actionView];
}

-(void)pushMatchDetails {
    [delegate viewMatchDetails:matchData forResponseType:self.responseType];
}

-(IBAction)actionButtonOnClicked:(id)sender {
    if (gMyUserInfo.userType && (gMyUserInfo.team.teamId == matchData.homeTeam.teamId || gMyUserInfo.team.teamId == matchData.awayTeam.teamId)) {//比赛双方的队长
        if (matchData.status == 3) {//未开始比赛-通知球员
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_NoticePlayerTitle"]
                                                                     delegate:self
                                                            cancelButtonTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_NoticePlayerCancel"]
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:[gUIStrings objectForKey:@"UI_MatchArrangement_NoticePlayerMyTeamates"], [gUIStrings objectForKey:@"UI_MatchArrangement_NoticePlayerTempFavor"], nil];
            [actionSheet showInView:actionButton];
        }
        else if (matchData.status == 1) {//待确认比赛-回应约赛邀请
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_InvitationResponseTitle"]
                                                                     delegate:self
                                                            cancelButtonTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_InvitationResponseCancel"]
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:[gUIStrings objectForKey:@"UI_MatchArrangement_InvitationResponseAccept"], [gUIStrings objectForKey:@"UI_MatchArrangement_InvitationResponseRefuse"], nil];
            [actionSheet showInView:actionButton];
        }
    }
    else {//比赛双方的球员或临时帮忙的球员
        if (matchData.status == 3) {//未开始比赛-回应参赛邀请
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_PlayerResponseTitle"]
                                                                     delegate:self
                                                            cancelButtonTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_PlayerResponseCancel"]
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:[gUIStrings objectForKey:@"UI_MatchArrangement_PlayerResponseAccept"], [gUIStrings objectForKey:@"UI_MatchArrangement_PlayerResponseRefuse"], nil];
            [actionSheet showInView:actionButton];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (gMyUserInfo.userType && (gMyUserInfo.team.teamId == matchData.homeTeam.teamId || gMyUserInfo.team.teamId == matchData.awayTeam.teamId)) {
        //For Captain
        switch (matchData.status) {
            case 1:
                switch (buttonIndex) {
                    case 0:
                        //接受约战
                        [replyMatchInvitationAndNoticeDelegate replyMatchInvitation:matchData.matchMessage withAnswer:YES];
                        break;
                    case 1:
                        //拒绝约战
                        [replyMatchInvitationAndNoticeDelegate replyMatchInvitation:matchData.matchMessage withAnswer:NO];
                        break;
                    default:
                        break;
                }
                break;
            case 3:
                switch (buttonIndex) {
                    case 0:
                        //通知队员
                        [delegate noticeTeamMembers:matchData];
                        break;
                    case 1:
                        //临时帮忙
                        [delegate noticeTempFavor:matchData];
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    else {
        //For Regular Player
        switch (buttonIndex) {
            case 0:
                //同意参赛
                [replyMatchInvitationAndNoticeDelegate replyMatchNotice:matchData.matchMessage.messageId withAnswer:YES];
                break;
            case 1:
                //拒绝参赛
                [replyMatchInvitationAndNoticeDelegate replyMatchNotice:matchData.matchMessage.messageId withAnswer:NO];
                break;
            default:
                break;
        }
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
    NSDateFormatter *dateFormatter;
    NSInteger count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
//    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self initialWithLabelTexts:@"Default"];
    
    matchesList = [NSMutableArray new];
    count = [[gUIStrings objectForKey:@"matchListCount"] integerValue];
    attri_NumberOfNotices = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:28] forKey:NSFontAttributeName];
    attri_DescOfNotices = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:def_MatchDateAndTimeformat];
    
    //Request matches
    tabViewControllerIndex = [self.tabBarController.viewControllers indexOfObject:self];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated {
    matchesList = [NSMutableArray new];
    [self setLoadMoreStatus:LoadMoreStatus_LoadMore];
    if (!connection.busyIndicatorDelegate) {
        [connection setBusyIndicatorDelegate:(id)self.navigationController];
    }
    [self startLoadingMore];
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

- (BOOL)startLoadingMore {
    if ([super startLoadingMore]) {
        switch (tabViewControllerIndex) {
            case 0:
                if (gMyUserInfo.userType) {
                    [connection requestMatchesByPlayer:gMyUserInfo.userId forTeam:gMyUserInfo.team.teamId inStatus:@[[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], [NSNumber numberWithInteger:3]] sort:1 count:count startIndex:matchesList.count isSync:YES];
                }
                else {
                    [connection requestMatchesByPlayer:gMyUserInfo.userId forTeam:gMyUserInfo.team.teamId inStatus:@[[NSNumber numberWithInteger:3]] sort:1 count:count startIndex:matchesList.count isSync:YES];
                }
                break;
            case 1:
                [connection requestMatchesByPlayer:gMyUserInfo.userId forTeam:gMyUserInfo.team.teamId inStatus:@[[NSNumber numberWithInteger:4]] sort:2 count:count startIndex:matchesList.count isSync:YES];
                break;
            default:
                break;
        }
        return YES;
    }
    return NO;
}

-(void)receiveMatchesSuccessfully:(NSArray *)matches
{
    [matchesList addObjectsFromArray:matches];
    if (matchesList.count == 0) {
        [self finishedLoadingWithNewStatus:LoadMoreStatus_NoData];
    }
    else {
        [self finishedLoadingWithNewStatus:(matches.count == count)?LoadMoreStatus_LoadMore:LoadMoreStatus_NoMoreData];
    }
    [self.tableView reloadData];
}

-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer {
    [connection replyMatchNotice:messageId withAnswer:answer];
}

-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer isSent:(BOOL)result {
    if (result) {
        for (Match *match in matchesList) {
            if (match.matchMessage.messageId == messageId) {
                [match.matchMessage setStatus:answer?2:3];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[matchesList indexOfObject:match] inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
        }
    }
}

-(void)replyMatchInvitation:(Message *)message withAnswer:(BOOL)answer {
    [connection replyMatchInvitation:message withAnswer:answer];
}

-(void)replyMatchInvitation:(Message *)message withAnswer:(BOOL)answer isSent:(BOOL)result {
    if (result) {
        for (Match *match in matchesList) {
            if (match.matchMessage.messageId == message.messageId) {
                [match.matchMessage setStatus:answer?2:3];
                [match setStatus:answer?3:2];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[matchesList indexOfObject:match] inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
        }
    }
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
    NSString *CellIdentifierForCaptain = @"MatchArrangementCell_ForCaptain";
    NSString *CellIdentifierForRegularPlayer = @"MatchArrangementCell_ForRegularPlayer";
    MatchArrangementTableView_Cell *cell;
    Match *matchData = [matchesList objectAtIndex:indexPath.section];
    Team *opponent = (matchData.homeTeam.teamId == gMyUserInfo.team.teamId)?matchData.awayTeam:matchData.homeTeam;
    
    // Configure the cell...
    
    
    if(gMyUserInfo.userType && (gMyUserInfo.team.teamId == matchData.homeTeam.teamId || gMyUserInfo.team.teamId == matchData.awayTeam.teamId)) {
        //For Captain
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierForCaptain forIndexPath:indexPath];
        
        [cell setDelegate:(id)self.navigationController.visibleViewController];
        [cell setReplyMatchInvitationAndNoticeDelegate:self];
        [cell setMatchData:matchData];
        [cell.matchOpponentLabel setText:opponent.teamName];
        [cell.matchStadiumLabel setText:matchData.matchField.stadiumName];
        [cell.matchStandardLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MatchArrangement_MatchType"], [NSNumber numberWithInteger:matchData.matchStandard]]];
        [cell.matchDateAndTimeLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MatchArrangement_BeginTimeString"], [dateFormatter stringFromDate:matchData.beginTime]]];
        
        NSString *numberOfNoticeString = [NSString stringWithFormat:@"%@/%@/%@", matchData.confirmedMember, matchData.confirmedTemp, matchData.sentMatchNotices];
        NSString *descOfNoticeString = [gUIStrings objectForKey:@"UI_MatchArrangement_NoticeString_Desc"];
        NSMutableAttributedString *numberOfPlayersString = [[NSMutableAttributedString alloc] initWithString:[numberOfNoticeString stringByAppendingString:descOfNoticeString]];
        [numberOfPlayersString setAttributes:attri_NumberOfNotices range:[numberOfPlayersString.string rangeOfString:numberOfNoticeString]];
        [numberOfPlayersString setAttributes:attri_DescOfNotices range:[numberOfPlayersString.string rangeOfString:descOfNoticeString]];
        [cell.numberOfPlayersLabel setAttributedText:numberOfPlayersString];
        [cell.actionIcon setTintColor:[UIColor whiteColor]];
        [cell.actionButton setEnabled:YES];
        switch (matchData.status) {
            case 1://待邀请比赛
                if (gMyUserInfo.userId == matchData.organizerId) {//比赛发起方
                    [cell.actionIcon setImage:[UIImage imageNamed:@"matchCell_noticePlayers.png"]];
                    [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_Pending"] forState:UIControlStateNormal];
                    [cell setResponseType:MatchResponseType_Default];
                    [cell.actionButton setEnabled:NO];
                }
                else {//接受约战方
                    [cell.actionIcon setImage:[UIImage imageNamed:@"matchCell_noticePlayers.png"]];
                    [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_ResponseInvitation"] forState:UIControlStateNormal];
                    [cell setResponseType:MatchResponseType_MatchInvitation];
                }
                break;
            case 2://邀请被拒绝比赛
                if (gMyUserInfo.userId == matchData.organizerId) {//比赛发起方
                    [cell.actionIcon setImage:[UIImage imageNamed:@"matchCell_noticePlayers.png"]];
                    [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_OpponentRefused"] forState:UIControlStateNormal];
                    [cell setResponseType:MatchResponseType_Default];
                    [cell.actionButton setEnabled:NO];
                }
                else {//接受约战方
                    [cell.actionIcon setImage:[UIImage imageNamed:@"matchCell_noticePlayers.png"]];
                    [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_Refused"] forState:UIControlStateNormal];
                    [cell setResponseType:MatchResponseType_Default];
                    [cell.actionButton setEnabled:NO];
                }
                break;
            case 3://未开始比赛
                [cell.actionIcon setImage:[UIImage imageNamed:@"matchCell_noticePlayers.png"]];
                [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_NoticePlayer"] forState:UIControlStateNormal];
                [cell setResponseType:MatchResponseType_Default];
                break;
            case 4://已结束比赛
                [cell.actionIcon setImage:[UIImage imageNamed:@"matchCell_fillMatchData.png"]];
                if (opponent.teamId == matchData.awayTeam.teamId) {
                    [cell.actionButton setTitle:matchData.homeTeamGoal < 0?[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_EnterScore"]:[NSString stringWithFormat:@"%@:%@", [NSNumber numberWithInteger:matchData.homeTeamGoal], matchData.awayTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.awayTeamGoal]] forState:UIControlStateNormal];
                }
                else {
                    [cell.actionButton setTitle:matchData.awayTeamGoal < 0?[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_EnterScore"]:[NSString stringWithFormat:@"%@:%@", [NSNumber numberWithInteger:matchData.awayTeamGoal], matchData.homeTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.homeTeamGoal]] forState:UIControlStateNormal];
                }
                [cell setResponseType:MatchResponseType_Default];
                break;
            default:
                break;
        }
    }
    else {
        //For Regular Player
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierForRegularPlayer forIndexPath:indexPath];
        
        [cell setDelegate:(id)self.navigationController.visibleViewController];
        [cell setReplyMatchInvitationAndNoticeDelegate:self];
        [cell setMatchData:matchData];
        [cell.matchOpponentLabel setText:opponent.teamName];
        [cell.matchStadiumLabel setText:matchData.matchField.stadiumName];
        [cell.matchStandardLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MatchArrangement_MatchType"], [NSNumber numberWithInteger:matchData.matchStandard]]];
        [cell.matchDateAndTimeLabel setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MatchArrangement_BeginTimeString"], [dateFormatter stringFromDate:matchData.beginTime]]];
        [cell.actionIcon setTintColor:[UIColor whiteColor]];
        [cell.actionIcon setImage:[UIImage imageNamed:@"matchCell_fillMatchData.png"]];
        switch (matchData.status) {
            case 3://未开始比赛
                if (matchData.matchMessage) {
                    switch (matchData.matchMessage.status) {
                        case 0:
                        case 1:
                            [cell.actionButton setEnabled:YES];
                            [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_ResponseNotice"] forState:UIControlStateNormal];
                            [cell setResponseType:MatchResponseType_MatchNotice];
                            break;
                        case 2:
                            [cell.actionButton setEnabled:NO];
                            [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_Accepted"] forState:UIControlStateNormal];
                            [cell setResponseType:MatchResponseType_Default];
                            break;
//                        case 3:
//                            [cell.actionButton setEnabled:NO];
//                            [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_Refused"] forState:UIControlStateNormal];
//                            [cell setResponseType:MatchResponseType_Default];
//                            break;
                        case 4:
                            [cell.actionButton setEnabled:NO];
                            [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_Expired"] forState:UIControlStateNormal];
                            [cell setResponseType:MatchResponseType_Default];
                        default:
                            break;
                    }
                }
                else {
                    [cell.actionButton setEnabled:NO];
                    [cell.actionButton setTitle:[gUIStrings objectForKey:@"UI_MatchArrangement_ActionButton_NotInvited"] forState:UIControlStateNormal];
                    [cell setResponseType:MatchResponseType_Default];
                }
                break;
            case 4://已结束比赛
                [cell.actionButton setEnabled:NO];
                if (opponent.teamId == matchData.awayTeam.teamId) {
                    [cell.actionButton setTitle:[NSString stringWithFormat:@"%@:%@", matchData.homeTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.homeTeamGoal], matchData.awayTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.awayTeamGoal]] forState:UIControlStateNormal];
                }
                else {
                    [cell.actionButton setTitle:[NSString stringWithFormat:@"%@:%@", matchData.awayTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.awayTeamGoal], matchData.homeTeamGoal < 0?@"--":[NSNumber numberWithInteger:matchData.homeTeamGoal]] forState:UIControlStateNormal];
                }
                [cell setResponseType:MatchResponseType_Default];
                break;
            default:
                break;
        }
    }
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchArrangementTableView_Cell *selectedCell = (MatchArrangementTableView_Cell *)[tableView cellForRowAtIndexPath:indexPath];
    [selectedCell pushMatchDetails];
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

-(void)updateMatchStatus:(BOOL)result {
    if (result) {
        [matchesList removeObjectAtIndex:cancelledMatchIndex];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:cancelledMatchIndex] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:cancelledMatchIndex]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[gUIStrings objectForKey:@"UI_MatchArrangement_CancelFailedMessage"]
                                                           delegate:nil
                                                  cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"]
                                                  otherButtonTitles:nil];
        [alertView show];
        [self.tableView setEditing:NO animated:YES];
    }
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
