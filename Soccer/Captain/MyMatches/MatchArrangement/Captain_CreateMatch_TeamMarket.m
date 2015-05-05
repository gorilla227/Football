//
//  Captain_CreateMatch_TeamMarket.m
//  Soccer
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
    JSONConnect *connection;
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
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    teamList = [[NSMutableArray alloc] init];
    
//    [connection requestAllTeamsWithCount:JSON_parameter_common_count_default startIndex:JSON_parameter_common_startIndex_default];
}

-(void)receiveTeams:(NSArray *)teams
{
    //Remove self team
//    for (Team *team in teams) {
//        if (![team.teamId isEqual:gMyUserInfo.team.teamId]) {
//            [teamList addObject:team];
//        }
//    }

    //Move the selected team to the first object.
    if (self.selectedTeam) {
        [teamList removeObject:self.selectedTeam];
        [teamList insertObject:self.selectedTeam atIndex:0];
    }
    
    [self.tableView reloadData];
}

-(IBAction)inviteButtonOnClicked:(id)sender
{
    for (Captain_CreateMatch_TeamMarket_Cell *cell in self.tableView.visibleCells) {
        if ([cell.inviteButton isEqual:sender]) {
            if (!delegate) {
                Captain_CreateMatch *createMatch = [self.storyboard instantiateViewControllerWithIdentifier:@"Captain_CreateMatch"];
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [viewControllers insertObject:createMatch atIndex:[viewControllers indexOfObject:self]];
                [self.navigationController setViewControllers:viewControllers];
                delegate = (id)createMatch;
                [delegate receiveSelectedOpponentForWarmupMatch:[teamList objectAtIndex:[self.tableView indexPathForCell:cell].row]];
            }
            else {
                [delegate receiveSelectedOpponent:[teamList objectAtIndex:[self.tableView indexPathForCell:cell].row]];
            }
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return teamList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Captain_CreateMatch_TeamMarket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMarketCell"];
    
    // Configure the cell...
    Team *teamData = [teamList objectAtIndex:indexPath.row];
    [cell.teamName setText:teamData.teamName];
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
