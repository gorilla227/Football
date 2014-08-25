//
//  Captain_NewPlayer.m
//  Football
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_NewPlayer.h"
#import "CallFriends.h"
#import "MessageCenter_ApplyinPlayerProfile.h"
#import "MessageCenter_Compose.h"

#pragma Captain_NewPlayer_Cell
@interface Captain_NewPlayer_Cell ()
@property IBOutlet UIImageView *playerPortaitImageView;
@property IBOutlet UILabel *activityRegionLabel;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *positionLabel;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *styleLabel;
@property IBOutlet UILabel *timeStampLabel;
@property IBOutlet UIView *statusView;
@property IBOutlet UILabel *statusLabel;
@property IBOutlet UISegmentedControl *agreementSegment;
@end

@implementation Captain_NewPlayer_Cell{
    UIAlertView *confirmAgreement;
}
@synthesize nickNameLabel, positionLabel, ageLabel, agreementSegment, playerPortaitImageView, activityRegionLabel, styleLabel, timeStampLabel, statusLabel, statusView;
@synthesize message, player, navigationController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [playerPortaitImageView.layer setCornerRadius:10.0f];
    [playerPortaitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerPortaitImageView.layer setBorderWidth:1.0f];
    [playerPortaitImageView.layer setMasksToBounds:YES];

    [statusView.layer setCornerRadius:5.0f];
    [statusLabel.layer setCornerRadius:5.0f];
}

