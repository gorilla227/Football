//
//  Captain_MyPlayers.m
//  Football
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MyPlayers.h"
#import "PlayerDetails.h"
#import "Captain_NotifyPlayers.h"
#import "MessageCenter_Compose.h"

#pragma Captain_MyPlayerCell
@interface Captain_MyPlayerCell ()
@property IBOutlet UIView *checkMarkBackground;
@property IBOutlet UIImageView *playerPortraitImageView;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *positionLabel;
@property IBOutlet UILabel *styleLabel;
@property IBOutlet UILabel *signUpStatusOfNextMatchLabel;
@end

@implementation Captain_MyPlayerCell
@synthesize myPlayer, delegate;
@synthesize checkMarkBackground, playerPortraitImageView, nickNameLabel, signUpStatusOfNextMatchLabel, ageLabel, positionLabel, styleLabel;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [checkMarkBackground.layer setCornerRadius:15.0f];
    [checkMarkBackground.layer setMasksToBounds:YES];
    [playerPortraitImageView.layer setCornerRadius:10.0f];
    [playerPortraitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerPortraitImageView.layer setBorderWidth:1.0f];
    [playerPortraitImageView.layer setMasksToBounds:YES];
//    [self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:204/255.0 blue:255/255.0 alpha:0.5]];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)showPlayerDetails:(id)sender
{
    [delegate pushPlayerDetails:myPlayer];
}
@end

#pragma Captain_MyPlayer
@interface Captain_MyPlayers ()
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *notifyButton;
@end

@implementation Captain_MyPlayers{
    JSONConnect *connection;
    NSArray *playerList;
    NSArray *filterPlayerList;
}
@synthesize actionBar, notifyButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:actionBar.items];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActionButtonsStatus) name:UITableViewSelectionDidChangeNotification object:nil];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestTeamMembers:gMyUserInfo.team.teamId isSync:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveTeamMembers:(NSArray *)players
{
    playerList = players;
    [self.tableView reloadData];
}

-(void)updateActionButtonsStatus
{
    [notifyButton setEnabled:self.tableView.indexPathsForSelectedRows.count];
}

-(void)pushPlayerDetails:(UserInfo *)player
{
    PlayerDetails *playerDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerDetails"];
    [playerDetails setPlayerData:player];
    [playerDetails setViewType:PlayerDetails_MyPlayer];
    [self.navigationController pushViewController:playerDetails animated:YES];
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
    if ([tableView isEqual:self.tableView]) {
        return playerList.count;
    }
    else {
        return filterPlayerList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Captain_MyPlayerCell";
    Captain_MyPlayerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UserInfo *playerData = [[tableView isEqual:self.tableView]?playerList:filterPlayerList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell setMyPlayer:playerData];
    [cell setDelegate:self];
    [cell setAccessoryType:[tableView.indexPathsForSelectedRows containsObject:indexPath]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone];
    [cell.nickNameLabel setText:playerData.nickName];
    [cell.playerPortraitImageView setImage:playerData.playerPortrait?playerData.playerPortrait:def_defaultPlayerPortrait];
    [cell.ageLabel setText:[NSNumber numberWithInteger:[Age ageFromString:playerData.birthday]].stringValue];
    [cell.positionLabel setText:[Position stringWithCode:playerData.position]];
    [cell.styleLabel setText:playerData.style];
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

-(IBAction)notifyButtonOnClicked:(id)sender
{
//    [self performSegueWithIdentifier:@"MyPlayer" sender:self];
    MessageCenter_Compose *composeViewController = [[UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageCompose"];
    [composeViewController setComposeType:MessageComposeType_Blank];
    NSMutableArray *selectedPlayerList = [NSMutableArray new];
    NSArray *indexPathsForSelectedRows = self.searchDisplayController.isActive?self.searchDisplayController.searchResultsTableView.indexPathsForSelectedRows:self.tableView.indexPathsForSelectedRows;
    NSArray *displayedPlayerList = self.searchDisplayController.isActive?filterPlayerList:playerList;
    for (NSIndexPath *indexPath in indexPathsForSelectedRows) {
        [selectedPlayerList addObject:[displayedPlayerList objectAtIndex:indexPath.row]];
    }
    [composeViewController setToList:selectedPlayerList];
    [self.navigationController pushViewController:composeViewController animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MyPlayer"]) {
//        Captain_PlayerDetails *playerDetails = segue.destinationViewController;
//        [playerDetails setViewType:PlayerDetails_MyPlayer];
    }
    else if ([segue.identifier isEqualToString:@"NotifyTeamPlayers"]) {
        Captain_NotifyPlayers *notifyPlayers = segue.destinationViewController;
        [notifyPlayers setViewType:NotifyPlayers_MyTeamPlayers];
        [notifyPlayers setPlayerList:@[@"张三", @"李四", @"王五"]];
    }
}

@end
