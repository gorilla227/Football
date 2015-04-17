//
//  MyPlayers.m
//  Football
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MyPlayers.h"
#import "PlayerDetails.h"
#import "MessageCenter_Compose.h"

#pragma MyPlayerCell
@interface MyPlayerCell ()
@property IBOutlet UIView *checkMarkBackground;
@property IBOutlet UIImageView *playerPortraitImageView;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *positionLabel;
@property IBOutlet UILabel *styleLabel;
@property IBOutlet UIImageView *captainIcon;
@end

@implementation MyPlayerCell
@synthesize myPlayer, delegate;
@synthesize checkMarkBackground, playerPortraitImageView, nickNameLabel, ageLabel, positionLabel, styleLabel,captainIcon;

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

#pragma MyPlayer
@interface MyPlayers ()
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *notifyButton;
@end

@implementation MyPlayers{
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
    [self setToolbarItems:actionBar.items];
    [self.searchDisplayController.searchResultsTableView setRowHeight:self.tableView.rowHeight];
    [self.searchDisplayController.searchResultsTableView setAllowsMultipleSelection:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActionButtonsStatus) name:UITableViewSelectionDidChangeNotification object:nil];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestTeamMembers:gMyUserInfo.team.teamId withTeamFundHistory:NO isSync:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
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
    if (self.searchDisplayController.isActive) {
        [notifyButton setEnabled:self.searchDisplayController.searchResultsTableView.indexPathsForSelectedRows.count];
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
    else {
        [notifyButton setEnabled:self.tableView.indexPathsForSelectedRows.count];
    }
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
    static NSString *CellIdentifier = @"MyPlayerCell";
    MyPlayerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    [cell.captainIcon setHidden:!playerData.userType];
    [cell setUserInteractionEnabled:(gMyUserInfo.userId != playerData.userId)];
    [cell setBackgroundColor:(playerData.userId == gMyUserInfo.userId)?cGray(1):[UIColor whiteColor]];
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

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self.nickName contains[c] %@", searchString];
    filterPlayerList = [playerList filteredArrayUsingPredicate:searchPredicate];
    return YES;
}

-(IBAction)notifyButtonOnClicked:(id)sender
{
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
}

@end
