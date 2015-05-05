//
//  TeamMarket.m
//  Soccer
//
//  Created by Andy on 14-10-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "TeamMarket.h"
#import "TeamDetails.h"

#pragma TeamMarket_SearchView
@interface TeamMarket_SearchView ()
@property IBOutlet UIView *teamNumberView;
@property IBOutlet UITextField *teamNameSearchTextField;
@property IBOutlet UILabel *teamNumberFloorLabel;
@property IBOutlet UISlider *teamNumberFloorSlider;
@property IBOutlet UILabel *teamNumberCapLabel;
@property IBOutlet UISlider *teamNumberCapSlider;
@property IBOutlet UITextFieldForActivityRegion *activityRegionSearchTextField;
@property IBOutlet UISwitch *onlyRecruitSwitch;
@property IBOutlet UISwitch *onlyChallenteamNumberSwitch;
@property IBOutlet UIButton *searchButton;
@end

@implementation TeamMarket_SearchView
@synthesize teamNumberView, teamNameSearchTextField, teamNumberFloorLabel, teamNumberFloorSlider, teamNumberCapLabel, teamNumberCapSlider, activityRegionSearchTextField, onlyChallenteamNumberSwitch, onlyRecruitSwitch, searchButton;
@synthesize flag;
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [teamNumberView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamNumberView.layer setBorderWidth:1.0f];
    [teamNumberView.layer setCornerRadius:6.0f];
    [teamNumberView.layer setMasksToBounds:YES];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setFrame:self.bounds];
    [gradient setColors:@[(id)cLightBlue(1).CGColor, (id)[UIColor grayColor].CGColor, (id)cLightBlue(1).CGColor]];
    [self.layer insertSublayer:gradient atIndex:0];
    
    [searchButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [searchButton.layer setBorderWidth:1.0f];
    [searchButton.layer setCornerRadius:10.0f];
    [searchButton.layer setMasksToBounds:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [teamNameSearchTextField resignFirstResponder];
    [activityRegionSearchTextField resignFirstResponder];
}

-(IBAction)teamNumberSliderValueChanged:(id)sender
{
    if (teamNumberFloorSlider.value <= teamNumberCapSlider.value) {
        if ([sender isEqual:teamNumberFloorSlider]) {
            [teamNumberFloorLabel setText:[NSNumber numberWithFloat:floorf(teamNumberFloorSlider.value)].stringValue];
        }
        else {
            [teamNumberCapLabel setText:[NSNumber numberWithFloat:ceilf(teamNumberCapSlider.value)].stringValue];
        }
    }
    else {
        if ([sender isEqual:teamNumberFloorSlider]) {
            [teamNumberFloorSlider setValue:teamNumberCapSlider.value];
            [teamNumberFloorLabel setText:teamNumberCapLabel.text];
        }
        else {
            [teamNumberCapSlider setValue:teamNumberFloorSlider.value];
            [teamNumberCapLabel setText:teamNumberFloorLabel.text];
        }
    }
    if (ceilf(teamNumberCapSlider.value) == teamNumberCapSlider.maximumValue) {
        [teamNumberCapLabel setText:[NSString stringWithFormat:@"%@+", [NSNumber numberWithFloat:ceilf(teamNumberCapSlider.value)].stringValue]];
    }
}

-(IBAction)flagSwitchValueChanged:(id)sender
{
    if (onlyRecruitSwitch.isOn && onlyChallenteamNumberSwitch.isOn) {
        if ([sender isEqual:onlyChallenteamNumberSwitch]) {
            [onlyRecruitSwitch setOn:NO animated:YES];
        }
        else {
            [onlyChallenteamNumberSwitch setOn:NO animated:YES];
        }
    }
    if (onlyRecruitSwitch.isOn) {
        flag = 1;
    }
    else if (onlyChallenteamNumberSwitch.isOn) {
        flag = 2;
    }
    else {
        flag = 0;
    }
}

-(NSDictionary *)searchCriteria
{
    NSMutableDictionary *searchCriteria = [NSMutableDictionary new];
    //TeamName
    NSString *teamName = [teamNameSearchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (teamName.length) {
        [searchCriteria setObject:teamName forKey:CONNECT_SearchTeamsCriteria_ParameterKey_Teamname];
    }
    
    //TeamNumberCap & TeamNumberFloor
    [searchCriteria setObject:[teamNumberCapLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet symbolCharacterSet]] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_TeamNumberCap];
    [searchCriteria setObject:teamNumberFloorLabel.text forKey:CONNECT_SearchTeamsCriteria_ParameterKey_TeamNumberFloor];
    
    //ActivityRegion
    if (activityRegionSearchTextField.selectedActivityRegionCode) {
        [searchCriteria setObject:activityRegionSearchTextField.selectedActivityRegionCode forKey:CONNECT_SearchTeamsCriteria_ParameterKey_ActivityRegion];
    }
    
    //Flag
    if (onlyRecruitSwitch.isOn) {
        [searchCriteria setObject:[NSNumber numberWithInteger:1] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_Flag];
    }
    else if (onlyChallenteamNumberSwitch.isOn) {
        [searchCriteria setObject:[NSNumber numberWithInteger:2] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_Flag];
    }
    else {
        [searchCriteria setObject:[NSNumber numberWithInteger:0] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_Flag];
    }
    
    return searchCriteria;
}
@end

#pragma TeamMarketCell
@interface TeamMarket_Cell ()
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *myTeamFlagLabel;
@property IBOutlet UILabel *boardNameLabel;
@property IBOutlet UITextView *boardContentTextView;
@property IBOutlet UILabel *teamNumberLabel;
@property IBOutlet UILabel *activityRegionLabel;
@end

@implementation TeamMarket_Cell
@synthesize teamLogoImageView, teamNameLabel, myTeamFlagLabel, boardNameLabel, boardContentTextView, teamNumberLabel, activityRegionLabel;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setMasksToBounds:YES];
    [myTeamFlagLabel.layer setCornerRadius:3.0f];
    [myTeamFlagLabel.layer setMasksToBounds:YES];
    [myTeamFlagLabel setBackgroundColor:cGray(0.9)];
}
@end

