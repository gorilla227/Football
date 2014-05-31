//
//  Captain_PlayerMarket.m
//  Football
//
//  Created by Andy Xu on 14-5-29.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#define fake_PlayerMarketData @[@[@"巴神", @"前锋", @"24", [NSNull null]], @[@"内斯塔", @"后卫", @"34", @"AC米兰"], @[@"Pirlo", @"Mid", @"31", @"Juventus"], @[@"Buffon", @"守门员", @"35", @"意大利"], @[@"里皮", @"教练", @"50", @"Guangzhou"], @[@"加利亚尼", @"经理", @"55", [NSNull null]]]
#import "Captain_PlayerMarket.h"

@implementation Captain_PlayerMarket_Cell
@synthesize playerIcon, nickName, playerRole, age, delegate;

-(IBAction)showPlayerDetails:(id)sender
{
    [delegate showPlayerDetails:self.tag];
}
@end

@implementation Captain_PlayerMarket{
    NSArray *playerList;
    NSArray *filterPlayerList;
    NSInteger indexForPlayerDetails;
}
@synthesize playerMarketTableView, recruitButton, temporaryButton;

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
    [playerMarketTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor clearColor]];
    [self.searchDisplayController.searchResultsTableView setRowHeight:playerMarketTableView.rowHeight];
    playerList = fake_PlayerMarketData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableView isEqual:playerMarketTableView]?playerList.count:filterPlayerList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerMarketCell";
    Captain_PlayerMarket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [playerMarketTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    NSArray *dataList = [tableView isEqual:playerMarketTableView]?playerList:filterPlayerList;

    [cell.nickName setText:dataList[indexPath.row][0]];
    [cell.playerRole setText:dataList[indexPath.row][1]];
    [cell.age setText:dataList[indexPath.row][2]];
    [cell setTag:indexPath.row];
    [cell setDelegate:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.indexPathsForSelectedRows.count <= 5) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    [recruitButton setEnabled:YES];
    [temporaryButton setEnabled:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [recruitButton setEnabled:tableView.indexPathsForSelectedRows.count > 0];
    [temporaryButton setEnabled:tableView.indexPathsForSelectedRows.count > 0];
}

-(void)showPlayerDetails:(NSInteger)index
{
    indexForPlayerDetails = index;
    [self performSegueWithIdentifier:@"FreePlayer" sender:self];
}

#pragma Search Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self[0] contains[c] %@", searchString];
    filterPlayerList = [playerList filteredArrayUsingPredicate:predicate];
    return YES;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [playerMarketTableView setHidden:YES];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    [playerMarketTableView setHidden:NO];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FreePlayer"]) {
        Captain_PlayerDetails *playerDetails = segue.destinationViewController;
        [playerDetails setViewType:FreePlayer];
        [playerDetails setHasTeam:![playerList[indexForPlayerDetails][3] isEqual:[NSNull null]]];
    }
    else if ([segue.identifier isEqualToString:@"RecruitPlayer"]) {
        NSMutableArray *selectedPlayerList = [[NSMutableArray alloc] init];
        NSArray *allPlayerList = playerMarketTableView.isHidden?filterPlayerList:playerList;
        NSArray *indexPathsForSelectedRow = playerMarketTableView.isHidden?self.searchDisplayController.searchResultsTableView.indexPathsForSelectedRows:playerMarketTableView.indexPathsForSelectedRows;
        for (NSIndexPath *indexPath in indexPathsForSelectedRow) {
            [selectedPlayerList addObject:allPlayerList[indexPath.row][0]];
        }
        Captain_NotifyPlayers *notifyPlayer = segue.destinationViewController;
        [notifyPlayer setViewType:RecruitPlayer];
        [notifyPlayer setPlayerList:selectedPlayerList];
        [notifyPlayer setPredefinedNotification:@"恭喜！“本队队名”看中你了，主力位置有保证，速来投靠！"];
    }
    else if ([segue.identifier isEqualToString:@"TemporaryFavor"]) {
        NSMutableArray *selectedPlayerList = [[NSMutableArray alloc] init];
        NSArray *allPlayerList = playerMarketTableView.isHidden?filterPlayerList:playerList;
        NSArray *indexPathsForSelectedRow = playerMarketTableView.isHidden?self.searchDisplayController.searchResultsTableView.indexPathsForSelectedRows:playerMarketTableView.indexPathsForSelectedRows;
        for (NSIndexPath *indexPath in indexPathsForSelectedRow) {
            [selectedPlayerList addObject:allPlayerList[indexPath.row][0]];
        }
        Captain_NotifyPlayers *notifyPlayer = segue.destinationViewController;
        [notifyPlayer setViewType:TemporaryFavor];
        [notifyPlayer setPlayerList:selectedPlayerList];
        [notifyPlayer setPredefinedNotification:@"“本队队名”于“比赛时间”，在“比赛地点”，有一场“赛制”比赛，特邀请你参加。请拔腿相助，来了就是主力，来的就是朋友！"];
    }
}
@end