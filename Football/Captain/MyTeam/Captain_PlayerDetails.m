//
//  Captain_PlayerDetails.m
//  Football
//
//  Created by Andy Xu on 14-5-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#define fake_PlayerDetails @[@[@"1986.2.18", @"北京", @"五道口", @"左脚 前锋 速度快"], @[@"2013.2.18", @"20", @"18", @"13"]]

#import "Captain_PlayerDetails.h"

@implementation Captain_PlayerDetails{
    NSArray *detailTitles;
}
@synthesize playerDetailsTableView, summaryView, playerCommentTextView, actionToolBar, nickNameTitle, nickName, playerNameTitle, playerName, nextMatchStatusTitle, nextMatchStatus, playerTeamTitle, playerTeam, notifyTrialButton, agreeButton, declineButton, recruitButton, temporaryButton;
@synthesize viewType, hasTeam;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    [playerDetailsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [playerDetailsTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
    
    switch (viewType) {
        case MyPlayer:
            [self initialViewForMyPlayer];
            break;
        case Applicant:
            [self initialViewForApplicant];
            break;
        case FreePlayer:
            [self initialViewForFreePlayer];
            break;
        default:
            break;
    }
}

-(void)initialViewForMyPlayer
{
    [nickNameTitle setHidden:NO];
    [nickName setHidden:NO];
    [playerNameTitle setHidden:NO];
    [playerName setHidden:NO];
    [nextMatchStatusTitle setHidden:NO];
    [nextMatchStatus setHidden:NO];
    [playerTeamTitle setHidden:YES];
    [playerTeam setHidden:YES];
    [playerCommentTextView setHidden:YES];
    [actionToolBar setHidden:YES];
    
    detailTitles = def_PlayerDetails;
}

-(void)initialViewForApplicant
{
    [nickNameTitle setHidden:NO];
    [nickName setHidden:NO];
    [playerNameTitle setHidden:YES];
    [playerName setHidden:YES];
    [nextMatchStatusTitle setHidden:YES];
    [nextMatchStatus setHidden:YES];
    [playerTeamTitle setHidden:NO];
    [playerTeam setHidden:NO];
    [playerCommentTextView setHidden:NO];
    [playerCommentTextView sizeToFit];
    CGRect commentFrame = playerCommentTextView.frame;
    commentFrame.size.width = 320;
    [playerCommentTextView setFrame:commentFrame];
    
    CGFloat playerCommentTextViewHeight = playerCommentTextView.bounds.size.height;
    CGRect tableFrame = playerDetailsTableView.frame;
    tableFrame.origin.y += playerCommentTextViewHeight;
    tableFrame.size.height -= (playerCommentTextViewHeight + actionToolBar.bounds.size.height);
    [playerDetailsTableView setFrame:tableFrame];
    
    CGFloat oneThirdHeight = (nickName.center.y + playerTeam.center.y) / 3;
    [nickNameTitle setCenter:CGPointMake(nickNameTitle.center.x, oneThirdHeight)];
    [nickName setCenter:CGPointMake(nickName.center.x, oneThirdHeight)];
    [playerTeamTitle setCenter:CGPointMake(playerTeamTitle.center.x, oneThirdHeight * 2)];
    [playerTeam setCenter:CGPointMake(playerTeam.center.x, oneThirdHeight * 2)];
    
    [actionToolBar setHidden:NO];
    [actionToolBar setItems:@[def_flexibleSpace, notifyTrialButton, def_flexibleSpace, agreeButton, def_flexibleSpace, declineButton, def_flexibleSpace]];
    
    detailTitles = def_PlayerDetails;
}

-(void)initialViewForFreePlayer
{
    [nickNameTitle setHidden:NO];
    [nickName setHidden:NO];
    [playerNameTitle setHidden:YES];
    [playerName setHidden:YES];
    [nextMatchStatusTitle setHidden:YES];
    [nextMatchStatus setHidden:YES];
    [playerTeamTitle setHidden:!hasTeam];
    [playerTeam setHidden:!hasTeam];
    [playerCommentTextView setHidden:YES];
    CGRect tableFrame = playerDetailsTableView.frame;
    tableFrame.size.height -= actionToolBar.bounds.size.height;
    [playerDetailsTableView setFrame:tableFrame];
    [actionToolBar setHidden:NO];
    [actionToolBar setItems:@[def_flexibleSpace, recruitButton, def_flexibleSpace, temporaryButton, def_flexibleSpace]];
    CGFloat oneThirdHeight = (nickName.center.y + playerTeam.center.y) / 3;
    [nickNameTitle setCenter:CGPointMake(nickNameTitle.center.x, oneThirdHeight)];
    [nickName setCenter:CGPointMake(nickName.center.x, oneThirdHeight)];
    [playerTeamTitle setCenter:CGPointMake(playerTeamTitle.center.x, oneThirdHeight * 2)];
    [playerTeam setCenter:CGPointMake(playerTeam.center.x, oneThirdHeight * 2)];
    
    detailTitles = hasTeam?def_PlayerDetails:@[def_PlayerDetails[0]];
}

-(IBAction)agreeButtonOnClicked:(id)sender
{
    NSLog(@"同意");
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)declineButtonOnClicked:(id)sender
{
    NSLog(@"拒绝");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [detailTitles count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [detailTitles[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.textLabel setText:detailTitles[indexPath.section][indexPath.row]];
    [cell.detailTextLabel setText:fake_PlayerDetails[indexPath.section][indexPath.row]];
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"NotifyTrial"]) {
        Captain_NotifyPlayers *notifyPlayer = segue.destinationViewController;
        [notifyPlayer setViewType:NotifyTrial];
        [notifyPlayer setPlayerList:@[nickName.text]];
        [notifyPlayer setPredefinedNotification:@"“本队队名”通知您于“比赛时间”，在“比赛地点”，进行比赛试训。请准时到场，留下美好印象。"];
    }
    else if ([segue.identifier isEqualToString:@"RecruitPlayer"]) {
        Captain_NotifyPlayers *notifyPlayer = segue.destinationViewController;
        [notifyPlayer setViewType:RecruitPlayer];
        [notifyPlayer setPlayerList:@[nickName.text]];
        [notifyPlayer setPredefinedNotification:@"恭喜！“本队队名”看中你了，主力位置有保证，速来投靠！"];
    }
    else if ([segue.identifier isEqualToString:@"TemporaryFavor"]) {
        Captain_NotifyPlayers *notifyPlayer = segue.destinationViewController;
        [notifyPlayer setViewType:TemporaryFavor];
        [notifyPlayer setPlayerList:@[nickName.text]];
        [notifyPlayer setPredefinedNotification:@"“本队队名”于“比赛时间”，在“比赛地点”，有一场“赛制”比赛，特邀请你参加。请拔腿相助，来了就是主力，来的就是朋友！"];
    }
}

@end
