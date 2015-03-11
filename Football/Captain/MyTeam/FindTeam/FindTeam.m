//
//  FindTeam.m
//  Football
//
//  Created by Andy on 14-7-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "FindTeam.h"
#import "MessageCenter_Compose.h"

#pragma FindTeam_Cell
@interface FindTeam_Cell()
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *teamMemberNumberLabel;
@property IBOutlet UILabel *activityRegionLabel;
@property IBOutlet UIButton *applyButton;
@property IBOutlet UITextView *recruitAnnouncementTextView;
@end

@implementation FindTeam_Cell
@synthesize teamLogoImageView, teamNameLabel, teamMemberNumberLabel, activityRegionLabel, applyButton, recruitAnnouncementTextView;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //Set the teamLogoImageView style
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setBorderWidth:1.5f];
    [teamLogoImageView.layer setMasksToBounds:YES];
    
    //Set the applyButton style
    [applyButton.layer setCornerRadius:10.0f];
    [applyButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [applyButton.layer setBorderWidth:1.0f];
    [applyButton.layer setMasksToBounds:YES];
        
    //Set the cell self style
//    [self.layer setCornerRadius:10.0f];
//    [self.layer setBorderColor:[UIColor clearColor].CGColor];
//    [self.layer setBorderWidth:1.0f];
//    [self.layer setMasksToBounds:YES];
    
    [recruitAnnouncementTextView setSelectable:NO];
}
@end

#pragma FindTeam
@interface FindTeam ()

@end

@implementation FindTeam{
    NSMutableArray *teamList;
    NSArray *filteredTeamList;
    JSONConnect *connection;
    NSInteger count;
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
    
    [self.searchDisplayController.searchResultsTableView setRowHeight:self.tableView.rowHeight];
    [self.searchDisplayController.searchResultsTableView setAllowsSelection:NO];
    [self initialWithLabelTexts:@"FindTeam"];
    
    count = [[gSettings objectForKey:@"teamListCount"] integerValue];
    teamList = [NSMutableArray new];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [self startLoadingMore];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Receive TeamList
-(void)receiveAllTeams:(NSArray *)teams
{
    [teamList addObjectsFromArray:teams];
    
    if (teamList.count == 0) {
        [self finishedLoadingWithNewStatus:LoadMoreStatus_NoData];
    }
    else {
        [self finishedLoadingWithNewStatus:(teams.count == count)?LoadMoreStatus_LoadMore:LoadMoreStatus_NoMoreData];
    }    [self.tableView reloadData];
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
        return teamList.count;
    }
    else {
        return filteredTeamList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FindTeamCell";
    FindTeam_Cell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Team *team;
    if ([tableView isEqual:self.tableView]) {
        team = [teamList objectAtIndex:indexPath.row];
    }
    else {
        team = [filteredTeamList objectAtIndex:indexPath.row];
    }
    
    [cell.teamNameLabel setText:team.teamName];
    [cell.teamMemberNumberLabel setText:[NSString stringWithFormat:@"%li", (long)team.numOfMember]];
    [cell.activityRegionLabel setText:[[ActivityRegion stringWithCode:team.activityRegion] componentsJoinedByString:@" "]];
    [cell.recruitAnnouncementTextView setText:team.recruitAnnouncement];
    if (team.teamLogo) {
        [cell.teamLogoImageView setImage:team.teamLogo];
    }
    else {
        [cell.teamLogoImageView setImage:def_defaultTeamLogo];
    }
    [cell.applyButton setTag:indexPath.row];
    return cell;
}

- (BOOL)startLoadingMore {
    if ([super startLoadingMore]) {
        [connection requestTeamsStart:teamList.count count:count option:RequestTeamsOption_Recruit];
        return YES;
    }
    return NO;
}

#pragma Search Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *searchCondition = [NSPredicate predicateWithFormat:@"self.teamName contains[c] %@", searchString];
    filteredTeamList = [teamList filteredArrayUsingPredicate:searchCondition];
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setSearchBarStyle:UISearchBarStyleDefault];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
}

//Send Applying
-(IBAction)sendApplication:(id)sender
{
    UIButton *button = sender;
    Team *applyinTeam;
    if (self.searchDisplayController.isActive) {
        applyinTeam = [filteredTeamList objectAtIndex:button.tag];
    }
    else {
        applyinTeam = [teamList objectAtIndex:button.tag];
    }
    MessageCenter_Compose *composeViewController = [[UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageCompose"];
    [composeViewController setComposeType:MessageComposeType_Applyin];
    [composeViewController setToList:@[applyinTeam]];
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