-(IBAction)agreementOnClicked:(id)sender
{
    confirmAgreement = [[UIAlertView alloc] init];
    [confirmAgreement setDelegate:self];
    switch (agreementSegment.selectedSegmentIndex) {
        case 0:
            [confirmAgreement setTitle:[gUIStrings objectForKey:@"UI_NewPlayer_AcceptTitle"]];
            [confirmAgreement setMessage:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_NewPlayer_AcceptMessage"], nickNameLabel.text]];
            [confirmAgreement addButtonWithTitle:[gUIStrings objectForKey:@"UI_NewPlayer_CancelButton"]];
            [confirmAgreement addButtonWithTitle:[gUIStrings objectForKey:@"UI_NewPlayer_AcceptButton"]];
            [confirmAgreement setCancelButtonIndex:0];
            [confirmAgreement show];
            break;
        case 1:
            NSLog(@"通知试训");
            if (player) {
                MessageCenter_Compose *composeViewController = [[UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageCompose"];
                [composeViewController setComposeType:MessageComposeType_Trial];
                [composeViewController setPlayerList:@[player]];
                [navigationController pushViewController:composeViewController animated:YES];
            }
            [agreementSegment setSelectedSegmentIndex:-1];
            break;
        case 2:
            [confirmAgreement setTitle:[gUIStrings objectForKey:@"UI_NewPlayer_DeclineTitle"]];
            [confirmAgreement setMessage:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_NewPlayer_DeclineMessage"], nickNameLabel.text]];
            [confirmAgreement addButtonWithTitle:[gUIStrings objectForKey:@"UI_NewPlayer_CancelButton"]];
            [confirmAgreement addButtonWithTitle:[gUIStrings objectForKey:@"UI_NewPlayer_DeclineButton"]];
            [confirmAgreement setCancelButtonIndex:0];
            [confirmAgreement show];
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:confirmAgreement]) {
        JSONConnect *connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:navigationController];
        if (buttonIndex == 1) {
            switch (agreementSegment.selectedSegmentIndex) {
                case 0:
                    NSLog(@"同意入队");
                    [connection replyApplyinMessage:message.messageId response:2];
                    break;
                case 2:
                    NSLog(@"拒绝入队");
                    [connection replyApplyinMessage:message.messageId response:3];
                    break;
                default:
                    break;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageStatusUpdated" object:nil];
            [agreementSegment setEnabled:NO];
        }
        else {
            [agreementSegment setSelectedSegmentIndex:-1];
        }
    }
}

-(void)replyApplyinMessageSuccessfully:(NSInteger)responseCode
{
    NSLog(@"%@", [NSNumber numberWithInteger:responseCode]);
    [message setStatus:responseCode];
    NSString *responseString;
    switch (responseCode) {
        case 2:
            responseString = [NSString stringWithFormat:[gUIStrings objectForKey:@"UI_ReplayApplyin_Accepted"], message.senderName];
            break;
        case 3:
            responseString = [NSString stringWithFormat:[gUIStrings objectForKey:@"UI_ReplayApplyin_Declined"], message.senderName];
            break;
        default:
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:responseString delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
    [alertView show];
}
@end

//#pragma Captain_NewPlayer_CallinCell
//@interface Captain_NewPlayer_CallinCell ()
//@property IBOutlet UILabel *playerName;
//@property IBOutlet UILabel *postion;
//@property IBOutlet UILabel *age;
//@property IBOutlet UILabel *team;
//@property IBOutlet UITextView *comment;
//@property IBOutlet UILabel *status;
//@property IBOutlet UIButton *cancelInvitationButton;
//@end
//@implementation Captain_NewPlayer_CallinCell
//@synthesize playerName, postion, age, team, comment, status, cancelInvitationButton;
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
//- (void)awakeFromNib
//{
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}
//
//-(IBAction)cancelInvitationButtonOnClicked:(id)sender
//{
//    UIAlertView *confirmCancel = [[UIAlertView alloc] initWithTitle:@"取消邀请" message:[NSString stringWithFormat:@"确定要取消对%@的邀请吗？", playerName.text] delegate:self cancelButtonTitle:@"撤销操作" otherButtonTitles:@"确定", nil];
//    [confirmCancel show];
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        [cancelInvitationButton setEnabled:NO];
//        [cancelInvitationButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//        NSLog(@"取消邀请");
//    }
//}
//@end

#pragma Captain_NewPlayer
@interface Captain_NewPlayer ()
@property IBOutlet UITableView *playerNewTableView;
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UISegmentedControl *typeSegement;
@property IBOutlet UILabel *numOfTeamMemberLabel;
@property IBOutlet UILabel *numOfApplyinLabel;
@property IBOutlet UILabel *numOfCallinLabel;
@property IBOutlet UIToolbar *actionBar;
@end

@implementation Captain_NewPlayer{
    JSONConnect *connection;
    NSArray *applyinList;
    NSArray *callinList;
    NSMutableDictionary *messageReferenceDictionary;
}
@synthesize playerNewTableView, teamLogoImageView, typeSegement, numOfApplyinLabel, numOfCallinLabel, numOfTeamMemberLabel, actionBar;

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
    messageReferenceDictionary = [NSMutableDictionary new];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setToolbarItems:actionBar.items];
    
    //Set tableView
    [playerNewTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Set TeamLogo ImageView
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setBorderWidth:1.0f];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setMasksToBounds:YES];
    
    //Set TeamInfo
    [teamLogoImageView setImage:gMyUserInfo.team.teamLogo?gMyUserInfo.team.teamLogo:def_defaultTeamLogo];
    [numOfTeamMemberLabel setText:[NSNumber numberWithInteger:gMyUserInfo.team.numOfMember].stringValue];
    
    //Regiester Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"MessageStatusUpdated" object:nil];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestReceivedMessage:gMyUserInfo.userId messageTypes:@[[NSNumber numberWithInteger:2]] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:0 count:[[gSettings objectForKey:@"messageListCount"] integerValue] isSync:YES];
    [connection requestSentMessage:gMyUserInfo.userId messageTypes:@[[NSNumber numberWithInteger:1]] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:0 count:[[gSettings objectForKey:@"messageListCount"] integerValue] isSync:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

-(void)refreshTableView
{
    [playerNewTableView reloadData];
}

-(void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType
{
    if (sourceType == RequestMessageSourceType_Receiver) {
        if (applyinList) {
            applyinList = [applyinList arrayByAddingObjectsFromArray:messages];
        }
        else {
            applyinList = messages;
        }
        if (messages.count == [[gSettings objectForKey:@"messageListCount"] integerValue]) {
            [connection requestReceivedMessage:gMyUserInfo.userId messageTypes:@[[NSNumber numberWithInteger:2]] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:applyinList.count count:[[gSettings objectForKey:@"messageListCount"] integerValue] isSync:YES];
        }
        else {
            for (Message *message in applyinList) {
                [connection requestUserInfo:message.senderId withTeam:NO withReference:[NSNumber numberWithInteger:message.messageId]];
            }
            if (typeSegement.selectedSegmentIndex == 0) {
                [playerNewTableView reloadData];
            }
        }
    }
    else if (sourceType == RequestMessageSourceType_Sender) {
        if (callinList) {
            callinList = [callinList arrayByAddingObjectsFromArray:messages];
        }
        else {
            callinList = messages;
        }
        if (messages.count == [[gSettings objectForKey:@"messageListCount"] integerValue]) {
            [connection requestSentMessage:gMyUserInfo.userId messageTypes:@[[NSNumber numberWithInteger:1]] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:callinList.count count:[[gSettings objectForKey:@"messageListCount"] integerValue] isSync:YES];
        }
        else {
            for (Message *message in callinList) {
                [connection requestUserInfo:message.senderId withTeam:NO withReference:[NSNumber numberWithInteger:message.messageId]];
            }
            if (typeSegement.selectedSegmentIndex == 1) {
                [playerNewTableView reloadData];
            }
        }
    }
}

-(void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference
{
    [messageReferenceDictionary setObject:userInfo forKey:reference];
    [playerNewTableView reloadData];
}

//TableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (typeSegement.selectedSegmentIndex == 0) {
        return applyinList.count;
    }
    else {
        return callinList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewPlayerCell";
    Captain_NewPlayer_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (typeSegement.selectedSegmentIndex == 0) {
        Message *message = [applyinList objectAtIndex:indexPath.row];
        [cell setMessage:message];
        UserInfo *player = [messageReferenceDictionary objectForKey:[NSNumber numberWithInteger:message.messageId]];
        
        // Configure the cell...
        if (player) {
            [cell.nickNameLabel setText:player.nickName];
            [cell.ageLabel setText:[NSNumber numberWithInteger:[Age ageFromString:player.birthday]].stringValue];
            [cell.activityRegionLabel setText:[[ActivityRegion stringWithCode:player.activityRegion] componentsJoinedByString:@" "]];
            [cell.styleLabel setText:player.style];
            [cell.positionLabel setText:[Position stringWithCode:player.position]];
            [cell.playerPortaitImageView setImage:player.playerPortrait?player.playerPortrait:def_defaultPlayerPortrait];
            [cell setPlayer:player];
        }

        switch (message.status) {
            case 0:
            case 1:
                [cell.agreementSegment setSelectedSegmentIndex:-1];
                [cell.agreementSegment setEnabled:YES];
                [cell.statusView setBackgroundColor:cLightBlue];
                break;
            case 2:
                [cell.agreementSegment setSelectedSegmentIndex:0];
                [cell.agreementSegment setEnabled:NO];
                [cell.statusView setBackgroundColor:cLightGreen];
                break;
            case 3:
                [cell.agreementSegment setSelectedSegmentIndex:2];
                [cell.agreementSegment setEnabled:NO];
                [cell.statusView setBackgroundColor:cRed];
                break;
            case 4:
                [cell.agreementSegment setSelectedSegmentIndex:-1];
                [cell.agreementSegment setEnabled:NO];
                [cell.statusView setBackgroundColor:cGray];
                break;
            default:
                break;
        }
        NSArray *messageSubtypeStatus = [gUIStrings objectForKey:@"UI_MessageSubtypeStatus"];
        [cell.statusLabel setText:[messageSubtypeStatus objectAtIndex:message.status]];
        [cell.statusLabel setBackgroundColor:[UIColor clearColor]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:def_MessageDateformat];
        [cell.timeStampLabel setText:[dateFormatter stringFromDate:message.creationDate]];
        [cell.agreementSegment setHidden:NO];
    }
    else {
        Message *message = [callinList objectAtIndex:indexPath.row];
        [cell setMessage:message];
        UserInfo *player = [messageReferenceDictionary objectForKey:[NSNumber numberWithInteger:message.messageId]];
        // Configure the cell...
        if (player) {
            [cell.nickNameLabel setText:player.nickName];
            [cell.ageLabel setText:[NSNumber numberWithInteger:[Age ageFromString:player.birthday]].stringValue];
            [cell.activityRegionLabel setText:[[ActivityRegion stringWithCode:player.activityRegion] componentsJoinedByString:@" "]];
            [cell.styleLabel setText:player.style];
            [cell.positionLabel setText:[Position stringWithCode:player.position]];
            [cell.playerPortaitImageView setImage:player.playerPortrait?player.playerPortrait:def_defaultPlayerPortrait];
            [cell setPlayer:player];
        }
        [cell.statusView setBackgroundColor:[UIColor clearColor]];
        switch (message.status) {
            case 0:
            case 1:
                [cell.statusLabel setBackgroundColor:cLightBlue];
                break;
            case 2:
                [cell.statusLabel setBackgroundColor:cLightGreen];
                break;
            case 3:
                [cell.statusLabel setBackgroundColor:cRed];
                break;
            case 4:
                [cell.statusLabel setBackgroundColor:cGray];
                break;
            default:
                break;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:def_MessageDateformat];
        [cell.timeStampLabel setText:[dateFormatter stringFromDate:message.creationDate]];
        [cell.agreementSegment setHidden:YES];
    }
    [cell setNavigationController:self.navigationController];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (typeSegement.selectedSegmentIndex == 0) {
        Message *message = [applyinList objectAtIndex:indexPath.row];
        MessageCenter_ApplyinPlayerProfile *playerDetailController = [[UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"Callin_PlayerProfile"];
        [playerDetailController setMessage:message];
        [self.navigationController pushViewController:playerDetailController animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight + 10;
}

-(IBAction)callFriendsButtonOnClicked:(id)sender
{
    CallFriends *callFriends = [[CallFriends alloc] initWithDelegate:self];
    [callFriends showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", [actionSheet buttonTitleAtIndex:buttonIndex]);
}

-(IBAction)switchType:(id)sender
{
    [playerNewTableView reloadData];
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