//
//  TeamFundInquiry.m
//  Soccer
//
//  Created by Andy on 15/4/17.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "TeamFundInquiry.h"
#import "MessageCenter_Compose.h"

@implementation TeamFundInquiry_CollectionViewCell
@synthesize ivPlayerPortrait, lbPlayerName;

- (void)drawRect:(CGRect)rect {
    [ivPlayerPortrait.layer setCornerRadius:ivPlayerPortrait.bounds.size.width/2];
    [ivPlayerPortrait.layer setMasksToBounds:YES];
}

@end

@implementation TeamFundInquiry_TableViewCell
@synthesize playerCollectionView;
@end

@implementation TeamFundInquiry {
    NSArray *allTeamPlayerList;
    NSMutableArray *unpaidPlayerList;
    NSMutableDictionary *teamFundsWithAmount;
    NSArray *amountList;
    UIDatePicker *dpStartDate;
    UIDatePicker *dpEndDate;
    NSDateFormatter *dateFormatter;
    JSONConnect *connection;
}
@synthesize tfStartDate, tfEndDate, btnSearch, scPlayerList, tbNotice, btnNotice, lbNoRecord;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)bgImage];
//    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [btnSearch.layer setCornerRadius:5.0f];
    [btnSearch.layer setMasksToBounds:YES];
    [self setToolbarItems:tbNotice.items];
    
    //Initial JSONConnection
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestTeamMembers:gMyUserInfo.team.teamId withTeamFundHistory:NO isSync:YES];
    
    //Initial DatePicker
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[gUIStrings objectForKey:@"DateFormatter_BalanceTransaction"]];
    
    dpStartDate = [[UIDatePicker alloc] init];
    [dpStartDate setDatePickerMode:UIDatePickerModeDate];
    [dpStartDate setMaximumDate:[NSDate date]];
    [dpStartDate addTarget:self action:@selector(datePickerDidSelected:) forControlEvents:UIControlEventValueChanged];
    [tfStartDate setInputView:dpStartDate];
    [tfStartDate initialLeftViewWithLabelName:[gUIStrings objectForKey:@"UI_TeamFundInquiry_StartDateTitle"] labelWidth:90 iconImage:@"leftIcon_createMatch_time.png"];
    
    dpEndDate = [[UIDatePicker alloc] init];
    [dpEndDate setDatePickerMode:UIDatePickerModeDate];
    [dpEndDate setMaximumDate:[NSDate date]];
    [dpEndDate addTarget:self action:@selector(datePickerDidSelected:) forControlEvents:UIControlEventValueChanged];
    [tfEndDate setInputView:dpEndDate];
    [tfEndDate initialLeftViewWithLabelName:[gUIStrings objectForKey:@"UI_TeamFundInquiry_EndDateTitle"] labelWidth:90 iconImage:@"leftIcon_createMatch_time.png"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!scPlayerList.selectedSegmentIndex];
}

- (void)datePickerDidSelected:(id)sender {
    if ([sender isEqual:dpStartDate]) {
        [tfStartDate setText:[dateFormatter stringFromDate:dpStartDate.date]];
        [dpEndDate setMinimumDate:dpStartDate.date];
    }
    else if ([sender isEqual:dpEndDate]) {
        [tfEndDate setText:[dateFormatter stringFromDate:dpEndDate.date]];
        [dpStartDate setMaximumDate:dpEndDate.date];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [tfStartDate resignFirstResponder];
    [tfEndDate resignFirstResponder];
}

- (IBAction)btnSearch_OnClicked:(id)sender {
    if (!tfStartDate.text.length) {
        [tfStartDate setText:[dateFormatter stringFromDate:dpStartDate.date]];
    }
    if (!tfEndDate.text.length) {
        [tfEndDate setText:[dateFormatter stringFromDate:dpEndDate.date]];
    }
    [connection requestTeamFunds:gMyUserInfo.team.teamId forCaptain:gMyUserInfo.userId startDate:dpStartDate.date endDate:dpEndDate.date];
}

- (IBAction)scPlayerListValueChanged:(id)sender {
    [self reloadToolBarAndTableFooterView];
    [self.tableView reloadData];
}

- (IBAction)btnNotice_OnClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil];
    MessageCenter_Compose *composeViewController = [storyboard instantiateViewControllerWithIdentifier:@"MessageCompose"];
    [composeViewController setComposeType:MessageComposeType_TeamFundNotice];
    [composeViewController setToList:unpaidPlayerList];
    [self.navigationController pushViewController:composeViewController animated:YES];
}

