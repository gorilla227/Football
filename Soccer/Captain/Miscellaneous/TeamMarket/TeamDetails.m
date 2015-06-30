//
//  TeamDetails.m
//  Soccer
//
//  Created by Andy Xu on 14/10/29.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "TeamDetails.h"
#import "MessageCenter_Compose.h"

@interface TeamDetails ()
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *teamNumberLabel;
@property IBOutlet UIView *teamNameBackgroundView;
@property IBOutlet UITableViewCell *averAgeCell;
@property IBOutlet UITableViewCell *activityRegionCell;
@property IBOutlet UITableViewCell *homeStadiumCell;
@property IBOutlet UITableViewCell *homeStadiumMapCell;
@property IBOutlet MKMapView *homeStadiumMapView;
@property IBOutlet UILabel *sloganLabel;
@property IBOutlet UILabel *recruitAnnouncementLabel;
@property IBOutlet UISwitch *recruitFlagSwitch;
@property IBOutlet UILabel *challengeAnnouncementLabel;
@property IBOutlet UISwitch *challengeFlagSwitch;
@property IBOutlet UIToolbar *createMatchActionBar;
@property IBOutlet UIBarButtonItem *applyInButton;
@property IBOutlet UIBarButtonItem *challengeButton;
@property IBOutlet UIToolbar *callinActionBar;
@property IBOutlet UIBarButtonItem *acceptButton;
@property IBOutlet UIBarButtonItem *refuseButton;
@end

@implementation TeamDetails{
    JSONConnect *connection;
}
@synthesize teamLogoImageView, teamNameLabel, teamNameBackgroundView, teamNumberLabel, averAgeCell, activityRegionCell, homeStadiumCell, homeStadiumMapCell, homeStadiumMapView, sloganLabel, recruitAnnouncementLabel, recruitFlagSwitch, challengeAnnouncementLabel, challengeFlagSwitch, createMatchActionBar, applyInButton, challengeButton, callinActionBar, acceptButton, refuseButton;
@synthesize teamData, viewType, delegate, message;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)bgImage];
//    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    //Set controllers appearance
    [teamNameBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [teamNameBackgroundView.layer setBorderWidth:3.0f];
    [teamNameBackgroundView.layer setCornerRadius:5.0f];
    [teamNameBackgroundView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamNameBackgroundView.layer setMasksToBounds:YES];
    
    [teamLogoImageView.layer setCornerRadius:12.0f];
    [teamLogoImageView.layer setMasksToBounds:YES];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setBorderWidth:3.0f];
    
    //Fill Data
    if (teamData) {
        [self initWithTeamData];
    }
    else {
        [connection requestTeamById:message.senderId isSync:YES];
    }
    
    //Set Action button Status
    switch (viewType) {
        case TeamDetailsViewType_CreateMatch:
            [self setToolbarItems:createMatchActionBar.items];
            [applyInButton setEnabled:NO];
            [challengeButton setEnabled:(teamData.teamId != gMyUserInfo.team.teamId)];
            break;
        case TeamDetailsViewType_CallinTeamProfile:
            if ((message.status == 0 || message.status == 1) && !gMyUserInfo.team) {
                [self setToolbarItems:callinActionBar.items];
            }
            else {
                [self setToolbarItems:nil];
            }
            break;
        case TeamDetailsViewType_NoAction:
            [self setToolbarItems:nil];
            break;
        default:
            [self setToolbarItems:createMatchActionBar.items];
            [applyInButton setEnabled:teamData.recruitFlag && !gMyUserInfo.team];
            [challengeButton setEnabled:teamData.challengeFlag && gMyUserInfo.userType];
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!self.toolbarItems.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveTeam:(Team *)team {
    teamData = team;
    [self initWithTeamData];
    [self.tableView reloadData];
}

- (void)initWithTeamData {
    [teamNameLabel setText:teamData.teamName];
    [teamLogoImageView setImage:teamData.teamLogo?teamData.teamLogo:def_defaultTeamLogo];
    [teamNumberLabel setText:[NSNumber numberWithInteger:teamData.numOfMember].stringValue];
    if ([ActivityRegion stringWithCode:teamData.activityRegion].count) {
        [activityRegionCell.detailTextLabel setText:[[ActivityRegion stringWithCode:teamData.activityRegion] componentsJoinedByString:@" "]];
    }
    if (teamData.homeStadium) {
        [homeStadiumCell.detailTextLabel setText:teamData.homeStadium.stadiumName];
        [homeStadiumMapView showAnnotations:@[teamData.homeStadium] animated:NO];
        [homeStadiumMapView setHidden:NO];
    }
    else {
        [homeStadiumMapView setHidden:YES];
    }
    if (teamData.slogan.length) {
        [sloganLabel setText:teamData.slogan];
    }
    if (teamData.recruitAnnouncement.length) {
        [recruitAnnouncementLabel setText:teamData.recruitAnnouncement];
    }
    [recruitFlagSwitch setOn:teamData.recruitFlag];
    if (teamData.challengeAnnouncement.length) {
        [challengeAnnouncementLabel setText:teamData.challengeAnnouncement];
    }
    [challengeFlagSwitch setOn:teamData.challengeFlag];
}

- (IBAction)applyInButtonOnClicked:(id)sender {
    MessageCenter_Compose *composeViewController = [[UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageCompose"];
    [composeViewController setComposeType:MessageComposeType_Applyin];
    [composeViewController setToList:@[teamData]];
    [self.navigationController pushViewController:composeViewController animated:YES];
}

- (IBAction)challengeButtonOnClicked:(id)sender {
    switch (viewType) {
        case TeamDetailsViewType_CreateMatch:
            delegate = (id)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
            [delegate selectedOpponentTeam:teamData];
            [self.navigationController popToViewController:(UIViewController *)delegate animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:homeStadiumMapCell] && !teamData.homeStadium) {
        return 0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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
