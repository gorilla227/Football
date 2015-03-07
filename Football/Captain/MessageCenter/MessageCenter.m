//
//  MessageCenter.m
//  Football
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
@property IBOutlet UIView *unreadFlag;
@property IBOutlet UILabel *statusLabel;

@end

@implementation MessageCell
@synthesize messageBody, messageHead, messageTypeLabel, unreadFlag, statusLabel;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [unreadFlag.layer setCornerRadius:unreadFlag.frame.size.height/2];
    [unreadFlag.layer setMasksToBounds:YES];
    [statusLabel.layer setCornerRadius:5.0f];
    [statusLabel.layer setMasksToBounds:YES];
}
@end

@interface MessageCenter ()
@property IBOutlet UITextFieldForMessageTypeSelection *messageTypeTextField;
@property IBOutlet UILabel *moreLabel;
@property IBOutlet UIActivityIndicatorView *moreActivityIndicator;
@property IBOutlet UIView *moreFooterView;
@property IBOutlet UITapGestureRecognizer *dismissKeyboardGestureRecognizer;
@end

@implementation MessageCenter{
    NSMutableArray *messageList;
    NSDictionary *messageTypes;
    JSONConnect *connection;
    NSDictionary *unreadMessageAmount;
    NSInteger count;
    BOOL haveMoreMessage;
    NSArray *messageStatusType;
}
@synthesize messageTypeTextField, moreLabel, moreActivityIndicator, moreFooterView, dismissKeyboardGestureRecognizer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"MessageStatusUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTapGesture) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleTapGesture) name:UITextFieldTextDidEndEditingNotification object:nil];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setAllowsSelection:!self.tabBarItem.tag];
    [messageTypeTextField initialMessageTypes:self.tabBarItem.tag userType:0];
    
    messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes"];
    messageStatusType = [gUIStrings objectForKey:@"UI_MessageStatusType"];
    
    count = [[gSettings objectForKey:@"messageListCount"] integerValue];
    messageList = [NSMutableArray new];
    haveMoreMessage = YES;    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    [self requestMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
}

-(void)refreshTableView
{
    [self.tableView reloadData];
}

-(void)toggleTapGesture {
    [dismissKeyboardGestureRecognizer setEnabled:messageTypeTextField.isFirstResponder];
}

-(void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType
{
    if (![self.tableView.tableFooterView isEqual:moreFooterView]) {
        [self.tableView setTableFooterView:moreFooterView];
    }
    
    if (messageList) {
        [messageList addObjectsFromArray:messages];
    }
    else {
        messageList = [NSMutableArray arrayWithArray:messages];
    }
    haveMoreMessage = (messages.count == count);
    [self.tableView reloadData];

    [moreActivityIndicator stopAnimating];
}

-(void)readMessagesSuccessfully:(NSArray *)messageIdList
{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (haveMoreMessage) {
        [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_LoadMore"]];
    }
    else {
        if (messageList.count == 0) {
            [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_NoData"]];
        }
        else {
            [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_NoMoreData"]];
        }
    }
    return messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
//    [cell.unreadFlag setHidden:message.status != 0 || self.tabBarItem.tag];
    [cell.statusLabel setText:messageStatusType[message.status]];
    if (self.tabBarItem.tag == 0) {
        [cell.statusLabel setBackgroundColor:(message.status == 0)?cRed(1):cLightBlue(1)];
    }
    else {
        [cell.statusLabel setBackgroundColor:cGray(1)];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        default:
            break;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > MAX(scrollView.contentSize.height - scrollView.frame.size.height, 0) + 20 && !moreActivityIndicator.isAnimating) {
        [self requestMessage];
        [moreActivityIndicator startAnimating];
    }
}

- (void)requestMessage {
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

- (IBAction)dismissKeyboard:(id)sender {
    [messageTypeTextField resignFirstResponder];
}


#pragma MessageTypeSelectionDelegate
- (void)didSelectMessageType:(NSString *)messageTypeId {
    messageList = [NSMutableArray new];
    haveMoreMessage = YES;
    [self requestMessage];
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
