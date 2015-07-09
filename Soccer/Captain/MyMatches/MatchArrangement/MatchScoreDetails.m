//
//  MatchScoreDetails.m
//  Soccer
//
//  Created by Andy Xu on 15/3/12.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "MatchScoreDetails.h"

@implementation MatchScoreCell
@synthesize scoreTextField;
@end

@implementation MatchScoreDetailCell
@synthesize scoreDetailTextField;
@end

@interface MatchScoreDetails()
@property IBOutlet UIToolbar *saveBar;
@property IBOutlet UIBarButtonItem *saveButton;
@end

@implementation MatchScoreDetails {
    JSONConnect *connection;
    NSArray *matchAttendenceList;
    NSMutableArray *matchScoreList;
    NSString *scoreTitle;
    NSInteger homeTeamId;
    NSInteger saveProgress;
    Match *newMatchData;
}
@synthesize matchData, editable, delegate, originalMatchScoreList, myScore, opponentScore;
@synthesize saveBar, saveButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)bgImage];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    if (editable) {
        [self setToolbarItems:saveBar.items];
    }
    [self.tableView setAllowsSelection:editable];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!self.toolbarItems.count];
}

- (void)viewDidAppear:(BOOL)animated {
    [self presetData];
}

- (void)presetData {
    if (matchData) {
        newMatchData = [matchData copy];
        if (matchData.beginTime.timeIntervalSince1970 < matchData.createTime.timeIntervalSince1970) {//直接创建的过去比赛
            myScore = matchData.homeTeamGoal;
            opponentScore = matchData.awayTeamGoal;
            homeTeamId = matchData.homeTeam.teamId;
            scoreTitle = [NSString stringWithFormat:@"%@ : %@", matchData.homeTeam.teamName, matchData.awayTeam.teamName];
            [connection requestTeamMembers:gMyUserInfo.team.teamId withTeamFundHistory:NO isSync:YES];
        }
        else {//创建时还未开始的比赛
            if (matchData.matchMessage.messageType == 4) {//临时帮忙的队员
                if (matchData.matchMessage.senderId == matchData.homeTeam.teamId) {
                    myScore = matchData.homeTeamGoal;
                    opponentScore = matchData.awayTeamGoal;
                    homeTeamId = matchData.homeTeam.teamId;
                    scoreTitle = [NSString stringWithFormat:@"%@ : %@", matchData.homeTeam.teamName, matchData.awayTeam.teamName];
                    [connection requestMatchAttendence:matchData.matchId forTeam:matchData.homeTeam.teamId];
                }
                else {
                    myScore = matchData.awayTeamGoal;
                    opponentScore = matchData.homeTeamGoal;
                    homeTeamId = matchData.awayTeam.teamId;
                    scoreTitle = [NSString stringWithFormat:@"%@ : %@", matchData.awayTeam.teamName, matchData.homeTeam.teamName];
                    [connection requestMatchAttendence:matchData.matchId forTeam:matchData.awayTeam.teamId];
                }
            }
            else {
                if (gMyUserInfo.team.teamId == matchData.homeTeam.teamId) {
                    myScore = matchData.homeTeamGoal;
                    opponentScore = matchData.awayTeamGoal;
                    homeTeamId = matchData.homeTeam.teamId;
                    scoreTitle = [NSString stringWithFormat:@"%@ : %@", matchData.homeTeam.teamName, matchData.awayTeam.teamName];
                    [connection requestMatchAttendence:matchData.matchId forTeam:matchData.homeTeam.teamId];
                }
                else {
                    myScore = matchData.awayTeamGoal;
                    opponentScore = matchData.homeTeamGoal;
                    homeTeamId = matchData.awayTeam.teamId;
                    scoreTitle = [NSString stringWithFormat:@"%@ : %@", matchData.awayTeam.teamName, matchData.homeTeam.teamName];
                    [connection requestMatchAttendence:matchData.matchId forTeam:matchData.awayTeam.teamId];
                }
            }
        }
    }
    else {
        [connection requestTeamMembers:gMyUserInfo.team.teamId withTeamFundHistory:NO isSync:YES];
    }
}

