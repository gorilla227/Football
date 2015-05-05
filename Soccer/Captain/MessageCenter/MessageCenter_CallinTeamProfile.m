//
//  MessageCenter_CallinTeamProfile.m
//  Soccer
//
//  Created by Andy on 14-8-10.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenter_CallinTeamProfile.h"

@interface MessageCenter_CallinTeamProfile ()
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UILabel *numOfTeamMemberLabel;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *homeStadiumLabel;
@property IBOutlet UILabel *activityRegionLabel;
@property IBOutlet UILabel *sloganLabel;
@property IBOutlet UIToolbar *actionBar;
@end

@implementation MessageCenter_CallinTeamProfile{
    JSONConnect *connection;
    Team *senderTeam;
}
@synthesize message;
@synthesize teamLogoImageView, teamNameLabel, numOfTeamMemberLabel, homeStadiumLabel, activityRegionLabel, sloganLabel, actionBar;

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
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Set the playerPortrait related controls
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setMasksToBounds:YES];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setBorderWidth:1.0f];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveTeam:(Team *)team
{
    senderTeam = team;
    if (team.teamLogo) {
        [teamLogoImageView setImage:team.teamLogo];
    }
    else {
        [teamLogoImageView setImage:def_defaultTeamLogo];
    }
    [teamNameLabel setText:team.teamName];
    [numOfTeamMemberLabel setText:[[NSNumber numberWithInteger:team.numOfMember] stringValue]];
    [homeStadiumLabel setText:team.homeStadium.stadiumName];
    [activityRegionLabel setText:[[ActivityRegion stringWithCode:team.activityRegion] componentsJoinedByString:@" "]];
    [sloganLabel setText:team.slogan];
}

-(void)replyCallinMessageSuccessfully:(NSInteger)responseCode
{
    [message setStatus:responseCode];
    NSString *responseString;
    switch (responseCode) {
        case 2:
            responseString = [gUIStrings objectForKey:@"UI_ReplayCallin_Accepted"];
            break;
        case 3:
            responseString = [gUIStrings objectForKey:@"UI_ReplayCallin_Declined"];
            break;
        default:
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:responseString delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageStatusUpdated" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (message.status == 0 || message.status == 1) {
        [self setToolbarItems:actionBar.items];
        [self.navigationController setToolbarHidden:NO];
    }
    else {
        [self.navigationController setToolbarHidden:YES];
    }
    [connection requestTeamById:message.senderId isSync:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    id<BusyIndicatorDelegate>busyIndicatorDelegate = (id)self.navigationController;
    [busyIndicatorDelegate unlockView];
}

-(IBAction)acceptButtonOnClicked:(id)sender
{
    [connection replyCallinMessage:message.messageId response:2];
}

-(IBAction)declineButtonOnClicked:(id)sender
{
    [connection replyCallinMessage:message.messageId response:3];
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
