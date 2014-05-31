//
//  Captain_NotifyPlayers.m
//  Football
//
//  Created by Andy Xu on 14-5-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_NotifyPlayers.h"

@implementation Captain_NotifyPlayers_Cell
@synthesize playerIcon, playerName;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [playerIcon.layer setCornerRadius:playerIcon.bounds.size.width/2];
    [playerIcon.layer setMasksToBounds:YES];
}
@end

@implementation Captain_NotifyPlayers
@synthesize playersTableView, notificationTextView, sendNotificationButton, selectAllButton, unselectAllButton;
@synthesize predefinedNotification, playerList, viewType;

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
    [playersTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [selectAllButton.layer setCornerRadius:3.0f];
    [unselectAllButton.layer setCornerRadius:3.0f];
    
    //Initial data
    if (predefinedNotification) {
        [notificationTextView setText:predefinedNotification];
    }
    
    //Select the all players when viewType is not "NotifyMyTeamPlayers"
    if (viewType != NotifyMyTeamPlayers) {
        [self selectAllButtonOnClicked:self];
    }
    [self updateButtonStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [notificationTextView resignFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self updateButtonStatus];
}

-(IBAction)selectAllButtonOnClicked:(id)sender
{
    for (int i = 0; i < playerList.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if (![playersTableView.indexPathsForSelectedRows containsObject:indexPath]) {
            [playersTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:playersTableView didSelectRowAtIndexPath:indexPath];
        }
    }
    [self updateButtonStatus];
}

-(IBAction)unselectAllButtonOnClicked:(id)sender
{
    for (NSIndexPath *indexPath in playersTableView.indexPathsForSelectedRows) {
        [playersTableView deselectRowAtIndexPath:indexPath animated:NO];
        [self tableView:playersTableView didDeselectRowAtIndexPath:indexPath];
    }
    [self updateButtonStatus];
}

-(IBAction)notifyPlayerButtonOnClicked:(id)sender
{
    NSMutableArray *selectedPlayers = [[NSMutableArray alloc] init];
    NSMutableString *ouputString;
    for (NSIndexPath *indexPath in playersTableView.indexPathsForSelectedRows) {
        [selectedPlayers addObject:playerList[indexPath.row]];
        if (ouputString.length == 0) {
            ouputString = [NSMutableString stringWithString:playerList[indexPath.row]];
        }
        else {
            [ouputString appendString:[NSString stringWithFormat:@" %@", playerList[indexPath.row]]];
        }
    }
    NSLog(@"Text: %@\nTo: %@", notificationTextView.text, ouputString);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)updateButtonStatus
{
    [selectAllButton setEnabled:playersTableView.indexPathsForSelectedRows.count != playerList.count];
    [unselectAllButton setEnabled:playersTableView.indexPathsForSelectedRows.count != 0];
    [sendNotificationButton setEnabled:[notificationTextView hasText] && playersTableView.indexPathsForSelectedRows.count > 0];
}

#pragma TableView Methods
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
    static NSString *CellIdentifier = @"NotifyPlayerCell";
    Captain_NotifyPlayers_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.playerName setText:playerList[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [notificationTextView resignFirstResponder];
    [self updateButtonStatus];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [notificationTextView resignFirstResponder];
    [self updateButtonStatus];
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
