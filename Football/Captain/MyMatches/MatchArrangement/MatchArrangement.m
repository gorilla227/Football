//
//  MatchArrangement.m
//  Football
//
//  Created by Andy on 14/11/17.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MatchArrangement.h"
#import "MessageCenter_Compose.h"
#import "Captain_CreateMatch.h"

@interface MatchArrangement ()
@property IBOutlet UIView *teamSummaryView;
@property IBOutlet UIImageView *teamLogo;
@property IBOutlet UILabel *teamName;
@property IBOutlet UILabel *numberOfTeamMembers;
@property IBOutlet UIButton *createMatchButton;
@end

@implementation MatchArrangement{
    JSONConnect *connection;
    Match *matchNotice_MatchData;
}
@synthesize teamSummaryView, teamLogo, teamName, numberOfTeamMembers, createMatchButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [teamSummaryView setBackgroundColor:[UIColor clearColor]];
    [teamLogo.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogo.layer setBorderWidth:2.0f];
    [teamLogo.layer setCornerRadius:10.0f];
    [teamLogo.layer setMasksToBounds:YES];
    if (gMyUserInfo.team.teamLogo) {
        [teamLogo setImage:gMyUserInfo.team.teamLogo];
    }
    else {
        [teamLogo setImage:def_defaultTeamLogo];
    }
    [teamName setText:gMyUserInfo.team.teamName];
    [numberOfTeamMembers setText:[NSNumber numberWithInteger:gMyUserInfo.team.numOfMember].stringValue];
    [createMatchButton.layer setCornerRadius:5.0f];
    [createMatchButton.layer setMasksToBounds:YES];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
}

- (void)receiveTeamMembers:(NSArray *)players {
    if (players.count) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil];
        MessageCenter_Compose *messageCompose = [storyboard instantiateViewControllerWithIdentifier:@"MessageCompose"];
        [messageCompose setComposeType:MessageComposeType_MatchNotice];
        [messageCompose setToList:players];
        [messageCompose setOtherParameters:@{@"matchData":matchNotice_MatchData}];
        [self.navigationController pushViewController:messageCompose animated:YES];
    }
}

#pragma MatchArrangementActionDelegate
-(void)noticeTeamMembers:(Match *)matchData
{
    matchNotice_MatchData = matchData;
    [connection requestTeamMembers:gMyUserInfo.team.teamId isSync:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"CreateMatch"]) {
        Captain_CreateMatch *matchView = segue.destinationViewController;
        [matchView setSegueIdentifier:segue.identifier];
    }
}

@end
