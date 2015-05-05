    //
//  Captain_MatchArrangement.m
//  Soccer
//
//  Created by Andy on 14-3-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MatchArrangement.h"

#pragma Captain_MatchArrangementListCell
@interface Captain_MatchArrangementListCell ()
@property IBOutlet UILabel *numberOfPlayers;
@property IBOutlet UILabel *typeOfPlayerNumber;
@property IBOutlet UILabel *matchDate;
@property IBOutlet UILabel *matchTime;
@property IBOutlet UILabel *matchOpponent;
@property IBOutlet UILabel *matchPlace;
@property IBOutlet UILabel *matchType;
@property IBOutlet UIImageView *actionIcon;
@property IBOutlet UIButton *actionButton;
@property IBOutlet UILabel *matchResult;
@end

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
@end

#pragma Captain_MatchArrangement
@interface Captain_MatchArrangement ()
@property IBOutlet UITableView *matchesTableView;
@property IBOutlet UIImageView *teamLogo;
@property IBOutlet UILabel *teamName;
@property IBOutlet UILabel *numberOfTeamMembers;
@property IBOutlet UIToolbar *createMatchToolBar;
@end

@implementation Captain_MatchArrangement{
    NSArray *matchesList;
    NSIndexPath *indexPathOfCancelMatch;
    JSONConnect *connection;
}
@synthesize teamLogo, teamName, numberOfTeamMembers, matchesTableView, createMatchToolBar;

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
    //Set Toolbar
    [self setToolbarItems:createMatchToolBar.items];
    
    [matchesTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    matchesList = [NSArray new];
    //Set TeamInfo
    [teamLogo.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogo.layer setBorderWidth:2.0f];
    [teamLogo.layer setCornerRadius:10.0f];
    [teamLogo.layer setMasksToBounds:YES];
    if (gMyUserInfo.team.teamLogo) {
        [teamLogo setImage:gMyUserInfo.team.teamLogo];
    }
    else {
        [teamLogo setImage:def_defaultTeamLogo];
    }
    [teamName setText:gMyUserInfo.team.teamName];
    [numberOfTeamMembers setText:[NSNumber numberWithInteger:gMyUserInfo.team.numOfMember].stringValue];
    
    //Request matches
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
//    [connection requestMatchesByTeamId:gMyUserInfo.team.teamId count:0 startIndex:0 isSync:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

-(void)receiveMatchesSuccessfully:(NSArray *)matches
{
    matchesList = [matchesList arrayByAddingObjectsFromArray:matches];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Captain_MatchArrangementListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Captain_MatchArrangementListCell"];
    Match *matchData = [matchesList objectAtIndex:indexPath.row];
    Team *opponentTeam = (matchData.homeTeam.teamId == gMyUserInfo.team.teamId)?matchData.awayTeam:matchData.homeTeam;
    NSInteger myTeamGoal = (matchData.homeTeam.teamId == gMyUserInfo.team.teamId)?matchData.homeTeamGoal:matchData.awayTeamGoal;
    NSInteger opponentTeamGoal = (matchData.homeTeam.teamId == gMyUserInfo.team.teamId)?matchData.awayTeamGoal:matchData.homeTeamGoal;
    
    // Configure the cell...
    [cell.numberOfPlayers setText:[NSString stringWithFormat:@"%li/10", (long)indexPath.row]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_JSONDateformat];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:def_MatchDateformat];
    NSDateFormatter *outputTimeFormatter = [[NSDateFormatter alloc] init];
    [outputTimeFormatter setDateFormat:def_MatchTimeformat];
    [cell.matchDate setText:[outputDateFormatter stringFromDate:matchData.beginTime]];
    [cell.matchTime setText:[outputTimeFormatter stringFromDate:matchData.beginTime]];
    
    [cell.matchOpponent setText:opponentTeam.teamName];
    [cell.matchPlace setText:matchData.matchField.stadiumName];
    [cell.matchType setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MatchArrangement_MatchType"], [NSNumber numberWithInteger:matchData.matchStandard]]];
    
    //Config cell base on matchStatus
    switch (matchData.status) {
        case 3:
            //未开始-通知队员
            [cell.actionButton setTitle:def_MA_actionButton_announce forState:UIControlStateNormal];
            [cell.actionButton setBackgroundColor:def_actionButtonColor_BeforeMatch];
            [cell.actionButton addTarget:self action:@selector(actionButtonOnClicked_announce:) forControlEvents:UIControlEventTouchUpInside];
            [cell.actionButton setTag:indexPath.row];
            [cell.typeOfPlayerNumber setText:def_typeOfPlayerNumber_SignUp];
            [cell setBackgroundColor:def_backgroundColor_BeforeMatch];
            [cell.matchResult setHidden:YES];
            [cell.actionIcon setImage:[UIImage imageNamed:@"icon_noticePlayers.png"]];
            [cell.actionIcon setHidden:NO];
//            [cell setAnnouncable:YES];
//            [cell setRecordable:NO];
            break;
        case 4:
            if (myTeamGoal == -1) {
                //已结束-未输入结果
                [cell.actionButton setTitle:def_MA_actionButton_record forState:UIControlStateNormal];
                [cell.actionButton setBackgroundColor:def_actionButtonColor_AfterMatch];
                [cell.actionButton addTarget:self action:@selector(actionButtonOnClicked_fillRecord:) forControlEvents:UIControlEventTouchUpInside];
                [cell.actionButton setTag:indexPath.row];
                [cell.typeOfPlayerNumber setText:def_typeOfPlayerNumber_ShowUp];
                [cell setBackgroundColor:def_backgroundColor_AfterMatch];
                [cell.matchResult setHidden:YES];
                [cell.actionIcon setImage:[UIImage imageNamed:@"icon_fillMatchData.png"]];
                [cell.actionIcon setHidden:NO];
//                [cell setAnnouncable:NO];
//                [cell setRecordable:YES];
            }
            else {
                //已结束-已输入结果
                [cell.actionButton setTitle:def_MA_actionButton_detail forState:UIControlStateNormal];
                [cell.actionButton setBackgroundColor:def_actionButtonColor_FilledDetail];
                [cell.actionButton addTarget:self action:@selector(actionButtonOnClicked_viewRecord:) forControlEvents:UIControlEventTouchUpInside];
                [cell.actionButton setTag:indexPath.row];
                [cell.typeOfPlayerNumber setText:def_typeOfPlayerNumber_ShowUp];
                [cell setBackgroundColor:def_backgroundColor_FilledDetail];
                [cell.matchResult setHidden:NO];
                [cell.matchResult setText:[NSString stringWithFormat:@"%@:%@", [NSNumber numberWithInteger:myTeamGoal], (opponentTeamGoal == -1)?@"-":[NSNumber numberWithInteger:opponentTeamGoal]]];
                [cell.actionIcon setHidden:YES];
//                [cell setAnnouncable:NO];
//                [cell setRecordable:NO];
            }
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
//    BOOL announcable = (indexPath.row % 3 == 0);
//    if (announcable) {
//        return YES;
//    }
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
//        [matchesList removeObjectAtIndex:indexPathOfCancelMatch.row];
        [matchesTableView deleteRowsAtIndexPaths:@[indexPathOfCancelMatch] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        [matchesTableView setEditing:NO animated:YES];
    }
}

-(void)actionButtonOnClicked_announce:(UIButton *)sender
{
    Match *selectMatch = [matchesList objectAtIndex:sender.tag];
    NSLog(@"Announce: %i", selectMatch.matchId);
}

-(void)actionButtonOnClicked_fillRecord:(UIButton *)sender
{
    Match *selectMatch = [matchesList objectAtIndex:sender.tag];
    NSLog(@"%i", selectMatch.matchId);
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