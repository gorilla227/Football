//
//  BalanceTransactionDetails.m
//  Soccer
//
//  Created by Andy on 15/4/9.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "BalanceTransactionDetails.h"

#pragma StatCell
@interface BalanceTransactionDetails_StatCell ()
@property IBOutlet UILabel *lbNumberOfPlayers;
@property IBOutlet UILabel *lbSumAmount;
@end

@implementation BalanceTransactionDetails_StatCell
@synthesize lbNumberOfPlayers, lbSumAmount;
@end

#pragma TableViewController
@interface BalanceTransactionDetails ()
@property IBOutlet UISegmentedControl *scTransactionType;
@property IBOutlet UITextField *tfTransactionName;
@property IBOutlet UITextField *tfTransactionDate;
@property IBOutlet UITextField *tfTransactionAmount;
@property IBOutlet UITapGestureRecognizer *tgrDismissKeyboard;
@property IBOutlet UIToolbar *tbActionBar;
@property IBOutlet UIBarButtonItem *btnSubmit;
@end

@implementation BalanceTransactionDetails {
    UIDatePicker *dpTransactionDate;
    NSDateFormatter *dateFormatter;
    NSArray *playerList;
    NSMutableArray *paidPlayerList;
    JSONConnect *connection;
}
@synthesize viewType, transaction;
@synthesize scTransactionType, tfTransactionName, tfTransactionDate, tfTransactionAmount, tgrDismissKeyboard, tbActionBar, btnSubmit;

- (void)viewDidLoad {
    [super viewDidLoad];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    dpTransactionDate = [[UIDatePicker alloc] init];
    [dpTransactionDate setDate:[NSDate date]];
    [dpTransactionDate setDatePickerMode:UIDatePickerModeDate];
    [dpTransactionDate addTarget:self action:@selector(dpTransactionDateValueChanged) forControlEvents:UIControlEventValueChanged];
    [tfTransactionDate setInputView:dpTransactionDate];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[gUIStrings objectForKey:@"DateFormatter_BalanceTransaction"]];
    
    //Initial TextField
    CGRect rightViewRect = CGRectMake(0, 0, tfTransactionAmount.bounds.size.height, tfTransactionAmount.bounds.size.height);
    [tfTransactionName initialLeftViewWithLabelName:def_EnterBalance_Title_Name labelWidth:45 iconImage:@"leftIcon_createMatch_place.png"];
    UILabel *rightViewForName = [[UILabel alloc] initWithFrame:rightViewRect];
    [tfTransactionName setRightView:rightViewForName];
    [tfTransactionName setRightViewMode:UITextFieldViewModeAlways];
    [tfTransactionDate initialLeftViewWithLabelName:def_EnterBalance_Title_Date labelWidth:45 iconImage:@"leftIcon_createMatch_time.png"];
    UILabel *rightViewForDate = [[UILabel alloc] initWithFrame:rightViewRect];
    [tfTransactionDate setRightView:rightViewForDate];
    [tfTransactionDate setRightViewMode:UITextFieldViewModeAlways];
    [tfTransactionAmount initialLeftViewWithLabelName:def_EnterBalance_Title_Amount labelWidth:45 iconImage:@"leftIcon_createMatch_cost.png"];
    UILabel *rightViewForAmount = [[UILabel alloc] initWithFrame:rightViewRect];
    [rightViewForAmount setText:[gUIStrings objectForKey:@"UI_BalanceTransaction_AmountUnit"]];
    [rightViewForAmount setTextAlignment:NSTextAlignmentCenter];
    [tfTransactionAmount setRightView:rightViewForAmount];
    [tfTransactionAmount setRightViewMode:UITextFieldViewModeAlways];
    
    switch (viewType) {
        case BalanceTransactionDetailsViewType_Add:
            [self setToolbarItems:tbActionBar.items];
            [self setTitle:[gUIStrings objectForKey:@"UI_BalanceTransaction_Title_Add"]];
            break;
        case BalanceTransactionDetailsViewType_View:
            [self setTitle:[gUIStrings objectForKey:@"UI_BalanceTransaction_Title_View"]];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!self.toolbarItems.count];
    if (viewType == BalanceTransactionDetailsViewType_Add || ![transaction.paymentPlayers.firstObject isEqualToString:@"0"]) {
        [connection requestTeamMembers:gMyUserInfo.team.teamId withTeamFundHistory:YES isSync:YES];
    }
    else {
        [self prepareTransactionData];
    }
}

- (void)receiveTeamMembers:(NSArray *)players {
    playerList = players;
    [self prepareTransactionData];
}