#pragma JSON Connection
- (void)receiveTeamMembers:(NSArray *)players {
    allTeamPlayerList = players;
}

- (void)receiveTeamFunds:(NSArray *)teamFunds {
    unpaidPlayerList = [NSMutableArray arrayWithArray:allTeamPlayerList];
    NSMutableArray *teamFundsWithPlayer = [NSMutableArray new];
    for (TeamFund *teamFund in teamFunds) {
        BOOL isPlayerExisted = NO;
        for (TeamFundStatistics *teamFundStat in teamFundsWithPlayer) {
            if (teamFundStat.player.userId == teamFund.playerId) {
                teamFundStat.amount = [NSNumber numberWithInteger:teamFundStat.amount.integerValue + teamFund.amount.integerValue];
                isPlayerExisted = YES;
                break;
            }
        }
        if (!isPlayerExisted) {
            for (UserInfo *player in unpaidPlayerList) {
                if (player.userId == teamFund.playerId) {
                    TeamFundStatistics *newTeamFundStat = [[TeamFundStatistics alloc] init];
                    [newTeamFundStat setPlayer:player];
                    [newTeamFundStat setAmount:teamFund.amount];
                    [teamFundsWithPlayer addObject:newTeamFundStat];
                    [unpaidPlayerList removeObject:player];
                    break;
                }
            }
        }
    }
    
    teamFundsWithAmount = [NSMutableDictionary new];
    for (TeamFundStatistics *teamFundStat in teamFundsWithPlayer) {
        BOOL isTeamFundExisted = NO;
        NSArray *allKeys = teamFundsWithAmount.allKeys;
        for (NSNumber *amountKey in allKeys) {
            if ([amountKey isEqualToNumber:teamFundStat.amount]) {
                NSMutableArray *playersWithAmount = [teamFundsWithAmount objectForKey:amountKey];
                [playersWithAmount addObject:teamFundStat.player];
                isTeamFundExisted = YES;
                break;
            }
        }
        
        if (!isTeamFundExisted) {
            [teamFundsWithAmount setObject:[NSMutableArray arrayWithObject:teamFundStat.player] forKey:teamFundStat.amount];
        }
    }
    
    amountList = [teamFundsWithAmount.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSNumber *amount1, NSNumber *amount2) {
        return [amount1 compare:amount2];
    }];
    [tfStartDate resignFirstResponder];
    [tfEndDate resignFirstResponder];
    
    [scPlayerList setSelectedSegmentIndex:teamFundsWithAmount.count?0:1];
    [scPlayerList setEnabled:teamFundsWithAmount.count forSegmentAtIndex:0];
    [scPlayerList setEnabled:unpaidPlayerList.count forSegmentAtIndex:1];
    [self reloadToolBarAndTableFooterView];
    [self.tableView reloadData];
}

- (void)reloadToolBarAndTableFooterView {
    switch (scPlayerList.selectedSegmentIndex) {
        case 0:
            [self.tableView setTableFooterView:teamFundsWithAmount.count?[[UIView alloc] initWithFrame:CGRectZero]:lbNoRecord];
            [self.navigationController setToolbarHidden:YES animated:YES];
            break;
        case 1:
            [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
            [self.navigationController setToolbarHidden:NO animated:YES];
            break;
        default:
            break;
    }
}

#pragma TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (scPlayerList.selectedSegmentIndex) {
        case 0:
            return teamFundsWithAmount.count;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableViewCell";
    TeamFundInquiry_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.playerCollectionView setTag:indexPath.section];
    [cell.playerCollectionView reloadData];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (scPlayerList.selectedSegmentIndex) {
        case 0:
            return [NSString stringWithFormat:@"%@%@", [gUIStrings objectForKey:@"UI_TeamFundInquiry_PaidSectionTitle"], [amountList objectAtIndex:section]];
        default:
            return nil;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (scPlayerList.selectedSegmentIndex) {
        case 0:
            return [[teamFundsWithAmount objectForKey:[amountList objectAtIndex:collectionView.tag]] count];
        case 1:
            return unpaidPlayerList.count;
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CollectionViewCell";
    TeamFundInquiry_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UserInfo *playerData;
    switch (scPlayerList.selectedSegmentIndex) {
        case 0:
            playerData = [[teamFundsWithAmount objectForKey:[amountList objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
            break;
        case 1:
            playerData = [unpaidPlayerList objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    [cell.lbPlayerName setText:playerData.nickName];
    return cell;
}
@end