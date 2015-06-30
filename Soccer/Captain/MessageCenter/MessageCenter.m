//
//  MessageCenter.m
//  Soccer
//
//  Created by Andy on 14-8-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenter.h"
#import "MessageCenter_CallinTeamProfile.h"
#import "MessageCenter_ApplyinPlayerProfile.h"
#import "PlayerDetails.h"
#import "TeamDetails.h"
#import "MatchDetails.h"

@interface MessageCell()
@property IBOutlet UITextView *messageBody;
@property IBOutlet UILabel *messageHead;
@property IBOutlet UILabel *messageTypeLabel;
@property IBOutlet UILabel *statusLabel;

@end

@implementation MessageCell
@synthesize messageBody, messageHead, messageTypeLabel, statusLabel;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [statusLabel.layer setCornerRadius:5.0f];
    [statusLabel.layer setMasksToBounds:YES];
}
@end

@interface MessageCenter ()
@property IBOutlet UITextFieldForMessageTypeSelection *messageTypeTextField;
@property IBOutlet UITapGestureRecognizer *dismissKeyboardGestureRecognizer;
@end

@implementation MessageCenter{
    NSMutableArray *messageList;
    NSDictionary *messageTypes;
    JSONConnect *connection;
    NSDictionary *unreadMessageAmount;
    NSInteger count;
    NSArray *messageStatusType;
}
@synthesize messageTypeTextField, dismissKeyboardGestureRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)bgImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"MessageStatusUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTapGesture) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTapGesture) name:UITextFieldTextDidEndEditingNotification object:nil];
    [self initialWithLabelTexts:@"MessageCenter"];
    [self.tableView setAllowsSelection:!self.tabBarItem.tag];
    if (gMyUserInfo.userType) {
        [messageTypeTextField initialMessageTypes:self.tabBarItem.tag userType:0];
    }
    else if (gMyUserInfo.team) {
        [messageTypeTextField initialMessageTypes:self.tabBarItem.tag userType:1];
    }
    else {
        [messageTypeTextField initialMessageTypes:self.tabBarItem.tag userType:2];
    }
    
    messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes"];
    messageStatusType = [gUIStrings objectForKey:@"UI_MessageStatusType"];
    
    count = [[gSettings objectForKey:@"messageListCount"] integerValue];
    messageList = [NSMutableArray new];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    [self setAllowAutoRefreshing:[messageTypeTextField selectedMessageType]];
    if (self.tabBarItem.tag == 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadMessageAmount) name:@"MessageStatusUpdated" object:nil];
        [self refreshUnreadMessageAmount];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)refreshTableView {
    [self.tableView reloadData];
}

- (void)refreshUnreadMessageAmount {
    if (gUnreadMessageAmount) {
        if ([[gUnreadMessageAmount.allValues valueForKeyPath:@"@sum.self"] integerValue] == 0) {
            [self.tabBarItem setBadgeValue:nil];
        }
        else {
            [self.tabBarItem setBadgeValue:[[gUnreadMessageAmount.allValues valueForKeyPath:@"@sum.self"] stringValue]];
        }
    }
}

- (void)toggleTapGesture {
    [dismissKeyboardGestureRecognizer setEnabled:messageTypeTextField.isFirstResponder];
}

