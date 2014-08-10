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
@property IBOutlet UILabel *messageTypeLabel;
@property IBOutlet UIView *unreadFlag;
@end

@implementation MessageCell
@synthesize messageBody, messageHead, messageTypeLabel, unreadFlag;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [unreadFlag.layer setCornerRadius:unreadFlag.frame.size.height/2];
    [unreadFlag.layer setMasksToBounds:YES];
}
@end

@interface MessageCenter ()
@property IBOutlet UISegmentedControl *sourceTypeController;
@end

@implementation MessageCenter{
    NSMutableArray *receivedMessageList;
    NSMutableArray *sentMessageList;
    NSDictionary *messageSubtypes;
    JSONConnect *connection;
    NSDictionary *unreadMessageAmount;
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
    
    NSArray *messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes"];
    messageSubtypes = [[messageTypes objectAtIndex:self.tabBarItem.tag] objectForKey:@"Subtypes"];
    
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestReceivedMessage:gMyUserInfo.userId messageTypes:messageSubtypes.allKeys status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:0 count:10 isSync:YES];
    [connection requestSentMessage:gMyUserInfo.userId messageTypes:messageSubtypes.allKeys status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:0 count:10 isSync:NO];
    
    [sourceTypeController setBackgroundColor:def_navigationBar_background];
    [sourceTypeController setTintColor:[UIColor whiteColor]];
    [self.tableView setTableHeaderView:sourceTypeController];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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

-(IBAction)switchReceivedAndSent:(id)sender
{
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
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:def_MessageDateformat];
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Message *message = [sourceTypeController.selectedSegmentIndex?sentMessageList:receivedMessageList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    [cell.messageBody setText:message.messageBody];
    [cell.messageTypeLabel setText:[messageSubtypes objectForKey:[NSNumber numberWithInteger:message.messageType].stringValue]];
    if (sourceTypeController.selectedSegmentIndex == 0) {
        [cell.messageHead setText:MessageBodyFormat_Receiver(message.senderName, [dateFormatter stringFromDate:message.creationDate])];
    }
    else {
        [cell.messageHead setText:MessageBodyFormat_Sender(message.receiverName, [dateFormatter stringFromDate:message.creationDate])];
    }
    [cell.unreadFlag setHidden:message.status != 0 || sourceTypeController.selectedSegmentIndex];
    
    return cell;
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
