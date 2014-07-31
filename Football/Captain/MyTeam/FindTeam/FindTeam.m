//
//  FindTeam.m
//  Football
//
//  Created by Andy on 14-7-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "FindTeam.h"

#pragma FindTeam_Cell
@interface FindTeam_Cell()
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *teamMemberNumberLabel;
@property IBOutlet UILabel *activityRegionLabel;
@property IBOutlet UIButton *applyButton;
@property IBOutlet UILabel *recruitAnnouncementLabel;
@end

@implementation FindTeam_Cell
@synthesize teamLogoImageView, teamNameLabel, teamMemberNumberLabel, activityRegionLabel, applyButton, recruitAnnouncementLabel;

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
    [self.layer setCornerRadius:10.0f];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.layer setBorderWidth:1.0f];
    [self.layer setMasksToBounds:YES];
}
@end

#pragma FindTeam
@interface FindTeam ()

@end

@implementation FindTeam{
    NSArray *teamList;
    NSArray *filteredTeamList;
    JSONConnect *connection;
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
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    
    //Set menu button and message button
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
        [self.navigationItem setRightBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem];
    }
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestAllTeamsStart:0 count:10 option:RequestTeamsOption_All];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Receive TeamList
-(void)receiveAllTeams:(NSArray *)teams
{
    teamList = teams;
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
    [cell.recruitAnnouncementLabel setText:team.slogan];
    if (team.teamLogo) {
        [cell.teamLogoImageView setImage:team.teamLogo];
    }
    else {
        [cell.teamLogoImageView setImage:def_defaultTeamLogo];
    }
    return cell;
}

#pragma Search Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *searchCondition = [NSPredicate predicateWithFormat:@"self.teamName contains[c] %@", searchString];
    filteredTeamList = [teamList filteredArrayUsingPredicate:searchCondition];
    return YES;
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