- (void)receiveMatchAttendence:(NSArray *)matchAttendence {
    matchAttendenceList = matchAttendence;
    [connection requestMatchScoreDetails:matchData.matchId forTeam:homeTeamId];
}

- (void)receiveTeamMembers:(NSArray *)players {
    matchAttendenceList = players;
    if (matchData) {
        [connection requestMatchScoreDetails:matchData.matchId forTeam:homeTeamId];
    }
    else {
        matchScoreList = [NSMutableArray new];
        
        for (int i = 0; i < myScore; i++) {
            if (i < originalMatchScoreList.count) {
                [matchScoreList addObject:[originalMatchScoreList[i] copy]];
            }
            else {
                [matchScoreList addObject:[NSNull null]];
            }
        }
        [self.tableView reloadData];
        [self checkSaveButtonStatus];
    }
}

- (void)receiveMatchScoreDetails:(NSArray *)matchScoreDetails {
    originalMatchScoreList = matchScoreDetails;
    matchScoreList = [NSMutableArray new];
    
    for (int i = 0; i < myScore; i++) {
        if (i < originalMatchScoreList.count) {
            [matchScoreList addObject:[originalMatchScoreList[i] copy]];
        }
        else {
            [matchScoreList addObject:[NSNull null]];
        }
    }
    [self.tableView reloadData];
    [self checkSaveButtonStatus];
}

- (void)addedMatchScoreDetail:(BOOL)result {
    if (result) {
        saveProgress--;
        if (saveProgress == 0) {
            [self updateMatchScore];
        }
    }
    else {
        NSLog(@"Failed");
    }
}

- (void)updatedMatchScoreDetail:(BOOL)result {
    if (result) {
        saveProgress--;
        if (saveProgress == 0) {
            [self updateMatchScore];
        }
    }
    else {
        NSLog(@"Failed");
    }
}

- (void)updatedMatchScore:(BOOL)result {
    if (result) {
        NSLog(@"Completed");
        [matchData setHomeTeamGoal:newMatchData.homeTeamGoal];
        [matchData setAwayTeamGoal:newMatchData.awayTeamGoal];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSLog(@"Update MatchScore Failed");
    }
}

