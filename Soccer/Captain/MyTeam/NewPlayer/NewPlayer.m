//
//  NewPlayer.m
//  Soccer
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "NewPlayer.h"
#import "PlayerDetails.h"
#import "MessageCenter_ApplyinPlayerProfile.h"
#import "MessageCenter_Compose.h"

#pragma NewPlayer_Cell
@interface NewPlayer_Cell ()
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

@implementation NewPlayer_Cell{
    UIAlertView *confirmAgreement;
}
@synthesize nickNameLabel, positionLabel, ageLabel, agreementSegment, playerPortaitImageView, activityRegionLabel, styleLabel, timeStampLabel, statusLabel, statusView;
@synthesize message, player;

- (void)awakeFromNib {
    [playerPortaitImageView.layer setCornerRadius:10.0f];
    [playerPortaitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerPortaitImageView.layer setBorderWidth:1.0f];
    [playerPortaitImageView.layer setMasksToBounds:YES];

    [statusView.layer setCornerRadius:5.0f];
    [statusLabel.layer setCornerRadius:5.0f];
}

- (IBAction)agreementOnClicked:(id)sender {
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
                [composeViewController setToList:@[player]];
                [mainNavigationController pushViewController:composeViewController animated:YES];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:confirmAgreement]) {
        JSONConnect *connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:mainNavigationController];
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
            [agreementSegment setEnabled:NO];
        }
        else {
            [agreementSegment setSelectedSegmentIndex:-1];
        }
    }
}

- (void)replyApplyinMessageSuccessfully:(NSInteger)responseCode {
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
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageStatusUpdated" object:message];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:responseString delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
    [alertView show];
}
@end

#pragma NewPlayerTableView
@interface NewPlayerTableView ()
@property IBOutlet UISegmentedControl *typeSegement;
@end

@implementation NewPlayerTableView {
    JSONConnect *connection;
    NSMutableArray *applyinList;
    NSMutableArray *callinList;
    NSDate *applyinListLastRefreshDate;
    NSDate *callinListLastRefreshDate;
    NSMutableDictionary *messageReferenceDictionary;
    NSInteger count;
    NSInteger loadingMessageReferenceNumber;
    enum LoadMoreStatus lastApplyInPageLoadMoreStatus;
    enum LoadMoreStatus lastCallInPageLoadMoreStatus;
}
@synthesize typeSegement;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllowAutoRefreshing:YES];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self initialWithLabelTexts:nil];
    
    //Regiester Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"MessageStatusUpdated" object:nil];

    count = [[gSettings objectForKey:@"newPlayerListCount"] integerValue];
    messageReferenceDictionary = [NSMutableDictionary new];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:mainNavigationController];
}

- (void)refreshTableView:(NSNotification *)notification {
    Message *message = notification.object;
    if (message) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[applyinList indexOfObject:message] inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)switchType:(id)sender {
    switch (typeSegement.selectedSegmentIndex) {
        case 0:
            if (!callinListLastRefreshDate || [[NSDate date] timeIntervalSinceDate:applyinListLastRefreshDate] - [[gSettings objectForKey:@"autoRefreshPeriod"] integerValue] >= 0) {
                [self startLoadingMore:YES];
            }
            else {
                [self.tableView reloadData];
                [self setLoadMoreStatus:lastApplyInPageLoadMoreStatus];
            }
            break;
        case 1:
            if (!callinListLastRefreshDate || [[NSDate date] timeIntervalSinceDate:applyinListLastRefreshDate] - [[gSettings objectForKey:@"autoRefreshPeriod"] integerValue] >= 0) {
                [self startLoadingMore:YES];
            }
            else {
                [self.tableView reloadData];
                [self setLoadMoreStatus:lastCallInPageLoadMoreStatus];
            }
            break;
        default:
            break;
    }
}

- (BOOL)startLoadingMore:(BOOL)isReload {
    if (isReload) {
        switch (typeSegement.selectedSegmentIndex) {
            case 0:
                applyinList = [NSMutableArray new];
                break;
            case 1:
                callinList = [NSMutableArray new];
                break;
            default:
                break;
        }
    }
    if ([super startLoadingMore:isReload]) {
        switch (typeSegement.selectedSegmentIndex) {
            case 0:
                [connection requestReceivedMessage:gMyUserInfo messageType:@"2" status:@[@0, @1, @2, @3, @4] startIndex:applyinList.count count:count isSync:YES];
                break;
            case 1:
                [connection requestSentMessage:gMyUserInfo messageType:@"1" status:@[@0, @1, @2, @3, @4] startIndex:callinList.count count:count isSync:YES];
                break;
            default:
                break;
        }
        return YES;
    }
    return NO;
}