- (void)prepareTransactionData {
    //Initial Data
    switch (viewType) {
        case BalanceTransactionDetailsViewType_Add:
            [dpTransactionDate setDate:[NSDate date]];
            [dpTransactionDate setMaximumDate:[NSDate date]];
            [tfTransactionName setEnabled:scTransactionType.selectedSegmentIndex];
            [tfTransactionName setText:scTransactionType.selectedSegmentIndex?nil:[gUIStrings objectForKey:@"UI_BalanceTransaction_Type_TeamFund"]];
            [tfTransactionAmount setTextColor:cBalanceTypeDebit];
            break;
        case BalanceTransactionDetailsViewType_View:
            [scTransactionType setUserInteractionEnabled:NO];
            [tfTransactionName setEnabled:NO];
            [tfTransactionDate setEnabled:NO];
            [tfTransactionAmount setEnabled:NO];
            [self.tableView setAllowsMultipleSelection:NO];
            [self.tableView setAllowsSelection:NO];
            
            if (transaction.paymentType) {
                [scTransactionType setSelectedSegmentIndex:2];
            }
            else {
                if ([transaction.paymentPlayers.firstObject isEqualToString:@"0"]) {
                    [scTransactionType setSelectedSegmentIndex:1];
                }
                else {
                    [scTransactionType setSelectedSegmentIndex:0];
                }
            }
            
            [tfTransactionName setText:transaction.transactionName];
            [tfTransactionDate setText:[dateFormatter stringFromDate:transaction.transactionDate]];
            [tfTransactionAmount setText:[NSString stringWithFormat:@"%lu", transaction.amount.integerValue / transaction.paymentPlayers.count]];
            [tfTransactionAmount setTextColor:transaction.paymentType?cBalanceTypeCredit:cBalanceTypeDebit];
            
            paidPlayerList = [NSMutableArray new];
            for (UserInfo *player in playerList) {
                for (NSString *paidPlayerId in transaction.paymentPlayers) {
                    if (paidPlayerId.integerValue == player.userId) {
                        [paidPlayerList addObject:player];
                        break;
                    }
                }
            }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)transactionAdded:(BOOL)result {
    if (result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[gUIStrings objectForKey:@"UI_BalanceTransaction_AlertView_Added_Title"] message:[gUIStrings objectForKey:@"UI_BalanceTransaction_AlertView_Added_Message"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
        [alertView show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BalanceTransactionAdded" object:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [tfTransactionName resignFirstResponder];
    [tfTransactionDate resignFirstResponder];
    [tfTransactionAmount resignFirstResponder];
    [tgrDismissKeyboard setEnabled:NO];
}

- (IBAction)activeTextField:(id)sender {
    [tgrDismissKeyboard setEnabled:YES];
}

- (IBAction)scTransactionTypeValueChanged:(id)sender {
    [self.tableView reloadData];
    [tfTransactionName setEnabled:scTransactionType.selectedSegmentIndex];
    [tfTransactionName setText:scTransactionType.selectedSegmentIndex?nil:[gUIStrings objectForKey:@"UI_BalanceTransaction_Type_TeamFund"]];
    switch (scTransactionType.selectedSegmentIndex) {
        case 0:
        case 1:
            [tfTransactionAmount setTextColor:cBalanceTypeDebit];
            break;
        case 2:
            [tfTransactionAmount setTextColor:cBalanceTypeCredit];
            break;
        default:
            break;
    }
    [self checkSubmitable];
}

- (IBAction)btnSubmit_OnClicked:(id)sender {
    NSMutableDictionary *newTransactionData = [NSMutableDictionary new];
    [newTransactionData setObject:[NSNumber numberWithInteger:gMyUserInfo.team.teamId] forKey:kBalance_teamId];
    [newTransactionData setObject:[NSNumber numberWithInteger:gMyUserInfo.userId] forKey:kBalance_captainId];
    [newTransactionData setObject:tfTransactionName.text forKey:kBalance_transactionName];
    [newTransactionData setObject:[NSNumber numberWithInteger:[dpTransactionDate.date timeIntervalSince1970]] forKey:kBalance_transactionDate];
    [newTransactionData setObject:tfTransactionAmount.text forKey:kBalance_amount];
    if (scTransactionType.selectedSegmentIndex == 0) {
        [newTransactionData setObject:@0 forKey:kBalance_paymentType];
        NSMutableArray *selectedPlayerIdArray = [NSMutableArray new];
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            if (indexPath.section == 1) {
                UserInfo *player = [playerList objectAtIndex:indexPath.row];
                [selectedPlayerIdArray addObject:[NSNumber numberWithInteger:player.userId]];
            }
        }
        [newTransactionData setObject:[selectedPlayerIdArray componentsJoinedByString:@","] forKey:kBalance_paymentPlayers];
    }
    else if (scTransactionType.selectedSegmentIndex == 1) {
        [newTransactionData setObject:@0 forKey:kBalance_paymentType];
        [newTransactionData setObject:@0 forKey:kBalance_paymentPlayers];
    }
    else {
        [newTransactionData setObject:@1 forKey:kBalance_paymentType];
        [newTransactionData setObject:@0 forKey:kBalance_paymentPlayers];
    }
    
    [connection addTransaction:newTransactionData];
}

- (void)dpTransactionDateValueChanged {
    [tfTransactionDate setText:[dateFormatter stringFromDate:dpTransactionDate.date]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:tfTransactionAmount]) {
        NSString *potentialString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //Maximum 10000
        if (potentialString.integerValue > 10000) {
            return NO;
        }
        
        //Remove the prefix "0" if potential textField would not be "0"
        if ([potentialString hasPrefix:@"0"] && potentialString.length > 1) {
            if ([textField.text isEqualToString:@"0"]) {
                [textField setText:string];
            }
            return NO;
        }
        return ![string isEqual:@"."];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:tfTransactionAmount] && scTransactionType.selectedSegmentIndex == 0) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self checkSubmitable];
}

