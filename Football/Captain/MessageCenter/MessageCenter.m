//
//  MessageCenter.m
//  Football
//
//  Created by Andy on 14-8-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenter.h"

@interface MessageCell()
@property IBOutlet UITextView *messageBody;
@property IBOutlet UILabel *messageHead;
@property IBOutlet UIButton *acceptButton;
@property IBOutlet UIButton *declineButton;
@end

@implementation MessageCell
@synthesize messageBody, messageHead;
@synthesize acceptButton, declineButton;
@synthesize message;

-(void)fillData:(Message *)messageData sourceType:(enum RequestMessageSourceType)sourceType
{
    [self setMessage:messageData];
    NSString *senderOrReceiver;
    [self.messageBody setText:messageData.messageBody];
    switch (message.messageType) {
        case 2:
            senderOrReceiver = [NSString stringWithFormat:@"%li", (long)message.senderId];
            [self.messageHead setText:MessageBodyFormat_Receiver(senderOrReceiver, messageData.creationDate)];
            break;
            
        default:
            break;
    }
}

-(IBAction)acceptButtonOnClicked:(id)sender
{
    
}

-(IBAction)declineButtonOnClicked:(id)sender
{
    
}
@end

@interface MessageCenter ()
@property IBOutlet UISegmentedControl *sourceTypeController;
@end

@implementation MessageCenter{
    NSMutableArray *receivedMessageList;
    NSMutableArray *sentMessageList;
    NSArray *messageSubtypes;
    JSONConnect *connection;
}
@synthesize sourceTypeController;

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
    [self.navigationController setNavigationBarHidden:NO];
    
    NSArray *messageTypes = messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes"];
    messageSubtypes = [[messageTypes objectAtIndex:self.tabBarItem.tag] objectForKey:@"Subtypes"];
    
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestMessageForSourceType:RequestMessageSourceType_Receiver source:5 messageType:2 startIndex:0 count:10 isSync:YES];
    
    [sourceTypeController setBackgroundColor:def_navigationBar_background];
    [sourceTypeController setTintColor:[UIColor whiteColor]];
    [self.tableView setTableHeaderView:sourceTypeController];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.tabBarItem setBadgeValue:@"5"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType
{
    switch (sourceType) {
        case RequestMessageSourceType_Receiver:
            if (receivedMessageList) {
                [receivedMessageList addObjectsFromArray:messages];
            }
            else {
                receivedMessageList = [NSMutableArray arrayWithArray:messages];
            }
            if (sourceTypeController.selectedSegmentIndex == 0) {
                [self.tableView reloadData];
            }
            break;
        case RequestMessageSourceType_Sender:
            if (sentMessageList) {
                [sentMessageList addObjectsFromArray:messages];
            }
            else {
                sentMessageList = [NSMutableArray arrayWithArray:messages];
            }
            if (sourceTypeController.selectedSegmentIndex == 1) {
                [self.tableView reloadData];
            }
            break;
        default:
            break;
    }
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
            return receivedMessageList.count;
        case 1:
            return sentMessageList.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    MessageCell *cell;
    if (sourceTypeController.selectedSegmentIndex == 0) {
        Message *message = [receivedMessageList objectAtIndex:indexPath.row];
        switch (message.messageType) {
            case 2:
                CellIdentifier = @"MessageCell_WithAction";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                [cell fillData:message sourceType:RequestMessageSourceType_Receiver];
                break;
            default:
                break;
        }
    }
    else {
        Message *message = [sentMessageList objectAtIndex:indexPath.row];
        CellIdentifier = @"MessageCell_WithoutAction";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell fillData:message sourceType:RequestMessageSourceType_Sender];
    }
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (sourceTypeController.selectedSegmentIndex == 0) {
        Message *message = [receivedMessageList objectAtIndex:indexPath.row];
        switch (message.messageType) {
            case 2:
                return 105;
            default:
                return 87;
        }
    }
    else {
        return 87;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