-(void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType
{
    if (sourceType == RequestMessageSourceType_Receiver) {
        [applyinList addObjectsFromArray:messages];
        if (applyinList.count == 0) {
            [self finishedLoadingWithNewStatus:LoadMoreStatus_NoData];
        }
        else {
            [self finishedLoadingWithNewStatus:(messages.count == count)?LoadMoreStatus_LoadMore:LoadMoreStatus_NoMoreData];
        }
        lastApplyInPageLoadMoreStatus = self.loadMoreStatus;
        
        //Request UserInfo for each message.
        loadingMessageReferenceNumber = 0;
        for (Message *message in messages) {
            [connection requestUserInfo:message.senderId withTeam:NO withReference:[NSNumber numberWithInteger:message.messageId]];
            loadingMessageReferenceNumber++;
        }
    }
    else if (sourceType == RequestMessageSourceType_Sender) {
        [callinList addObjectsFromArray:messages];
        if (callinList.count == 0) {
            [self finishedLoadingWithNewStatus:LoadMoreStatus_NoData];
        }
        else {
            [self finishedLoadingWithNewStatus:(messages.count == count)?LoadMoreStatus_LoadMore:LoadMoreStatus_NoMoreData];
        }
        lastCallInPageLoadMoreStatus = self.loadMoreStatus;
        
        //Request UserInfo for each message.
        loadingMessageReferenceNumber = 0;
        for (Message *message in messages) {
            [connection requestUserInfo:message.receiverId withTeam:NO withReference:[NSNumber numberWithInteger:message.messageId]];
            loadingMessageReferenceNumber++;
        }
    }
}

- (void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference {
    [messageReferenceDictionary setObject:userInfo forKey:reference];
    loadingMessageReferenceNumber--;
    if (loadingMessageReferenceNumber == 0) {
        [self.tableView reloadData];
        switch (typeSegement.selectedSegmentIndex) {
            case 0:
                applyinListLastRefreshDate = [NSDate date];
                break;
            case 1:
                callinListLastRefreshDate = [NSDate date];
                break;
            default:
                break;
        }
    }
    else {
        [connection.busyIndicatorDelegate lockView];
    }
}

//TableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (typeSegement.selectedSegmentIndex) {
        case 0:
            return applyinList.count;
        case 1:
            return callinList.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NewPlayerCell";
    NewPlayer_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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
                [cell.statusView setBackgroundColor:cLightBlue(1)];
                break;
            case 2:
                [cell.agreementSegment setSelectedSegmentIndex:0];
                [cell.agreementSegment setEnabled:NO];
                [cell.statusView setBackgroundColor:cLightGreen(1)];
                break;
            case 3:
                [cell.agreementSegment setSelectedSegmentIndex:2];
                [cell.agreementSegment setEnabled:NO];
                [cell.statusView setBackgroundColor:cRed(1)];
                break;
            case 4:
                [cell.agreementSegment setSelectedSegmentIndex:-1];
                [cell.agreementSegment setEnabled:NO];
                [cell.statusView setBackgroundColor:cGray(1)];
                break;
            default:
                break;
        }
        NSArray *messageStatusType = [gUIStrings objectForKey:@"UI_MessageStatusType"];
        [cell.statusLabel setText:[messageStatusType objectAtIndex:message.status]];
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
                [cell.statusLabel setBackgroundColor:cLightBlue(1)];
                break;
            case 2:
                [cell.statusLabel setBackgroundColor:cLightGreen(1)];
                break;
            case 3:
                [cell.statusLabel setBackgroundColor:cRed(1)];
                break;
            case 4:
                [cell.statusLabel setBackgroundColor:cGray(1)];
                break;
            default:
                break;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:def_MessageDateformat];
        [cell.timeStampLabel setText:[dateFormatter stringFromDate:message.creationDate]];
        [cell.agreementSegment setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (typeSegement.selectedSegmentIndex == 0) {
        Message *message = [applyinList objectAtIndex:indexPath.row];
        UserInfo *player = [messageReferenceDictionary objectForKey:[NSNumber numberWithInteger:message.messageId]];
        PlayerDetails *playerDetailController = (PlayerDetails *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerDetails"];
        [playerDetailController setMessage:message];
        [playerDetailController setPlayerData:player];
        [playerDetailController setViewType:PlayerDetails_Applicant];
        [mainNavigationController pushViewController:playerDetailController animated:YES];
    }
    else if (typeSegement.selectedSegmentIndex == 1) {
        Message *message = [callinList objectAtIndex:indexPath.row];
        UserInfo *player = [messageReferenceDictionary objectForKey:[NSNumber numberWithInteger:message.messageId]];
        PlayerDetails *playerDetailController = (PlayerDetails *)[self.storyboard instantiateViewControllerWithIdentifier:@"PlayerDetails"];
        [playerDetailController setMessage:message];
        [playerDetailController setPlayerData:player];
        [playerDetailController setViewType:PlayerDetails_Callin];
        [mainNavigationController pushViewController:playerDetailController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (typeSegement.selectedSegmentIndex) {
        case 0:
            if (indexPath.row == applyinList.count - 1) {
                return self.tableView.rowHeight - 10;
            }
            else {
                return self.tableView.rowHeight;
            }
        case 1:
            if (indexPath.row == callinList.count - 1) {
                return self.tableView.rowHeight - 10;
            }
            else {
                return self.tableView.rowHeight;
            }
        default:
            return self.tableView.rowHeight;
    }
}

@end

#pragma NewPlayer
@interface NewPlayer ()
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UISegmentedControl *typeSegement;
@property IBOutlet UILabel *numOfTeamMemberLabel;
@property IBOutlet UILabel *numOfApplyinLabel;
@property IBOutlet UILabel *numOfCallinLabel;
@property IBOutlet UIToolbar *actionBar;
@end

@implementation NewPlayer{
    JSONConnect *connection;
    NSArray *applyinList;
    NSArray *callinList;
    NSMutableDictionary *messageReferenceDictionary;
    CallFriends *callFriends;
}
@synthesize teamLogoImageView, typeSegement, numOfApplyinLabel, numOfCallinLabel, numOfTeamMemberLabel, actionBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    messageReferenceDictionary = [NSMutableDictionary new];
//    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view.layer setContents:(__bridge id)bgImage];
    [self setToolbarItems:actionBar.items];
    callFriends = [[CallFriends alloc] initWithPresentingViewController:self];
    
    //Set TeamLogo ImageView
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setBorderWidth:1.0f];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setMasksToBounds:YES];
    
    //Set TeamInfo
    [teamLogoImageView setImage:gMyUserInfo.team.teamLogo?gMyUserInfo.team.teamLogo:def_defaultTeamLogo];
    [numOfTeamMemberLabel setText:[NSNumber numberWithInteger:gMyUserInfo.team.numOfMember].stringValue];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (IBAction)callFriendsButtonOnClicked:(id)sender {
    [callFriends showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%@", [actionSheet buttonTitleAtIndex:buttonIndex]);
//    addressbookPeoplePicker = [[ABPeoplePickerNavigationController alloc] init];
//    [addressbookPeoplePicker setPeoplePickerDelegate:self];
//    [self presentViewController:addressbookPeoplePicker animated:YES completion:nil];
    
    //MFMessage
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        NSString *messageTemplateFile = [[NSBundle mainBundle] pathForResource:@"MessageTemplate" ofType:@"plist"];
        NSDictionary *messageTemplate = [NSDictionary dictionaryWithContentsOfFile:messageTemplateFile];
        [messageController setMessageComposeDelegate:(id)self];
        [messageController setBody:[messageTemplate objectForKey:@"SMS_InviteFriends"]];
        [self presentViewController:messageController animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Unsupported"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    UIAlertView *alertView;
    switch (result) {
        case MessageComposeResultCancelled:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Cancelled"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
            break;
        case MessageComposeResultFailed:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Failed"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
            break;
        case MessageComposeResultSent:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Successful"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
        default:
            break;
    }
    [alertView show];
    [controller dismissViewControllerAnimated:NO completion:nil];
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