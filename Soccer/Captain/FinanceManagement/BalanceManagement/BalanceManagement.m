//
//  BalanceManagement.m
//  Soccer
//
//  Created by Andy Xu on 14-5-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#import "BalanceManagement.h"

@implementation BalanceManagement_Cell
@synthesize balanceType, balanceName, balanceDate, balanceAmount;
@end

@implementation BalanceManagementTableView {
    JSONConnect *connection;
    NSArray *transactionList;
    NSDateFormatter *dateFormatter;
    NSInteger count;
}
@synthesize delegateOfSelectTransaction;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllowAutoRefreshing:YES];
    
    //Get Transaction List
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[gUIStrings objectForKey:@"DateFormatter_BalanceTransaction"]];
    count = [[gSettings objectForKey:@"balanceManagementCount"] integerValue];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.parentViewController.navigationController];
    [self initialWithLabelTexts:@"BalanceManagement"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceLoadTableView) name:@"BalanceTransactionAdded" object:nil];
}

- (void)receiveTeamBalanceTransactions:(NSArray *)transactions {
    transactionList = [transactionList arrayByAddingObjectsFromArray:transactions];
    if (transactionList.count == 0) {
        [self finishedLoadingWithNewStatus:LoadMoreStatus_NoData];
    }
    else {
        [self finishedLoadingWithNewStatus:(transactions.count == count)?LoadMoreStatus_LoadMore:LoadMoreStatus_NoMoreData];
    }
    [self.tableView reloadData];
}

- (BOOL)startLoadingMore:(BOOL)isReload {
    if (isReload) {
        transactionList = [NSArray new];
    }
    if ([super startLoadingMore:isReload]) {
        [connection requestTeamBalanceTransactions:gMyUserInfo.team.teamId forPlayer:gMyUserInfo.userId startIndex:transactionList.count count:count];
        return YES;
    }
    return NO;
}

#pragma TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return transactionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BalanceManagementCell";
    BalanceManagement_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BalanceTransaction *transactionData = [transactionList objectAtIndex:indexPath.row];
    
    [cell.balanceType setText:transactionData.paymentType?[gUIStrings objectForKey:@"UI_BalanceManagement_Type_Credit"]:[gUIStrings objectForKey:@"UI_BalanceManagement_Type_Debit"]];
    [cell.balanceType setBackgroundColor:transactionData.paymentType?cBalanceTypeCredit:cBalanceTypeDebit];
    [cell.balanceName setText:transactionData.transactionName];
    [cell.balanceDate setText:[dateFormatter stringFromDate:transactionData.transactionDate]];
    [cell.balanceAmount setText:[NSString stringWithFormat:@"%@%@", transactionData.paymentType?@"-":@"+", transactionData.amount]];
    [cell.balanceAmount setTextColor:transactionData.paymentType?cBalanceTypeCredit:cBalanceTypeDebit];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!delegateOfSelectTransaction) {
        delegateOfSelectTransaction = (id)self.parentViewController;
    }
    if (delegateOfSelectTransaction) {
        [delegateOfSelectTransaction showTransaction:[transactionList objectAtIndex:indexPath.row]];
    }
}

@end

@implementation BalanceManagement{
    NSMutableArray *balanceData;
    JSONConnect *connection;
    NSArray *teamPlayers;
    NSDate *teamPlayersLastRefreshDate;
}
@synthesize teamLogo, lbTeamBalance, actionBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setToolbarItems:actionBar.items];
    
    //Initial data
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)viewDidLayoutSubviews {
    //Set the teamLogo
    [teamLogo.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogo.layer setBorderWidth:2.0f];
    [teamLogo.layer setCornerRadius:teamLogo.bounds.size.width/2];
    [teamLogo.layer setMasksToBounds:YES];
    [teamLogo setImage:gMyUserInfo.team.teamLogo?gMyUserInfo.team.teamLogo:def_defaultTeamLogo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!self.toolbarItems.count];
    [connection requestTeamBalance:gMyUserInfo.team.teamId forPlayer:gMyUserInfo.userId];
}

- (void)receiveTeamBalance:(NSNumber *)teamBalance {
    [lbTeamBalance setText:[NSString stringWithFormat:@"%@%@", teamBalance, [gUIStrings objectForKey:@"UI_BalanceTransaction_AmountUnit"]]];
    if (!teamPlayersLastRefreshDate || [[NSDate date] timeIntervalSinceDate:teamPlayersLastRefreshDate] > [[gSettings objectForKey:@"globalTeamPlayersRefreshPeriod"] integerValue]) {
        [connection requestTeamMembers:gMyUserInfo.team.teamId withTeamFundHistory:YES isSync:YES];
    }
}

- (void)receiveTeamMembers:(NSArray *)players {
    teamPlayers = players;
    teamPlayersLastRefreshDate = [NSDate date];
}

- (void)showTransaction:(BalanceTransaction *)transaction {
    [self performSegueWithIdentifier:@"ViewTransaction" sender:transaction];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddTransaction"]) {
        BalanceTransactionDetails *detailsView = segue.destinationViewController;
        [detailsView setViewType:BalanceTransactionDetailsViewType_Add];
        [detailsView setPlayerList:teamPlayers];
    }
    else if ([segue.identifier isEqualToString:@"ViewTransaction"]) {
        BalanceTransactionDetails *detailsView = segue.destinationViewController;
        [detailsView setViewType:BalanceTransactionDetailsViewType_View];
        [detailsView setTransaction:sender];
        [detailsView setPlayerList:teamPlayers];
    }
}

@end
