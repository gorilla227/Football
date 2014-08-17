//
//  Captain_MyPlayers.m
//  Football
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MyPlayers.h"
#pragma Captain_MyPlayerCell
@interface Captain_MyPlayerCell ()
@property IBOutlet UIImageView *playerPortrait;
@property IBOutlet UILabel *playerName;
@property IBOutlet UILabel *signUpStatusOfNextMatch;
@property IBOutlet UIView *likeView;
@property IBOutlet UIImageView *likeIcon;
@property IBOutlet UILabel *likeScore;
@property IBOutlet UIButton *actionButton;
@end
@implementation Captain_MyPlayerCell
@synthesize playerPortrait, playerName, signUpStatusOfNextMatch, likeView, likeScore, likeIcon, actionButton;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [likeView setBackgroundColor:[UIColor clearColor]];
    [likeView.layer setBorderWidth:1.0f];
    [likeView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [likeView.layer setCornerRadius:8.0f];
    [actionButton.layer setCornerRadius:3.0f];
    [actionButton setBackgroundColor:def_warmUpMatch_actionButtonBG_Enable];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@end

#pragma Captain_MyPlayer
@interface Captain_MyPlayers ()
@property IBOutlet UIToolbar *actionBar;
@end

@implementation Captain_MyPlayers{
    JSONConnect *connection;
    NSArray *playerList;
    NSArray *filterPlayerList;
}
@synthesize actionBar;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
//    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:actionBar.items];
    
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


- (Captain_MyPlayerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Captain_MyPlayerCell";
    Captain_MyPlayerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UserInfo *player = [[tableView isEqual:self.tableView]?playerList:filterPlayerList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell setTag:indexPath.row];
    [cell.playerName setText:player.nickName];
    [cell.playerPortrait setImage:player.playerPortrait?player.playerPortrait:def_defaultPlayerPortrait];
    return cell;
}

-(IBAction)actionButtonOnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MyPlayer" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MyPlayer"]) {
        Captain_PlayerDetails *playerDetails = segue.destinationViewController;
        [playerDetails setViewType:PlayerDetails_MyPlayer];
    }
    else if ([segue.identifier isEqualToString:@"NotifyTeamPlayers"]) {
        Captain_NotifyPlayers *notifyPlayers = segue.destinationViewController;
        [notifyPlayers setViewType:NotifyPlayers_MyTeamPlayers];
        [notifyPlayers setPlayerList:@[@"张三", @"李四", @"王五"]];
    }
}

@end
