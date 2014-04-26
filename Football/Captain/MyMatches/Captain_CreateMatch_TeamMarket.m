//
//  Captain_CreateMatch_TeamMarket.m
//  Football
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch_TeamMarket.h"

#pragma Captain_CreateMatch_TeamMarket_Cell
@implementation Captain_CreateMatch_TeamMarket_Cell
@synthesize teamName, averAge, slogan, teamLogo, inviteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

@end

#pragma Captain_CreateMatch_TeamMarket
@implementation Captain_CreateMatch_TeamMarket{
    NSMutableArray *teamList;
}
@synthesize delegate;

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
    WebUtils *getDataConnection = [[WebUtils alloc] initWithServerURL:def_serverURL andDelegate:self];
    [getDataConnection requestData:def_JSONSuffix_allTeams forSelector:@selector(teamListDataReceived:)];
}

-(void)teamListDataReceived:(NSData *)data
{
    teamList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //Remove self team
    for (NSDictionary *team in teamList) {
        if ([[team objectForKey:@"id"] isEqual:[[myUserInfo objectForKey:@"team"] objectForKey:@"id"]]) {
            [teamList removeObject:team];
            break;
        }
    }
    
    //Move the selected team to the first object.
    if (self.selectedTeam) {
        [teamList removeObject:self.selectedTeam];
        [teamList insertObject:self.selectedTeam atIndex:0];
    }
    
    [self.tableView reloadData];
}

-(void)retrieveData:(NSData *)data forSelector:(SEL)selector
{
    if ([self canPerformAction:selector withSender:self]) {
        [self performSelectorInBackground:selector withObject:data];
    }
}

-(IBAction)inviteButtonOnClicked:(id)sender
{
    for (Captain_CreateMatch_TeamMarket_Cell *cell in self.tableView.visibleCells) {
        if ([cell.inviteButton isEqual:sender]) {
            [delegate receiveSelectedOpponent:[teamList objectAtIndex:[self.tableView indexPathForCell:cell].row]];
            break;
        }
    }
    [self.navigationController popToViewController:(UIViewController *)delegate animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return teamList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Captain_CreateMatch_TeamMarket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMarketCell"];
    
    // Configure the cell...
    NSDictionary *teamData = [teamList objectAtIndex:indexPath.row];
    [cell.teamName setText:[teamData objectForKey:@"teamName"]];
    if (self.selectedTeam && indexPath.row == 0) {
        [cell.teamName setHighlighted:YES];
        [cell.inviteButton setSelected:YES];
        [cell.inviteButton setEnabled:NO];
    }
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
