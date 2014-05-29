//
//  Captain_PlayerMarket.m
//  Football
//
//  Created by Andy Xu on 14-5-29.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#define fake_PlayerMarketData @[@[@"巴神", @"前锋", @"24", [NSNull null]], @[@"内斯塔", @"后卫", @"34", @"AC米兰"]]
#import "Captain_PlayerMarket.h"

@implementation Captain_PlayerMarket_Cell
@synthesize playerIcon, nickName, playerRole, age, teamName;
@end

@implementation Captain_PlayerMarket{
    NSArray *playerList;
}
@synthesize playerMarketTableView;

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
    return playerList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerMarketCell";
    Captain_PlayerMarket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [playerMarketTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    [cell.nickName setText:playerList[indexPath.row][0]];
    [cell.playerRole setText:playerList[indexPath.row][1]];
    [cell.age setText:playerList[indexPath.row][2]];
    [cell.teamName setText:[playerList[indexPath.row][3] isEqual:[NSNull null]]?@"无":playerList[indexPath.row][3]];
    return cell;
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
        [playerDetails setHasTeam:![playerList[[playerMarketTableView indexPathForSelectedRow].row][3] isEqual:[NSNull null]]];
    }
}
@end