//
//  Captain_EnterBalance.m
//  Football
//
//  Created by Andy on 14-5-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#define fake_playerList @[@[@"ana", @"100"], @[@"bob", @"220"], @[@"Cindy", @"339"], @[@"Dean", @"423"], @[@"Emily", @"587"], @[@"Francis", @"633"], @[@"Glen", @"789"], @[@"Harry", @"887"], @[@"Ideal", @"999"]]
#import "Captain_EnterBalance.h"

@implementation Captain_EnterBalance{
    NSArray *playerList;
    NSArray *filterPlayerList;
    UITableView *searchResultsTableView;
}
@synthesize teamFundView, playerListHeader, playerListTableView, balanceTypeSegment, totalPlayers, totalTeamFund, balanceAmount, balanceDate, balanceName;

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
    [playerListTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    searchResultsTableView = self.searchDisplayController.searchResultsTableView;
    [searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [searchResultsTableView setAllowsMultipleSelection:YES];
    
    //Initial Datalist
    playerList = fake_playerList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)balanceTypeSelected:(id)sender
{
    switch (balanceTypeSegment.selectedSegmentIndex) {
        case 0:
            [playerListTableView setHidden:NO];
            [teamFundView setHidden:NO];
            break;
        default:
            [playerListTableView setHidden:YES];
            [teamFundView setHidden:YES];
            break;
    }
}

#pragma TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:playerListTableView]) {
        return playerList.count;
    }
    else {
        return filterPlayerList.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [playerListTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    if ([tableView isEqual:playerListTableView]) {
        [cell.textLabel setText:playerList[indexPath.row][0]];
        [cell.detailTextLabel setText:playerList[indexPath.row][1]];
        if ([playerListTableView.indexPathsForSelectedRows containsObject:indexPath]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    else {
        [cell.textLabel setText:filterPlayerList[indexPath.row][0]];
        [cell.detailTextLabel setText:filterPlayerList[indexPath.row][1]];
        NSIndexPath *indexPathForPlayerList = [NSIndexPath indexPathForRow:[playerList indexOfObject:filterPlayerList[indexPath.row]] inSection:0];
        if ([playerListTableView.indexPathsForSelectedRows containsObject:indexPathForPlayerList]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return playerListHeader.bounds.size.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return playerListHeader;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    if ([tableView isEqual:searchResultsTableView]) {
        NSIndexPath *indexPathForPlayerList = [NSIndexPath indexPathForRow:[playerList indexOfObject:filterPlayerList[indexPath.row]] inSection:0];
        [playerListTableView selectRowAtIndexPath:indexPathForPlayerList animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    [self calculateTotal];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if ([tableView isEqual:searchResultsTableView]) {
        NSIndexPath *indexPathForPlayerList = [NSIndexPath indexPathForRow:[playerList indexOfObject:filterPlayerList[indexPath.row]] inSection:0];
        [playerListTableView deselectRowAtIndexPath:indexPathForPlayerList animated:NO];
    }
    
    [self calculateTotal];
}

#pragma SearchDisplayController Methods
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    NSArray *indexPathsForSelectedRows = playerListTableView.indexPathsForSelectedRows;
    [playerListTableView reloadData];
    for (NSIndexPath *indexPath in indexPathsForSelectedRows) {
        [playerListTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:playerListTableView didSelectRowAtIndexPath:indexPath];
    }
    [self calculateTotal];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self[0] contains[c] %@", searchString];
    filterPlayerList = [playerList filteredArrayUsingPredicate:predicate];
    return YES;
}

-(void)calculateTotal
{
    NSInteger unitAmount = balanceAmount.text.integerValue;
    NSInteger numOfPlayers = playerListTableView.indexPathsForSelectedRows.count;
    [totalPlayers setText:[NSString stringWithFormat:@"%ld 人", numOfPlayers]];
    [totalTeamFund setText:[NSString stringWithFormat:@"%ld 元", numOfPlayers * unitAmount]];
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