- (void)updateMatchScore {
    if (newMatchData && (newMatchData.homeTeamGoal != matchData.homeTeamGoal || newMatchData.awayTeamGoal != matchData.awayTeamGoal)) {
        [connection updateMatchScore:matchData.matchId captainId:gMyUserInfo.userId homeScore:newMatchData.homeTeamGoal awayScore:newMatchData.awayTeamGoal];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)saveButtonOnClicked:(id)sender {
    if (matchData) {
        saveProgress = 0;
        for (int i = 0 ; i < myScore; i++) {
            MatchScore *score = matchScoreList[i];
            if (![score isEqual:[NSNull null]]) {
                NSDictionary *scoreDictionary = [score dictionaryForUpdate:(i < originalMatchScoreList.count)?originalMatchScoreList[i]:nil];
                if (scoreDictionary) {
                    if ([scoreDictionary.allKeys containsObject:kMatchScore_scoreId]) {
                        [connection updateMatchScoreDetail:scoreDictionary];
                    }
                    else {
                        [connection addMatchScoreDetail:scoreDictionary];
                    }
                    saveProgress++;
                }
            }
        }
        if (saveProgress == 0) {
            [self updateMatchScore];
        }
    }
    else {
        //New Match
        if (!delegate) {
            delegate = (id)self.parentViewController;
        }
        [delegate saveScoreDetails:matchScoreList homeScore:myScore awayScore:opponentScore];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didScoreChangedWithHomeScore:(NSInteger)homeScore andAwayScore:(NSInteger)awayScore {
    if (newMatchData) {
        if (homeTeamId == newMatchData.homeTeam.teamId) {
            [newMatchData setHomeTeamGoal:homeScore];
            [newMatchData setAwayTeamGoal:awayScore];
        }
        else {
            [newMatchData setHomeTeamGoal:awayScore];
            [newMatchData setAwayTeamGoal:homeScore];
        }
    }
    if (!matchScoreList) {
        matchScoreList = [NSMutableArray new];
    }
    if (homeScore >= 0) {
        for (NSInteger i = 0; i < homeScore; i++) {
            if (i >= myScore) {
                if (i < matchScoreList.count) {
                    [matchScoreList replaceObjectAtIndex:i withObject:[NSNull null]];
                }
                else {
                    [matchScoreList addObject:[NSNull null]];
                }
            }
        }
        while (matchScoreList.count != homeScore) {
            [matchScoreList removeLastObject];
        }
    }
    
    if (myScore != homeScore) {
        myScore = homeScore;
        opponentScore = awayScore;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        myScore = homeScore;
        opponentScore = awayScore;
    }
    [self checkSaveButtonStatus];
}

- (void)didScoreDetailChanged:(MatchScore *)updatedScore forIndex:(NSInteger)index {
    [matchScoreList replaceObjectAtIndex:index withObject:updatedScore];
    [self checkSaveButtonStatus];
}

- (void)checkSaveButtonStatus {
    [saveButton setEnabled:![matchScoreList containsObject:[NSNull null]]];
    if (saveButton.isEnabled) {
        BOOL noChangeFlag = NO;
        for (MatchScore *matchScore in matchScoreList) {
            if ([matchScoreList indexOfObject:matchScore] < originalMatchScoreList.count) {
                MatchScore *originalMatchScore = [originalMatchScoreList objectAtIndex:[matchScoreList indexOfObject:matchScore]];
                if (matchScore.goalPlayerId != originalMatchScore.goalPlayerId || matchScore.assistPlayerId != originalMatchScore.assistPlayerId) {
                    noChangeFlag = YES;
                    break;
                }
            }
            else {
                noChangeFlag = YES;
                break;
            }
        }
        [saveButton setEnabled:noChangeFlag];
    }
}

//UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return myScore?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        default:
            return myScore;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ScoreCell";
        MatchScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.scoreTextField initialTextFieldForMatchScore:(matchData.status == 4)];
        [cell.scoreTextField presetHomeScore:myScore andAwayScore:opponentScore];
        [cell.scoreTextField setEnabled:editable];
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"ScoreDetailCell";
        MatchScoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (matchAttendenceList) {
            [cell.scoreDetailTextField initialTextFieldForMatchDetailScore:matchScoreList[indexPath.row] withMatchAttendance:matchAttendenceList forMatch:matchData];
            [cell.scoreDetailTextField setTag:indexPath.row];
            [cell.scoreDetailTextField setEnabled:editable];
        }
        
        return cell;
    }
    return nil;
}
  
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView.textLabel setTextColor:[UIColor whiteColor]];
    [headerView.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
//    [headerView setTintColor:[UIColor clearColor]];//Set BackgroundColor to ClearColor for Plain Style
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return scoreTitle?scoreTitle:[gUIStrings objectForKey:@"UI_MatchScoreDetails_ScoreTitle"];
        case 1:
            return [gUIStrings objectForKey:@"UI_MatchScoreDetails_DetailsTitle"];
        default:
            return nil;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell.contentView.subviews containsObject:textField]) {
            [self.tableView selectRowAtIndexPath:[self.tableView indexPathForCell:cell] animated:YES scrollPosition:UITableViewScrollPositionTop];
            break;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell.contentView.subviews containsObject:textField]) {
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForCell:cell] animated:YES];
            break;
        }
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[MatchScoreCell class]]) {
            MatchScoreCell *matchScoreCell = (MatchScoreCell *)cell;
            [matchScoreCell.scoreTextField resignFirstResponder];
        }
        else if ([cell isKindOfClass:[MatchScoreDetailCell class]]) {
            MatchScoreDetailCell *matchScoreDetailCell = (MatchScoreDetailCell *)cell;
            [matchScoreDetailCell.scoreDetailTextField resignFirstResponder];
        }
    }
}

@end
