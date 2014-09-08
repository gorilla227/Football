//
//  PlayerDetails.m
//  Football
//
//  Created by Andy Xu on 14-9-7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "PlayerDetails.h"

@interface PlayerDetails ()
@property IBOutlet UIToolbar *playerMarketActionBar;
@property IBOutlet UIToolbar *applicantActionBar;
@property IBOutlet UIToolbar *myPlayerActionBar;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UIImageView *playerProtraitImageView;
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UIView *teamNameBackgroundView;
@property IBOutlet UIView *nickNameBackgroundView;
@property IBOutlet UIBarButtonItem *recruitButton;
@property IBOutlet UIBarButtonItem *temporaryFavorButton;
@property IBOutlet UITableViewCell *legalNameCell;
@property IBOutlet UITableViewCell *ageCell;
@property IBOutlet UITableViewCell *emailCell;
@property IBOutlet UITableViewCell *qqCell;
@property IBOutlet UITableViewCell *mobileCell;
@property IBOutlet UITableViewCell *positionCell;
@property IBOutlet UITableViewCell *activityRegionCell;
@property IBOutlet UITableViewCell *styleCell;

-(void)initWithPlayerData;
@end

@implementation PlayerDetails
@synthesize playerData, viewType;
@synthesize playerMarketActionBar, applicantActionBar, myPlayerActionBar, nickNameLabel, nickNameBackgroundView, teamNameLabel, playerProtraitImageView, teamLogoImageView, teamNameBackgroundView, recruitButton, temporaryFavorButton, legalNameCell, ageCell, emailCell, qqCell, mobileCell, positionCell, activityRegionCell, styleCell;

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
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self initWithPlayerData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithPlayerData
{
    switch (viewType) {
        case PlayerDetails_FromPlayerMarket:
            [self setToolbarItems:playerMarketActionBar.items];
            [recruitButton setEnabled:!playerData.team];
            break;
        case PlayerDetails_Applicant:
            [self setToolbarItems:applicantActionBar.items];
            break;
        case PlayerDetails_MyPlayer:
            [self setToolbarItems:myPlayerActionBar.items];
            break;
        default:
            break;
    }
    
    
    [nickNameLabel setText:playerData.nickName];
    [nickNameBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [nickNameBackgroundView.layer setBorderWidth:3.0f];
    [nickNameBackgroundView.layer setCornerRadius:5.0f];
    [nickNameBackgroundView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [nickNameBackgroundView.layer setMasksToBounds:YES];
    
    [playerProtraitImageView setImage:playerData.playerPortrait?playerData.playerPortrait:def_defaultPlayerPortrait];
    [playerProtraitImageView.layer setCornerRadius:12.0f];
    [playerProtraitImageView.layer setMasksToBounds:YES];
    [playerProtraitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerProtraitImageView.layer setBorderWidth:3.0f];
    
    if (playerData.team) {
        [teamNameLabel setText:playerData.team.teamName];
        [teamLogoImageView setImage:playerData.team.teamLogo?playerData.team.teamLogo:def_defaultTeamLogo];
        [teamLogoImageView.layer setCornerRadius:8.0f];
        [teamLogoImageView.layer setMasksToBounds:YES];
        [teamLogoImageView.layer setBorderWidth:3.0f];
        [teamLogoImageView.layer setBorderColor:cLightBlue(1).CGColor];
        [teamNameBackgroundView setBackgroundColor:cLightBlue(1)];
        [teamNameBackgroundView.layer setCornerRadius:5.0f];
        [teamNameBackgroundView.layer setMasksToBounds:YES];
    }
    else {
        [teamNameLabel setText:nil];
    }
    
    //Basic Information
    [legalNameCell.detailTextLabel setText:playerData.legalName];
    [ageCell.detailTextLabel setText:[NSNumber numberWithInteger:[Age ageFromString:playerData.birthday]].stringValue];
    [emailCell.detailTextLabel setText:playerData.email];
    [qqCell.detailTextLabel setText:playerData.qq];
    [mobileCell.detailTextLabel setText:playerData.mobile];
    [activityRegionCell.detailTextLabel setText:[[ActivityRegion stringWithCode:playerData.activityRegion] componentsJoinedByString:@" "]];
    [positionCell.detailTextLabel setText:[Position stringWithCode:playerData.position]];
    [styleCell.detailTextLabel setText:playerData.style];
    
    //Match Record
    
    //TeamFund Record
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    switch (viewType) {
        case PlayerDetails_Applicant:
            return 1;
        case PlayerDetails_MyPlayer:
            return 3;
        case PlayerDetails_FromPlayerMarket:
            return playerData.team?3:1;
        default:
            return 3;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView.contentView setBackgroundColor:cLightGreen(1)];
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
