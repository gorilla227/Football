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
@property IBOutlet UISegmentedControl *sourceTypeController;
@property IBOutlet UILabel *moreLabel;
@property IBOutlet UIActivityIndicatorView *moreActivityIndicator;
@property IBOutlet UIView *moreFooterView;
@property IBOutlet UITableView *messageTableView;
@end

@implementation MessageCenter{
    NSMutableArray *receivedMessageList;
    NSMutableArray *sentMessageList;
    NSDictionary *messageSubtypes;
    JSONConnect *connection;
    NSDictionary *unreadMessageAmount;
    NSInteger count;
    BOOL haveMoreReceivedMessage;
    BOOL haveMoreSentMessage;
    BOOL isLoading;
    NSArray *messageSubtypeStatus;
}
@synthesize sourceTypeController, moreLabel, moreActivityIndicator, moreFooterView, messageTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"MessageStatusUpdated" object:nil];
    [messageTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    NSArray *messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes"];
    messageSubtypes = [[messageTypes objectAtIndex:self.tabBarItem.tag] objectForKey:@"Subtypes"];
    messageSubtypeStatus = [gUIStrings objectForKey:@"UI_MessageSubtypeStatus"];
    
    count = [[gSettings objectForKey:@"messageListCount"] integerValue];
    haveMoreReceivedMessage = YES;
    haveMoreSentMessage = YES;
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestReceivedMessage:gMyUserInfo.userId messageTypes:messageSubtypes.allKeys status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:0 count:count isSync:YES];
    [connection requestSentMessage:gMyUserInfo.userId messageTypes:messageSubtypes.allKeys status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:0 count:count isSync:NO];
    
    [sourceTypeController setBackgroundColor:def_navigationBar_background];
    [sourceTypeController setTintColor:[UIColor whiteColor]];
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
    [messageTableView reloadData];
}

-(void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType
{
    if (![messageTableView.tableFooterView isEqual:moreFooterView]) {
        [messageTableView setTableFooterView:moreFooterView];
    }
    
    switch (sourceType) {
        case RequestMessageSourceType_Receiver:
            if (receivedMessageList) {
                [receivedMessageList addObjectsFromArray:messages];
            }
            else {
                receivedMessageList = [NSMutableArray arrayWithArray:messages];
            }
            haveMoreReceivedMessage = (messages.count == count);
            if (sourceTypeController.selectedSegmentIndex == 0) {
                [messageTableView reloadData];
            }
            break;
        case RequestMessageSourceType_Sender:
            if (sentMessageList) {
                [sentMessageList addObjectsFromArray:messages];
            }
            else {
                sentMessageList = [NSMutableArray arrayWithArray:messages];
            }
            haveMoreSentMessage = (messages.count == count);
            if (sourceTypeController.selectedSegmentIndex == 1) {
                [messageTableView reloadData];
            }
            break;
        default:
            break;
    }
    [moreActivityIndicator stopAnimating];
    isLoading = NO;
}

-(void)readMessagesSuccessfully:(NSArray *)messageIdList
{
    for (NSNumber *messageId in messageIdList) {
        for (Message *message in receivedMessageList) {
            if (message.messageId == messageId.integerValue) {
                [message setStatus:1];
            }
        }
    }
    [messageTableView reloadData];
}

-(IBAction)switchReceivedAndSent:(id)sender
{
    [messageTableView setAllowsSelection:sourceTypeController.selectedSegmentIndex == 0];
    [messageTableView reloadData];
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
    switch (sourceTypeController.selectedSegmentIndex) {
        case 0:
            if (haveMoreReceivedMessage) {
                [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_LoadMore"]];
            }
            else {
                if (receivedMessageList.count == 0) {
                    [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_NoData"]];
                }
                else {
                    [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_NoMoreData"]];
                }
            }
            return receivedMessageList.count;
        case 1:
            if (haveMoreSentMessage) {
                [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_LoadMore"]];
            }
            else {
                if (sentMessageList.count == 0) {
                    [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_NoData"]];
                }
                else {
                    [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_NoMoreData"]];
                }
            }
            return sentMessageList.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:def_MessageDateformat];
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Message *message = [sourceTypeController.selectedSegmentIndex?sentMessageList:receivedMessageList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell.messageBody setText:message.messageBody];
    [cell.messageTypeLabel setText:[messageSubtypes objectForKey:[NSNumber numberWithInteger:message.messageType].stringValue]];
    if (sourceTypeController.selectedSegmentIndex == 0) {
        [cell.messageHead setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MessageHead_Format"], [gUIStrings objectForKey:@"UI_MessageHead_Received"], message.senderName, [dateFormatter stringFromDate:message.creationDate]]];
    }
    else {
        [cell.messageHead setText:[NSString stringWithFormat:[gUIStrings objectForKey:@"UI_MessageHead_Format"], [gUIStrings objectForKey:@"UI_MessageHead_Sent"], message.receiverName, [dateFormatter stringFromDate:message.creationDate]]];
    }
//    [cell.unreadFlag setHidden:message.status != 0 || sourceTypeController.selectedSegmentIndex];
    [cell.statusLabel setText:messageSubtypeStatus[message.status]];
    if (sourceTypeController.selectedSegmentIndex == 0) {
        [cell.statusLabel setBackgroundColor:(message.status == 0)?cRed(1):cLightBlue(1)];
    }
    else {
        [cell.statusLabel setBackgroundColor:cGray(1)];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [sourceTypeController.selectedSegmentIndex?sentMessageList:receivedMessageList objectAtIndex:indexPath.row];
    PlayerDetails *playerDetails;
    TeamDetails *teamDetails;
    MatchDetails *matchDetails;
    if (message.status == 0 && sourceTypeController.selectedSegmentIndex == 0) {
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
            matchDetails = [[UIStoryboard storyboardWithName:@"Soccer" bundle:nil] instantiateViewControllerWithIdentifier:@"MatchDetails"];
            [matchDetails setViewType:MatchDetailsViewType_MatchNotice];
            [matchDetails setMessage:message];
            [self.navigationController pushViewController:matchDetails animated:YES];
            break;
        case 4://临时帮忙
            break;
        case 5://比赛邀请
            break;
        default:
            break;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > MAX(scrollView.contentSize.height - scrollView.frame.size.height, 0) + 20 && !isLoading) {
        switch (sourceTypeController.selectedSegmentIndex) {
            case 0:
                if (haveMoreReceivedMessage) {
                    [connection requestReceivedMessage:gMyUserInfo.userId messageTypes:messageSubtypes.allKeys status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:receivedMessageList.count count:count isSync:NO];
                    [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_Loading"]];
                    [moreActivityIndicator startAnimating];
                    isLoading = YES;
                }
                break;
            case 1:
                if (haveMoreSentMessage) {
                    [connection requestSentMessage:gMyUserInfo.userId messageTypes:messageSubtypes.allKeys status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:sentMessageList.count count:count isSync:NO];
                    [moreLabel setText:[gUIStrings objectForKey:@"UI_MessageCenter_Loading"]];
                    [moreActivityIndicator startAnimating];
                    isLoading = YES;
                }
                break;
            default:
                break;
        }
    }
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
