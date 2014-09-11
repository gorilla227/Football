//
//  MessageCenter_Compose.m
//  Football
//
//  Created by Andy Xu on 14-8-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenter_Compose.h"

@interface MessageCenter_Compose ()
@property IBOutlet UITableView *playerListTableView;
@property IBOutlet UITextView *composeTextView;
@property IBOutlet UISegmentedControl *selectionSegment;
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *sendNotificationButton;
@end

@implementation MessageCenter_Compose{
    JSONConnect *connection;
}
@synthesize composeType, playerList;
@synthesize playerListTableView, composeTextView, selectionSegment, actionBar, sendNotificationButton;

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
    [self setToolbarItems:actionBar.items];
    [composeTextView initializeUITextFieldRoundCornerStyle];
    [playerListTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonsStatus) name:UITableViewSelectionDidChangeNotification object:nil];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    [self presetNotification];
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
    
    [self updateButtonsStatus];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [composeTextView resignFirstResponder];
}

-(void)presetNotification
{
    NSString *messageTemplateFile = [[NSBundle mainBundle] pathForResource:@"MessageTemplate" ofType:@"plist"];
    NSDictionary *messageTemplate = [[NSDictionary alloc] initWithContentsOfFile:messageTemplateFile];
    
    switch (composeType) {
        case MessageComposeType_Blank:
            if (playerList) {
                [self selectAllPlayers];
            }
            else {
                [connection requestTeamMembers:gMyUserInfo.team.teamId isSync:YES];
            }
            break;
        case MessageComposeType_Trial:
            [composeTextView setText:[messageTemplate objectForKey:@"Trial_Default"]];
            [self selectAllPlayers];
            break;
        case MessageComposeType_Recurit:
            [composeTextView setText:[messageTemplate objectForKey:@"Recruit_Default"]];
            [self selectAllPlayers];
            break;
        case MessageComposeType_TemporaryFavor:
            [composeTextView setText:[messageTemplate objectForKey:@"TemporaryFavor_Default"]];
            [self selectAllPlayers];
            break;
        default:
            break;
    }
}

-(void)updateButtonsStatus
{
    [self updateSelectionButtonStatus];
    [self updateSendNotificationButtonStatus];
}
-(void)updateSendNotificationButtonStatus
{
    NSString *notificationText = [[composeTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [sendNotificationButton setEnabled:(playerListTableView.indexPathsForSelectedRows.count && notificationText.length)];
}

-(void)updateSelectionButtonStatus
{
    if (playerList.count == 0) {
        [selectionSegment setSelectedSegmentIndex:-1];
        [selectionSegment setEnabled:NO];
    }
    else {
        [selectionSegment setEnabled:YES];
        if (playerListTableView.indexPathsForSelectedRows.count == 0) {
            [selectionSegment setSelectedSegmentIndex:1];
        }
        else if (playerListTableView.indexPathsForSelectedRows.count == playerList.count) {
            [selectionSegment setSelectedSegmentIndex:0];
        }
        else {
            [selectionSegment setSelectedSegmentIndex:-1];
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self updateSendNotificationButtonStatus];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [playerListTableView setUserInteractionEnabled:NO];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [playerListTableView setUserInteractionEnabled:YES];
}

-(IBAction)selectAllOrSelectNone:(id)sender
{
    switch (selectionSegment.selectedSegmentIndex) {
        case 0:
            [self selectAllPlayers];
            break;
        case 1:
            [self unselectAllPlayers];
            break;
        default:
            break;
    }
}

-(void)selectAllPlayers
{
    for (int i = 0; i < playerList.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [playerListTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        UITableViewCell *cell = [playerListTableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UITableViewSelectionDidChangeNotification object:nil];
}

-(void)unselectAllPlayers
{
    for (NSIndexPath *indexPath in playerListTableView.indexPathsForSelectedRows) {
        [playerListTableView deselectRowAtIndexPath:indexPath animated:NO];
        UITableViewCell *cell = [playerListTableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UITableViewSelectionDidChangeNotification object:nil];
}

-(void)receiveTeamMembers:(NSArray *)players
{
    playerList = players;
    [playerListTableView reloadData];
    [self selectAllPlayers];
    [self updateButtonsStatus];
}

-(IBAction)sendNotificationButtonOnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playerList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UserInfo *playerData = [playerList objectAtIndex:indexPath.row];
    [cell.textLabel setText:playerData.nickName];
    [cell.imageView setImage:playerData.playerPortrait?playerData.playerPortrait:def_defaultPlayerPortrait];
    [cell.imageView.layer setCornerRadius:10.0f];
    [cell.imageView.layer setMasksToBounds:YES];
    if ([tableView.indexPathsForSelectedRows containsObject:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
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
