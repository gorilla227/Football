//
//  MyPlayers.m
//  Soccer
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MyPlayers.h"
#import "PlayerDetails.h"
#import "MessageCenter_Compose.h"

#pragma MyPlayerCell
@interface MyPlayerCell ()
@property IBOutlet UIImageView *playerPortraitImageView;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *positionLabel;
@property IBOutlet UILabel *styleLabel;
@property IBOutlet UIImageView *captainIcon;
@end

@implementation MyPlayerCell {
    UIButton *checkMarkButton;
    UIView *checkMarkButtonBackgroundView;
    UIColor *checkedTintColor;
}
@synthesize myPlayer, delegate;
@synthesize playerPortraitImageView, nickNameLabel, ageLabel, positionLabel, styleLabel,captainIcon;

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [playerPortraitImageView.layer setCornerRadius:10.0f];
    [playerPortraitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerPortraitImageView.layer setBorderWidth:1.0f];
    [playerPortraitImageView.layer setMasksToBounds:YES];
//    [self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:204/255.0 blue:255/255.0 alpha:0.5]];
    if (!CGPointEqualToPoint(checkMarkButton.center, checkMarkButtonBackgroundView.center)) {
        [checkMarkButtonBackgroundView setCenter:checkMarkButton.center];
    }
}

- (void)seekCheckMarkButton {
    if (!checkMarkButton) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                checkMarkButton = (UIButton *)view;
                CGRect frame = checkMarkButton.frame;
                CGPoint center = checkMarkButton.center;
                CGFloat extentBackgroundSideLength = fmaxf(frame.size.width, frame.size.height) * 2;
                frame.size.width = extentBackgroundSideLength;
                frame.size.height = extentBackgroundSideLength;
                checkMarkButtonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, extentBackgroundSideLength, extentBackgroundSideLength)];
                [self addSubview:checkMarkButtonBackgroundView];
                [checkMarkButtonBackgroundView setCenter:center];
                [checkMarkButtonBackgroundView.layer setCornerRadius:extentBackgroundSideLength/2];
                [checkMarkButtonBackgroundView.layer setMasksToBounds:YES];
                [checkMarkButtonBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
                checkedTintColor = checkMarkButton.tintColor;
                [checkMarkButton setTintColor:[UIColor clearColor]];
                [self bringSubviewToFront:checkMarkButton];
                break;
            }
        }
    }
}

- (IBAction)showPlayerDetails:(id)sender {
    [delegate pushPlayerDetails:myPlayer];
}

- (void)changeCheckMarkStatus:(BOOL)status {
    [self seekCheckMarkButton];
    [checkMarkButton setTintColor:status?checkedTintColor:[UIColor clearColor]];
}

- (void)shouldHiddenCheckMarkBackground:(BOOL)shouldHidden {
    [self seekCheckMarkButton];
    [checkMarkButtonBackgroundView setHidden:shouldHidden];
}
@end

#pragma MyPlayer
@interface MyPlayers ()
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *notifyButton;
@end

@implementation MyPlayers {
    JSONConnect *connection;
    NSArray *playerList;
    NSArray *filterPlayerList;
}
@synthesize actionBar, notifyButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setToolbarItems:actionBar.items];
    [self.searchDisplayController.searchResultsTableView setRowHeight:self.tableView.rowHeight];
    [self.searchDisplayController.searchResultsTableView setAllowsMultipleSelection:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActionButtonsStatus) name:UITableViewSelectionDidChangeNotification object:nil];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!playerList) {
        [connection requestTeamMembers:gMyUserInfo.team.teamId withTeamFundHistory:NO isSync:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveTeamMembers:(NSArray *)players {
    playerList = players;
    [self.tableView reloadData];
}

- (void)updateActionButtonsStatus {
    if (self.searchDisplayController.isActive) {
        [notifyButton setEnabled:self.searchDisplayController.searchResultsTableView.indexPathsForSelectedRows.count];
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
    else {
        [notifyButton setEnabled:self.tableView.indexPathsForSelectedRows.count];
    }
}

- (void)pushPlayerDetails:(UserInfo *)player {
    PlayerDetails *playerDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerDetails"];
    [playerDetails setPlayerData:player];
    [playerDetails setViewType:PlayerDetails_MyPlayer];
    [self.navigationController pushViewController:playerDetails animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([tableView isEqual:self.tableView]) {
        return playerList.count;
    }
    else {
        return filterPlayerList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyPlayerCell";
    MyPlayerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UserInfo *playerData = [[tableView isEqual:self.tableView]?playerList:filterPlayerList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell setMyPlayer:playerData];
    [cell setDelegate:self];
    [cell changeCheckMarkStatus:[tableView.indexPathsForSelectedRows containsObject:indexPath]];
    [cell.nickNameLabel setText:playerData.nickName];
    [cell.playerPortraitImageView setImage:playerData.playerPortrait?playerData.playerPortrait:def_defaultPlayerPortrait];
    [cell.ageLabel setText:[NSNumber numberWithInteger:[Age ageFromString:playerData.birthday]].stringValue];
    [cell.positionLabel setText:[Position stringWithCode:playerData.position]];
    [cell.styleLabel setText:playerData.style];
    [cell.captainIcon setHidden:!playerData.userType];
    [cell setUserInteractionEnabled:(gMyUserInfo.userId != playerData.userId)];
    [cell setBackgroundColor:(playerData.userId == gMyUserInfo.userId)?cGray(1):[UIColor whiteColor]];
    [cell shouldHiddenCheckMarkBackground:(playerData.userId == gMyUserInfo.userId)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPlayerCell *cell = (MyPlayerCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeCheckMarkStatus:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPlayerCell *cell = (MyPlayerCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeCheckMarkStatus:NO];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self.nickName contains[c] %@", searchString];
    filterPlayerList = [playerList filteredArrayUsingPredicate:searchPredicate];
    return YES;
}

- (IBAction)notifyButtonOnClicked:(id)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