- (void)checkSubmitable {
    if (scTransactionType.selectedSegmentIndex) {
        [btnSubmit setEnabled:[tfTransactionName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length && tfTransactionDate.text.length && tfTransactionAmount.text.integerValue];
    }
    else {
        NSInteger numOfSelectedPlayers = self.tableView.indexPathsForSelectedRows.count;
        for (NSIndexPath *selectedIndexPath in self.tableView.indexPathsForSelectedRows) {
            if (selectedIndexPath.section == 0) {
                numOfSelectedPlayers--;
            }
        }
        [btnSubmit setEnabled:[tfTransactionName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length && tfTransactionDate.text.length && tfTransactionAmount.text.integerValue && numOfSelectedPlayers];
    }
}

#pragma TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return scTransactionType.selectedSegmentIndex?0:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            switch (viewType) {
                case BalanceTransactionDetailsViewType_Add:
                    return playerList.count;
                case BalanceTransactionDetailsViewType_View:
                    return paidPlayerList.count;
                default:
                    return 0;
            }
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"StatCell";
        BalanceTransactionDetails_StatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (viewType == BalanceTransactionDetailsViewType_Add) {
            NSInteger numOfSelectedPlayers = self.tableView.indexPathsForSelectedRows.count;
            for (NSIndexPath *selectedIndexPath in self.tableView.indexPathsForSelectedRows) {
                if (selectedIndexPath.section == 0) {
                    numOfSelectedPlayers--;
                }
            }
            [cell.lbNumberOfPlayers setText:[NSString stringWithFormat:@"%lu人", numOfSelectedPlayers]];
            [cell.lbSumAmount setText:[NSString stringWithFormat:@"%lu元", numOfSelectedPlayers * tfTransactionAmount.text.integerValue]];
        }
        else if (viewType == BalanceTransactionDetailsViewType_View ) {
            [cell.lbNumberOfPlayers setText:[NSString stringWithFormat:@"%lu%@", transaction.paymentPlayers.count, [gUIStrings objectForKey:@"UI_BalanceTransaction_PlayerUnit"]]];
            [cell.lbSumAmount setText:[NSString stringWithFormat:@"%lu%@", transaction.amount.integerValue, [gUIStrings objectForKey:@"UI_BalanceTransaction_AmountUnit"]]];
        }
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"PlayerListCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        if (viewType == BalanceTransactionDetailsViewType_Add) {
            UserInfo *player = [playerList objectAtIndex:indexPath.row];
            [cell.textLabel setText:player.nickName];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%@", [gUIStrings objectForKey:@"UI_BalanceTransaction_HistoryTitle"], [player.teamFundHistory isEqual:[NSNull null]]?@"0":player.teamFundHistory]];
            [cell setAccessoryType:[self.tableView.indexPathsForSelectedRows containsObject:indexPath]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone];
        }
        else if (viewType == BalanceTransactionDetailsViewType_View) {
            UserInfo *player = [paidPlayerList objectAtIndex:indexPath.row];
            [cell.textLabel setText:player.nickName];
            [cell.detailTextLabel setText:nil];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 65.0f;
        default:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        switch (viewType) {
            case BalanceTransactionDetailsViewType_Add:
                return [gUIStrings objectForKey:@"UI_BalanceTransaction_PlayerListTitle_Add"];
            case BalanceTransactionDetailsViewType_View:
                return [gUIStrings objectForKey:@"UI_BalanceTransaction_PlayerListTitle_View"];
            default:
                return nil;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setTextColor:[UIColor whiteColor]];
    [headerView.textLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self checkSubmitable];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self checkSubmitable];
    }
}
@end