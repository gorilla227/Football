//
//  MatchArrangement.m
//  Football
//
//  Created by Andy on 14/11/17.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MatchArrangement.h"
#import "MessageCenter_Compose.h"
#import "MatchDetails.h"
#import "PlayerMarket.h"
#import "EditTeamProfile.h"

@interface MatchArrangement ()
@property IBOutlet UIView *teamSummaryView;
@property IBOutlet UIImageView *teamLogo;
@property IBOutlet UILabel *teamName;
@property IBOutlet UILabel *numberOfTeamMembers;
@property IBOutlet UIButton *createMatchButton;
@property IBOutlet UIImageView *playerPortrait;
@property IBOutlet UIView *nonTeamSummaryView;
@property IBOutlet UILabel *playerName;
@property IBOutlet UIButton *findTeamButton;
@property IBOutlet UIButton *createTeamButton;
@end

@implementation MatchArrangement{
    JSONConnect *connection;
    Match *matchNotice_MatchData;
}
@synthesize teamSummaryView, teamLogo, teamName, numberOfTeamMembers, createMatchButton, nonTeamSummaryView, playerPortrait, playerName, findTeamButton, createTeamButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (gMyUserInfo.team) {
        [teamSummaryView setHidden:NO];
        [nonTeamSummaryView setHidden:YES];
        
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
        [createMatchButton setHidden:!gMyUserInfo.userType];
    }
    else {
        [teamSummaryView setHidden:YES];
        [nonTeamSummaryView setHidden:NO];
        
        [nonTeamSummaryView setBackgroundColor:[UIColor clearColor]];
        [playerPortrait.layer setBorderColor:[UIColor whiteColor].CGColor];
        [playerPortrait.layer setBorderWidth:2.0f];
        [playerPortrait.layer setCornerRadius:10.0f];
        [playerPortrait.layer setMasksToBounds:YES];
        if (gMyUserInfo.playerPortrait) {
            [playerPortrait setImage:gMyUserInfo.playerPortrait];
        }
        else {
            [playerPortrait setImage:def_defaultPlayerPortrait];
        }
        [playerName setText:gMyUserInfo.nickName];
        [findTeamButton.layer setCornerRadius:5.0f];
        [findTeamButton.layer setMasksToBounds:YES];
        [createTeamButton.layer setCornerRadius:5.0f];
        [createTeamButton.layer setMasksToBounds:YES];
    }
    
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

-(void)replyMatchNoticeSent:(BOOL)result{
    NSLog(@"%@", result?@"YES":@"NO");
}

#pragma MatchArrangementActionDelegate
-(void)noticeTeamMembers:(Match *)matchData {
    matchNotice_MatchData = matchData;
    [connection requestTeamMembers:gMyUserInfo.team.teamId isSync:YES];
}

-(void)noticeTempFavor:(Match *)matchData {
    matchNotice_MatchData = matchData;
    PlayerMarket *playerMarket = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerMarket"];
    [playerMarket setViewType:PlayerMarketViewType_FromMatchArrangement];
    [playerMarket setMatchData:matchData];
    [self.navigationController pushViewController:playerMarket animated:YES];
}

-(void)viewMatchDetails:(Match *)matchData {
    MatchDetails *matchDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchDetails"];
    [matchDetails setViewType:MatchDetailsViewType_ViewDetails];
    [matchDetails setMatchData:matchData];
    [self.navigationController pushViewController:matchDetails animated:YES];
}

-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer {
    [connection replyMatchNotice:messageId withAnswer:answer];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"CreateMatch"]) {
        MatchDetails *matchView = segue.destinationViewController;
        [matchView setViewType:MatchDetailsViewType_CreateMatch];
    }
}

@end

@implementation MatchArrangement_TabView

-(void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *tableViews = [NSMutableArray new];
    for (NSDictionary *tabInfo in [gUIStrings objectForKey:@"UI_MatchArrangement_Tab"]) {
        MatchArrangementTableView *tableView = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchListTableView"];
        [tableView.tabBarItem setTitle:[tabInfo objectForKey:@"Title"]];
//        [tableView.tabBarItem setImage:[tabInfo objectForKey:@"Icon"]];
        [tableViews addObject:tableView];
    }
    [self setViewControllers:tableViews];
}

@end