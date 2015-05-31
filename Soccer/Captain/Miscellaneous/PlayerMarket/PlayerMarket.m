//
//  PlayerMarket.m
//  Soccer
//
//  Created by Andy on 14-8-25.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "PlayerMarket.h"
#import "PositionCheckboxView.h"
#import "PlayerDetails.h"
#import "MessageCenter_Compose.h"

#pragma PlayerMarket_SearchView
@interface PlayerMarket_SearchView ()
@property IBOutlet UISegmentedControl *haveTeamSegement;
@property IBOutlet PositionCheckboxView *positionView;
@property IBOutlet UIView *ageView;
@property IBOutlet UITextField *nickNameSearchTextField;
@property IBOutlet UILabel *ageFloorLabel;
@property IBOutlet UISlider *ageFloorSlider;
@property IBOutlet UILabel *ageCapLabel;
@property IBOutlet UISlider *ageCapSlider;
@property IBOutlet UITextFieldForActivityRegion *activityRegionSearchTextField;
@end

@implementation PlayerMarket_SearchView
@synthesize haveTeamSegement, positionView, ageView, ageFloorLabel, ageFloorSlider, ageCapLabel, ageCapSlider, nickNameSearchTextField, activityRegionSearchTextField;
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [positionView initWithPositionTitles:[gUIStrings objectForKey:@"UI_Positions"] padding:CGPointMake(5, 5)];
    [positionView changeButtonFont:[UIFont systemFontOfSize:14.0f]];
    [positionView changeButtonTintColor:[UIColor whiteColor]];
    [positionView changeButtonTextColor:[UIColor whiteColor]];
    [positionView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [positionView.layer setBorderWidth:1.0f];
    [positionView.layer setCornerRadius:6.0f];
    [positionView.layer setMasksToBounds:YES];
    
    [ageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [ageView.layer setBorderWidth:1.0f];
    [ageView.layer setCornerRadius:6.0f];
    [ageView.layer setMasksToBounds:YES];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setFrame:self.bounds];
    [gradient setColors:@[(id)cLightBlue(1).CGColor, (id)[UIColor grayColor].CGColor, (id)cLightBlue(1).CGColor]];
    [self.layer insertSublayer:gradient atIndex:0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [nickNameSearchTextField resignFirstResponder];
    [activityRegionSearchTextField resignFirstResponder];
}

- (IBAction)ageSliderValueChanged:(id)sender {
    if (ageFloorSlider.value <= ageCapSlider.value) {
        if ([sender isEqual:ageFloorSlider]) {
            [ageFloorLabel setText:[NSNumber numberWithFloat:floorf(ageFloorSlider.value)].stringValue];
        }
        else {
            [ageCapLabel setText:[NSNumber numberWithFloat:ceilf(ageCapSlider.value)].stringValue];
        }
    }
    else {
        if ([sender isEqual:ageFloorSlider]) {
            [ageFloorSlider setValue:ageCapSlider.value];
            [ageFloorLabel setText:ageCapLabel.text];
        }
        else {
            [ageCapSlider setValue:ageFloorSlider.value];
            [ageCapLabel setText:ageFloorLabel.text];
        }
    }
}

- (NSDictionary *)searchCriteria {
    NSMutableDictionary *searchCriteria = [NSMutableDictionary new];
    //Nickname
    NSString *nickname = [nickNameSearchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nickname.length) {
        [searchCriteria setObject:nickname forKey:CONNECT_SearchPlayersCriteria_ParameterKey_Nickname];
    }
    
    //HaveTeam
    switch (haveTeamSegement.selectedSegmentIndex) {
        case 1:
            [searchCriteria setObject:[NSNumber numberWithBool:YES] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_HaveTeam];
            break;
        case 2:
            [searchCriteria setObject:[NSNumber numberWithBool:NO] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_HaveTeam];
            break;
        default:
            break;
    }
    
    //Position
    [searchCriteria setObject:[positionView selectedPositions] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_Position];
    
    //AgeCap & AgeFloor
    [searchCriteria setObject:ageCapLabel.text forKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeCap];
    [searchCriteria setObject:ageFloorLabel.text forKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeFloor];
    
    //ActivityRegion
    if (activityRegionSearchTextField.selectedActivityRegionCode) {
        [searchCriteria setObject:activityRegionSearchTextField.selectedActivityRegionCode forKey:CONNECT_SearchPlayersCriteria_ParameterKey_ActivityRegion];
    }
    
    return searchCriteria;
}
@end

#pragma PlayerMarket_Cell
@interface PlayerMarket_Cell ()
@property IBOutlet UIImageView *playerPortraitImageView;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *positionLabel;
@property IBOutlet UILabel *styleLabel;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *activityRegionLabel;
@end

@implementation PlayerMarket_Cell
@synthesize playerInfo, delegate;
@synthesize playerPortraitImageView, nickNameLabel, teamNameLabel, positionLabel, styleLabel, ageLabel, activityRegionLabel;

- (IBAction)showPlayerDetails:(id)sender {
    [delegate pushPlayerDetails:playerInfo];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [playerPortraitImageView.layer setCornerRadius:10.0f];
    [playerPortraitImageView.layer setMasksToBounds:YES];
    [teamNameLabel.layer setCornerRadius:3.0f];
    [teamNameLabel.layer setMasksToBounds:YES];
    [teamNameLabel setBackgroundColor:cGray(0.9)];
}
@end

#pragma PlayerMarket
@interface PlayerMarket ()
@property IBOutlet PlayerMarket_SearchView *searchView;
@property IBOutlet UIButton *searchViewSwitchButton;
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *recruitButton;
@property IBOutlet UIBarButtonItem *temporaryFavorButton;
@end

@implementation PlayerMarket {
    JSONConnect *connection;
    NSMutableArray *playerList;
    NSInteger count;
    Team *opponentTeam;
}
@synthesize searchView, searchViewSwitchButton, actionBar, recruitButton, temporaryFavorButton;
@synthesize viewType, matchData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem];
    [self.tableView setTableHeaderView:searchView];
    [self initialWithLabelTexts:@"PlayerMarket"];
    [self setAllowAutoRefreshing:NO];
    [self setToolbarItems:actionBar.items];
    [self setTopBounceBackgroundColor:cLightBlue(1.0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActionButtonsStatus) name:UITableViewSelectionDidChangeNotification object:nil];
    
    count = [[gSettings objectForKey:@"playersSearchListCount"] integerValue];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    if (matchData) {
        opponentTeam = (matchData.homeTeam.teamId == gMyUserInfo.team.teamId)?matchData.awayTeam:matchData.homeTeam;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!gMyUserInfo.userType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startLoadingMore:(BOOL)isReload {
    if (isReload) {
        playerList = [NSMutableArray new];
    }
    if ([super startLoadingMore:isReload]) {
        [connection requestPlayersBySearchCriteria:[searchView searchCriteria] startIndex:playerList.count count:count isSync:YES];
        return YES;
    }
    return NO;
}

- (void)pushPlayerDetails:(UserInfo *)player {
    PlayerDetails *playerDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerDetails"];
    [playerDetails setPlayerData:player];
    [playerDetails setViewType:PlayerDetails_FromPlayerMarket];
    [playerDetails setMatchData:matchData];
    [self.navigationController pushViewController:playerDetails animated:YES];
}

- (IBAction)searchViewSwitchButtonOnClicked:(id)sender {
    [searchViewSwitchButton setSelected:!searchViewSwitchButton.isSelected];
    [self.tableView setTableHeaderView:searchViewSwitchButton.isSelected?searchView:[[UIView alloc] initWithFrame:CGRectZero]];
    if (playerList.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (IBAction)searchButtonOnClicked:(id)sender {
    [searchView.nickNameSearchTextField resignFirstResponder];
    [searchView.activityRegionSearchTextField resignFirstResponder];
    [playerList removeAllObjects];
    [self startLoadingMore:YES];
}

- (void)updateActionButtonsStatus {
    switch (viewType) {
        case PlayerMarketViewType_FromMatchArrangement:
            [recruitButton setEnabled:NO];
            break;
        default:
            [recruitButton setEnabled:self.tableView.indexPathsForSelectedRows.count];
            for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
                UserInfo *selectedPlayer = [playerList objectAtIndex:indexPath.row];
                if (selectedPlayer.team) {
                    [recruitButton setEnabled:NO];
                    break;
                }
            }
            break;
    }
    
    [temporaryFavorButton setEnabled:NO];
    if (gMyUserInfo.userType) {
        [temporaryFavorButton setEnabled:self.tableView.indexPathsForSelectedRows.count];
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            UserInfo *selectedPlayer = [playerList objectAtIndex:indexPath.row];
            if (selectedPlayer.team.teamId == gMyUserInfo.team.teamId || selectedPlayer.team.teamId == opponentTeam.teamId) {
                [temporaryFavorButton setEnabled:NO];
                break;
            }
        }
    }
}

- (void)receivePlayers:(NSArray *)players {
    [playerList addObjectsFromArray:players];
    if (playerList.count == 0) {
        [self finishedLoadingWithNewStatus:LoadMoreStatus_NoData];
    }
    else {
        [self finishedLoadingWithNewStatus:(players.count == count)?LoadMoreStatus_LoadMore:LoadMoreStatus_NoMoreData];
    }
    
    [searchViewSwitchButton setSelected:!playerList.count];
    [self.tableView setTableHeaderView:searchViewSwitchButton.isSelected?searchView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView reloadData];
    [self updateActionButtonsStatus];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return playerList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PlayerMarketCell";
    PlayerMarket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UserInfo *playerData = [playerList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell setPlayerInfo:playerData];
    [cell setDelegate:self];
    [cell changeCheckMarkStatus:[tableView.indexPathsForSelectedRows containsObject:indexPath]];
    [cell.nickNameLabel setText:playerData.nickName];
    [cell.ageLabel setText:[NSNumber numberWithInteger:[Age ageFromString:playerData.birthday]].stringValue];
    [cell.positionLabel setText:[Position stringWithCode:playerData.position]];
    [cell.styleLabel setText:playerData.style];
    [cell.activityRegionLabel setText:[[ActivityRegion stringWithCode:playerData.activityRegion] componentsJoinedByString:@" "]];
    [cell.playerPortraitImageView setImage:playerData.playerPortrait?playerData.playerPortrait:def_defaultPlayerPortrait];
    if (playerData.team) {
        [cell.teamNameLabel setText:playerData.team.teamName];
        [cell.teamNameLabel setHidden:NO];
    }
    else {
        [cell.teamNameLabel setHidden:YES];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return searchViewSwitchButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return searchViewSwitchButton.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerMarket_Cell *cell = (PlayerMarket_Cell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeCheckMarkStatus:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerMarket_Cell *cell = (PlayerMarket_Cell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeCheckMarkStatus:NO];
}

#pragma Button Actions
- (IBAction)recruitButtonOnClicked:(id)sender {
    NSMutableArray *selectedPlayerList = [NSMutableArray new];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [selectedPlayerList addObject:[playerList objectAtIndex:indexPath.row]];
    }

    MessageCenter_Compose *composeViewController = [[UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageCompose"];
    [composeViewController setComposeType:MessageComposeType_Recurit];
    [composeViewController setToList:selectedPlayerList];
    [self.navigationController pushViewController:composeViewController animated:YES];
}

- (IBAction)temporaryFavorButtonOnClicked:(id)sender {
    NSMutableArray *selectedPlayerList = [NSMutableArray new];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [selectedPlayerList addObject:[playerList objectAtIndex:indexPath.row]];
    }
    
    MessageCenter_Compose *composeViewController = [[UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageCompose"];
    [composeViewController setComposeType:MessageComposeType_TemporaryFavor];
    [composeViewController setToList:selectedPlayerList];
    if (matchData) {
        [composeViewController setOtherParameters:@{@"matchData":matchData}];
        if (viewType == PlayerMarketViewType_FromMatchArrangement) {
            [composeViewController setViewControllerAfterSending:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2]];
        }
    }
    [self.navigationController pushViewController:composeViewController animated:YES];
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