#pragma TeamMarket
@interface TeamMarket ()
@property IBOutlet TeamMarket_SearchView *searchView;
@property IBOutlet UIButton *searchViewSwitchButton;
@end

@implementation TeamMarket{
    JSONConnect *connection;
    NSMutableArray *teamList;
    NSInteger count;
}
@synthesize searchView, searchViewSwitchButton;
@synthesize viewType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem];
    [self.tableView setTableHeaderView:searchView];
    [self initialWithLabelTexts:@"TeamMarket"];
    [self setAllowAutoRefreshing:NO];
    switch (viewType) {
        case TeamMarketViewType_Default:
            
            break;
        case TeamMarketViewType_CreateMatch:
            [searchView.onlyChallenteamNumberSwitch setOn:YES];
            [searchView.onlyChallenteamNumberSwitch setEnabled:NO];
            [searchView.onlyRecruitSwitch setEnabled:NO];
            break;
        default:
            break;
    }
    
    count = [[gSettings objectForKey:@"teamsSearchListCount"] integerValue];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
}

- (BOOL)startLoadingMore:(BOOL)isReload {
    if (isReload) {
        teamList = [NSMutableArray new];
    }
    if ([super startLoadingMore:isReload]) {
        [connection requestTeamsBySearchCriteria:[searchView searchCriteria] startIndex:teamList.count count:count isSync:YES];
        return YES;
    }
    return NO;
}

-(IBAction)searchViewSwitchButtonOnClicked:(id)sender
{
    [searchViewSwitchButton setSelected:!searchViewSwitchButton.isSelected];
    [self.tableView setTableHeaderView:searchViewSwitchButton.isSelected?searchView:[[UIView alloc] initWithFrame:CGRectZero]];
    if (teamList.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(IBAction)searchButtonOnClicked:(id)sender
{
    [searchView.teamNameSearchTextField resignFirstResponder];
    [searchView.activityRegionSearchTextField resignFirstResponder];
    [teamList removeAllObjects];

    [self startLoadingMore:YES];
}

-(void)receiveTeams:(NSArray *)teams
{
    [teamList addObjectsFromArray:teams];
    if (teamList.count == 0) {
        [self finishedLoadingWithNewStatus:LoadMoreStatus_NoData];
    }
    else {
        [self finishedLoadingWithNewStatus:(teams.count == count)?LoadMoreStatus_LoadMore:LoadMoreStatus_NoMoreData];
    }
    
    [searchViewSwitchButton setSelected:!teamList.count];
    [self.tableView setTableHeaderView:searchViewSwitchButton.isSelected?searchView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return teamList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TeamMarketCell";
    TeamMarket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Team *cellData = [teamList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell.teamNameLabel setText:cellData.teamName];
    if (gMyUserInfo.team) {
        [cell.myTeamFlagLabel setHidden:cellData.teamId != gMyUserInfo.team.teamId];
    }
    else {
        [cell.myTeamFlagLabel setHidden:YES];
    }
    [cell.teamNumberLabel setText:[NSNumber numberWithInteger:cellData.numOfMember].stringValue];
    switch (searchView.flag) {
        case 0:
            [cell.boardNameLabel setText:[gUIStrings objectForKey:@"UI_TeamMarket_BoardName_Slogan"]];
            [cell.boardContentTextView setText:cellData.slogan];
            break;
        case 1:
            [cell.boardNameLabel setText:[gUIStrings objectForKey:@"UI_TeamMarket_BoardName_Recruit"]];
            [cell.boardContentTextView setText:cellData.recruitAnnouncement];
            break;
        case 2:
            [cell.boardNameLabel setText:[gUIStrings objectForKey:@"UI_TeamMarket_BoardName_Challenge"]];
            [cell.boardContentTextView setText:cellData.challengeAnnouncement];
        default:
            break;
    }
    [cell.teamLogoImageView setImage:cellData.teamLogo?cellData.teamLogo:def_defaultTeamLogo];
    [cell.activityRegionLabel setText:[[ActivityRegion stringWithCode:cellData.activityRegion] componentsJoinedByString:@" "]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return searchViewSwitchButton;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return searchViewSwitchButton.frame.size.height;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"TeamDetailsSegue"]) {
        TeamDetails *teamDetails = segue.destinationViewController;
        [teamDetails setTeamData:[teamList objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
        switch (viewType) {
            case TeamMarketViewType_CreateMatch:
                [teamDetails setViewType:TeamDetailsViewType_CreateMatch];
                break;       
            default:
                [teamDetails setViewType:TeamDetailsViewType_Default];
                break;
        }
    }
}

@end