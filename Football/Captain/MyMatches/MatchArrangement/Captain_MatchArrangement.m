    //
//  Captain_MatchArrangement.m
//  Football
//
//  Created by Andy on 14-3-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MatchArrangement.h"

#pragma Captain_MatchArrangementListCell
@implementation Captain_MatchArrangementListCell
@synthesize numberOfPlayers, typeOfPlayerNumber;
@synthesize matchDate, matchTime, matchOpponent, matchPlace, matchType;
@synthesize actionButton, actionIcon, matchResult;
@synthesize announcable, recordable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [actionButton.layer setCornerRadius:3.0f];
}

- (void)awakeFromNib
{
    // Initialization code
}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}
//
//-(IBAction)actionButtonOnClicked:(id)sender
//{
//    UIButton *actionButton = (UIButton *)sender;
//    NSLog(actionButton.titleLabel.text);
//}
@end

#pragma Captain_MatchArrangement
@interface Captain_MatchArrangement ()

@end

@implementation Captain_MatchArrangement{
    NSMutableArray *matchesList;
    NSIndexPath *indexPathOfCancelMatch;
    JSONConnect *connection;
}
@synthesize teamIcon, teamName, numberOfTeamMembers, matchesTableView;

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
    [matchesTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    matchesList = [[NSMutableArray alloc] init];
    //Set TeamInfo
    [teamIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamIcon.layer setBorderWidth:2.0f];
    [teamIcon.layer setCornerRadius:teamIcon.bounds.size.width/2];
    [teamIcon.layer setMasksToBounds:YES];
//    [teamName setText:gMyUserInfo.team.teamName];
    
    //Request matches
    connection = [[JSONConnect alloc] initWithDelegate:self];
//    [connection requestMatchesByUserId:gMyUserInfo.userId count:JSON_parameter_common_count_default startIndex:JSON_parameter_common_startIndex_default];
    
    //Set menu button
    [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
}

-(void)receiveMatches:(NSArray *)matches
{
    [matchesList addObjectsFromArray:matches];
    [matchesTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return matchesList.count;
}

- (Captain_MatchArrangementListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Captain_MatchArrangementListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Captain_MatchArrangementListCell"];
    Match *matchData = [matchesList objectAtIndex:indexPath.row];
    Team *opponentTeam;
//    if ([matchData.teamA.teamId isEqual:gMyUserInfo.team.teamId]) {
//        opponentTeam = matchData.teamB;
//    }
//    else {
//        opponentTeam = matchData.teamA;
//    }
    
    // Configure the cell...
    [cell.numberOfPlayers setText:[NSString stringWithFormat:@"%li/10", (long)indexPath.row]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_JSONDateformat];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:def_MatchDateformat];
    NSDateFormatter *outputTimeFormatter = [[NSDateFormatter alloc] init];
    [outputTimeFormatter setDateFormat:def_MatchTimeformat];
    [cell.matchDate setText:[outputDateFormatter stringFromDate:matchData.matchDate]];
    [cell.matchTime setText:[outputTimeFormatter stringFromDate:matchData.matchDate]];
    
    [cell.matchOpponent setText:opponentTeam.teamName];
//    [cell.matchPlace setText:matchData.matchPlace];
    if ([matchData.matchType isEqual:[NSNull null]]) {
        [cell.matchType setText:@"未知类型"];
    }
    else {
        [cell.matchType setText:matchData.matchType];
    }
    switch (indexPath.row%3) {
        case 0:
            [cell.actionButton setTitle:def_MA_actionButton_announce forState:UIControlStateNormal];
            [cell.actionButton setBackgroundColor:def_actionButtonColor_BeforeMatch];
            [cell.actionButton addTarget:self action:@selector(actionButtonOnClicked_announce:) forControlEvents:UIControlEventTouchUpInside];
            [cell.actionButton setTag:indexPath.row];
            [cell.typeOfPlayerNumber setText:def_typeOfPlayerNumber_SignUp];
            [cell setBackgroundColor:def_backgroundColor_BeforeMatch];
            [cell.matchResult setHidden:YES];
            [cell.actionIcon setImage:[UIImage imageNamed:@"icon_noticePlayers.png"]];
            [cell.actionIcon setHidden:NO];
            [cell setAnnouncable:YES];
            [cell setRecordable:NO];
            break;
        case 1:
            [cell.actionButton setTitle:def_MA_actionButton_record forState:UIControlStateNormal];
            [cell.actionButton setBackgroundColor:def_actionButtonColor_AfterMatch];
            [cell.actionButton addTarget:self action:@selector(actionButtonOnClicked_fillRecord:) forControlEvents:UIControlEventTouchUpInside];
            [cell.actionButton setTag:indexPath.row];
            [cell.typeOfPlayerNumber setText:def_typeOfPlayerNumber_ShowUp];
            [cell setBackgroundColor:def_backgroundColor_AfterMatch];
            [cell.matchResult setHidden:YES];
            [cell.actionIcon setImage:[UIImage imageNamed:@"icon_fillMatchData.png"]];
            [cell.actionIcon setHidden:NO];
            [cell setAnnouncable:NO];
            [cell setRecordable:YES];
            break;
        case 2:
            [cell.actionButton setTitle:def_MA_actionButton_detail forState:UIControlStateNormal];
            [cell.actionButton setBackgroundColor:def_actionButtonColor_FilledDetail];
            [cell.actionButton addTarget:self action:@selector(actionButtonOnClicked_viewRecord:) forControlEvents:UIControlEventTouchUpInside];
            [cell.actionButton setTag:indexPath.row];
            [cell.typeOfPlayerNumber setText:def_typeOfPlayerNumber_ShowUp];
            [cell setBackgroundColor:def_backgroundColor_FilledDetail];
            [cell.matchResult setHidden:NO];
            [cell.actionIcon setHidden:YES];
            [cell setAnnouncable:NO];
            [cell setRecordable:NO];
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    BOOL announcable = (indexPath.row % 3 == 0);
    if (announcable) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        UIAlertView *confirmMatchCancel = [[UIAlertView alloc] initWithTitle:nil message:@"确定要取消比赛？"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        [confirmMatchCancel setCancelButtonIndex:1];
        indexPathOfCancelMatch = indexPath;
        [confirmMatchCancel show];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消比赛";
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //Cancel the match
        [matchesList removeObjectAtIndex:indexPathOfCancelMatch.row];
        [matchesTableView deleteRowsAtIndexPaths:@[indexPathOfCancelMatch] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        [matchesTableView setEditing:NO animated:YES];
    }
}

-(void)actionButtonOnClicked_announce:(UIButton *)sender
{
    Match *selectMatch = [matchesList objectAtIndex:sender.tag];
    NSLog(@"Announce: %@", selectMatch.matchId);
}

-(void)actionButtonOnClicked_fillRecord:(UIButton *)sender
{
    Match *selectMatch = [matchesList objectAtIndex:sender.tag];
    NSLog(@"%@", selectMatch.matchId);
    [self performSegueWithIdentifier:@"FillRecord" sender:selectMatch];
}

-(void)actionButtonOnClicked_viewRecord:(UIButton *)sender
{
    Match *selectMatch = [matchesList objectAtIndex:sender.tag];
    [self performSegueWithIdentifier:@"ViewRecord" sender:selectMatch];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CreateMatch"]) {
        Captain_CreateMatch *matchView = segue.destinationViewController;
        [matchView setSegueIdentifier:segue.identifier];
    }
    else if ([segue.identifier isEqualToString:@"FillRecord"]) {
        Captain_CreateMatch *matchView = segue.destinationViewController;
        [matchView setSegueIdentifier:segue.identifier];
        [matchView setViewMatchData:sender];
    }
    else if ([segue.identifier isEqualToString:@"ViewRecord"]) {
        Captain_CreateMatch *matchView = segue.destinationViewController;
        [matchView setSegueIdentifier:segue.identifier];
        [matchView setViewMatchData:sender];
    }
    
}


@end