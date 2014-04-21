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

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)actionButtonOnClicked:(id)sender
{
    NSLog([[(UIButton *)sender titleLabel] text]);
}
@end

#pragma Captain_MatchArrangmentList
@interface Captain_MatchArrangementList ()

@end

@implementation Captain_MatchArrangementList{
    NSMutableArray *matchData;
    NSIndexPath *indexPathOfCancelMatch;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    WebUtils *getDataConnection = [[WebUtils alloc] initWithServerURL:def_serverURL andDelegate:self];
    [getDataConnection requestData:def_JSONSuffix_allMatches forSelector:@selector(matchesListDataReceived:)];
}

-(void)matchesListDataReceived:(NSData *)data
{
    matchData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [self.tableView reloadData];
}

-(void)retrieveData:(NSData *)data forSelector:(SEL)selector
{
    if ([self canPerformAction:selector withSender:self]) {
        [self performSelectorInBackground:selector withObject:data];
    }
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
    return matchData.count;
}


- (Captain_MatchArrangementListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Captain_MatchArrangementListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Captain_MatchArrangementListCell"];
    NSDictionary *cellData = [matchData objectAtIndex:indexPath.row];
    
//    NSLog(@"%li, %@", indexPath.row, [cellData objectForKey:@"announcable"]);

    // Configure the cell...
    [cell.numberOfPlayers setText:[NSString stringWithFormat:@"%li/10", (long)indexPath.row]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *matchDate = [dateFormatter dateFromString:[cellData objectForKey:@"date"]];
    NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
    [outputDateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSDateFormatter *outputTimeFormatter = [[NSDateFormatter alloc] init];
    [outputTimeFormatter setDateFormat:@"HH:mm"];
    [cell.matchDate setText:[outputDateFormatter stringFromDate:matchDate]];
    [cell.matchTime setText:[outputTimeFormatter stringFromDate:matchDate]];
    
    [cell.matchOpponent setText:[[cellData objectForKey:@"teamB"] objectForKey:@"teamName"]];
    [cell.matchPlace setText:[cellData objectForKey:@"place"]];
    [cell.matchType setText:@"11人制"];
    [cell.actionButton.layer setCornerRadius:3.0f];
    switch (indexPath.row%3) {
        case 0:
            [cell.actionButton setTitle:@"通知球员" forState:UIControlStateNormal];
            [cell.actionButton setBackgroundColor:def_actionButtonColor_BeforeMatch];
            [cell.typeOfPlayerNumber setText:def_typeOfPlayerNumber_SignUp];
            [cell setBackgroundColor:def_backgroundColor_BeforeMatch];
            [cell.matchResult setHidden:YES];
            [cell.actionIcon setHidden:NO];
            [cell setAnnouncable:YES];
            [cell setRecordable:NO];
            break;
        case 1:
            [cell.actionButton setTitle:@"数据记录" forState:UIControlStateNormal];
            [cell.actionButton setBackgroundColor:def_actionButtonColor_AfterMatch];
            [cell.typeOfPlayerNumber setText:def_typeOfPlayerNumber_ShowUp];
            [cell setBackgroundColor:def_backgroundColor_AfterMatch];
            [cell.matchResult setHidden:YES];
            [cell.actionIcon setHidden:NO];
            [cell setAnnouncable:NO];
            [cell setRecordable:YES];
            break;
        case 2:
            [cell.actionButton setTitle:@"详细" forState:UIControlStateNormal];
            [cell.actionButton setBackgroundColor:def_actionButtonColor_FilledDetail];
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
        [matchData removeObjectAtIndex:indexPathOfCancelMatch.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathOfCancelMatch] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        [self.tableView setEditing:NO animated:YES];
    }
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

#pragma Captain_MatchArrangement
@interface Captain_MatchArrangement ()

@end

@implementation Captain_MatchArrangement
@synthesize teamIcon, teamName, numberOfTeamMembers;

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
    
    //Set TeamInfo
    [teamIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamIcon.layer setBorderWidth:2.0f];
    [teamIcon.layer setCornerRadius:teamIcon.bounds.size.width/2];
    [teamIcon.layer setMasksToBounds:YES];
    [teamName setText:[[myUserInfo objectForKey:@"team"] objectForKey:@"teamName"]];
}

-(IBAction)menuButtonOnClicked:(id)sender
{
    id<MainMenuAppearenceDelegate>delegateOfMenuAppearance = (id)self.navigationController;
    if (delegateOfMenuAppearance) {
        [delegateOfMenuAppearance menuSwitch];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)createMatchButtonOnClicked:(id)sender
{
    NSLog(@"建立比赛");
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