- (void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType {
    if (messageList) {
        [messageList addObjectsFromArray:messages];
    }
    else {
        messageList = [NSMutableArray arrayWithArray:messages];
    }
    if (messageList.count == 0) {
        [self finishedLoadingWithNewStatus:LoadMoreStatus_NoData];
    }
    else {
        [self finishedLoadingWithNewStatus:(messages.count == count)?LoadMoreStatus_LoadMore:LoadMoreStatus_NoMoreData];
    }
    [self.tableView reloadData];
}

- (void)readMessagesSuccessfully:(NSArray *)messageIdList {
    for (NSNumber *messageId in messageIdList) {
        for (Message *message in messageList) {
            if (message.messageId == messageId.integerValue) {
                [message setStatus:1];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:def_MessageDateformat];
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Message *message = [messageList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell.messageBody setText:message.messageBody];
    [cell.messageTypeLabel setText:[messageTypes objectForKey:[NSNumber numberWithInteger:message.messageType].stringValue]];
    if (self.tabBarItem.tag == 0) {
        [cell.messageHead setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MessageHead_Format"], [gUIStrings objectForKey:@"UI_MessageHead_Received"], message.senderName, [dateFormatter stringFromDate:message.creationDate]]];
    }
    else {
        [cell.messageHead setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MessageHead_Format"], [gUIStrings objectForKey:@"UI_MessageHead_Sent"], message.receiverName, [dateFormatter stringFromDate:message.creationDate]]];
    }
    [cell.statusLabel setText:messageStatusType[message.status]];
    if (self.tabBarItem.tag == 0) {
        [cell.statusLabel setBackgroundColor:(message.status == 0)?cRed(1):cLightBlue(1)];
    }
    else {
        [cell.statusLabel setBackgroundColor:cGray(1)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [messageList objectAtIndex:indexPath.row];
    PlayerDetails *playerDetails;
    TeamDetails *teamDetails;
    MatchDetails *matchDetails;
    if (message.status == 0 && self.tabBarItem.tag == 0) {
        [connection readMessages:@[[NSNumber numberWithInteger:message.messageId]]];
    }
    switch (message.messageType) {
        case 1://邀请加入
            teamDetails = [[UIStoryboard storyboardWithName:@"Soccer" bundle:nil] instantiateViewControllerWithIdentifier:@"TeamDetails"];
            [teamDetails setViewType:TeamDetailsViewType_CallinTeamProfile];
            [teamDetails setMessage:message];
            [self.navigationController pushViewController:teamDetails animated:YES];
            break;
        case 2://申请入队
            playerDetails = [[UIStoryboard storyboardWithName:@"Soccer" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayerDetails"];
            [playerDetails setViewType:PlayerDetails_Applicant];
            [playerDetails setMessage:message];
            [self.navigationController pushViewController:playerDetails animated:YES];
            break;
        case 3://比赛通知
        case 4://临时帮忙
            matchDetails = [[UIStoryboard storyboardWithName:@"Soccer" bundle:nil] instantiateViewControllerWithIdentifier:@"MatchDetails"];
            [matchDetails setViewType:MatchDetailsViewType_MatchNotice];
            [matchDetails setMessage:message];
            [self.navigationController pushViewController:matchDetails animated:YES];
            break;
        case 5://比赛邀请
            matchDetails = [[UIStoryboard storyboardWithName:@"Soccer" bundle:nil] instantiateViewControllerWithIdentifier:@"MatchDetails"];
            [matchDetails setViewType:MatchDetailsViewType_MatchInvitation];
            [matchDetails setMessage:message];
            [self.navigationController pushViewController:matchDetails animated:YES];
            break;
        case 6://队费通知
            break;
        default:
            break;
    }
}

- (BOOL)startLoadingMore:(BOOL)isReload {
    if (isReload) {
        messageList = [NSMutableArray new];
    }
    if ([super startLoadingMore:isReload]) {
        [self requestMessage];
        return YES;
    }
    return NO;
}

- (void)requestMessage {
    if ([messageTypeTextField selectedMessageType]) {
        switch (self.tabBarItem.tag) {
            case 0:
                [connection requestReceivedMessage:gMyUserInfo messageType:[messageTypeTextField selectedMessageType] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:messageList.count count:count isSync:YES];
                break;
            case 1:
                [connection requestSentMessage:gMyUserInfo messageType:[messageTypeTextField selectedMessageType] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:messageList.count count:count isSync:YES];
                break;
            default:
                break;
        }
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [messageTypeTextField resignFirstResponder];
}


#pragma MessageTypeSelectionDelegate
- (void)didSelectMessageType:(NSString *)messageTypeId {
    [self setLoadMoreStatus:LoadMoreStatus_LoadMore];
    [self startLoadingMore:YES];
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CallinTeamProfile"]) {
        MessageCenter_CallinTeamProfile *targetController = segue.destinationViewController;
        [targetController setMessage:sender];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"MessageStatusUpdated" object:nil];
    }
    else if ([segue.identifier isEqualToString:@"ApplyinPlayerProfile"]) {
        MessageCenter_ApplyinPlayerProfile *targetController = segue.destinationViewController;
        [targetController setMessage:sender];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"MessageStatusUpdated" object:nil];
    }
}
*/
@end
