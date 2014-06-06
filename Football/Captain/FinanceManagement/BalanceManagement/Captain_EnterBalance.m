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
    NSDateFormatter *dateFormatter;
    UIDatePicker *balanceDatePicker;
}
@synthesize teamFundView, playerListHeader, playerListTableView, balanceTypeSegment, totalPlayers, totalTeamFund, balanceAmount, balanceDate, balanceName;
@synthesize viewType, balanceDataForEditing;

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
    //Set TableView properties
    [self.view setBackgroundColor:[UIColor clearColor]];
    [playerListTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    searchResultsTableView = self.searchDisplayController.searchResultsTableView;
    [searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [searchResultsTableView setAllowsMultipleSelection:YES];
    
    //Set dateformatter
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_MatchDateformat];
    
    //Initial Datalist
    playerList = fake_playerList;
    
    [self balanceTypeSelected:self];
    [self initialBalanceDate];
    [self initialBalanceName];
    [self initialBalanceAmount];
    
    if (viewType == EnterBalance_Edit) {
        [self fillDataForEditMode];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialBalanceAmount
{
    [balanceAmount initialLeftViewWithLabelName:def_EnterBalance_Title_Amount labelWidth:45 iconImage:@"leftIcon_createMatch_cost.png"];
//    [self initialLeftViewForTextField:balanceAmount labelName:def_EnterBalance_Title_Amount iconImage:@"leftIcon_createMatch_cost.png"];
}

-(void)initialBalanceName
{
    [balanceName initialLeftViewWithLabelName:def_EnterBalance_Title_Name labelWidth:45 iconImage:@"leftIcon_createMatch_place.png"];
//    [self initialLeftViewForTextField:balanceName labelName:def_EnterBalance_Title_Name iconImage:@"leftIcon_createMatch_place.png"];
}

-(void)initialBalanceDate
{
    balanceDatePicker = [[UIDatePicker alloc] init];
    [balanceDatePicker setDatePickerMode:UIDatePickerModeDate];
    [balanceDatePicker setLocale:[NSLocale currentLocale]];
    
    //Set minimumdate and Maximumdate for datepicker
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    [balanceDatePicker setMinimumDate:minDate];
    [balanceDatePicker setMaximumDate:[NSDate date]];
    [balanceDatePicker addTarget:self action:@selector(balanceDateSelected) forControlEvents:UIControlEventValueChanged];
    [balanceDate setInputView:balanceDatePicker];
    [balanceDate setText:[dateFormatter stringFromDate:[NSDate date]]];
    
    [balanceDate initialLeftViewWithLabelName:def_EnterBalance_Title_Date labelWidth:45 iconImage:@"leftIcon_createMatch_time.png"];
//    [self initialLeftViewForTextField:balanceDate labelName:def_EnterBalance_Title_Date iconImage:@"leftIcon_createMatch_time.png"];
}

//-(void)initialLeftViewForTextField:(UITextField *)textFieldNeedLeftView labelName:(NSString *)labelName iconImage:(NSString *)imageFileName
//{
//    CGRect leftViewFrame = textFieldNeedLeftView.bounds;
//    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFileName]];
//    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftIcon.frame.size.width, 0, 45, leftViewFrame.size.height)];
//    leftViewFrame.size.width = leftIcon.frame.size.width + leftLabel.frame.size.width + 10;
//    [leftLabel setText:labelName];
//    [leftLabel setTextAlignment:NSTextAlignmentCenter];
//    UIView *leftView = [[UIView alloc] initWithFrame:leftViewFrame];
//    [leftView addSubview:leftIcon];
//    [leftView addSubview:leftLabel];
//    [textFieldNeedLeftView setLeftView:leftView];
//    [textFieldNeedLeftView setLeftViewMode:UITextFieldViewModeAlways];
//    [textFieldNeedLeftView setPlaceholder:nil];
//}

-(void)fillDataForEditMode
{

}

-(void)balanceDateSelected
{
    //Fill the date to matchTime textfield
    [balanceDate setText:[dateFormatter stringFromDate:balanceDatePicker.date]];
}

-(IBAction)balanceTypeSelected:(id)sender
{
    switch (balanceTypeSegment.selectedSegmentIndex) {
        case 0:
            [playerListTableView setHidden:NO];
            [teamFundView setHidden:NO];
            [balanceName setHidden:NO];
            [balanceName setEnabled:NO];
            [balanceDate setHidden:NO];
            [balanceAmount setHidden:NO];
            
            [balanceAmount setPlaceholder:def_EnterBalance_Placeholder_TeamFund];
            
            [balanceName setText:@"队费收入"];
//            [balanceAmount setText:nil];
            break;
        case 1:
        case 2:
            [playerListTableView setHidden:YES];
            [teamFundView setHidden:YES];
            [balanceName setHidden:NO];
            [balanceName setEnabled:YES];
            [balanceDate setHidden:NO];
            [balanceAmount setHidden:NO];

            [balanceAmount setPlaceholder:def_EnterBalance_Placeholder_Other];
            
            [balanceName setText:nil];
//            [balanceAmount setText:nil];
            break;
        default:
            [playerListTableView setHidden:YES];
            [teamFundView setHidden:YES];
            [balanceName setHidden:YES];
            [balanceDate setHidden:YES];
            [balanceAmount setHidden:YES];
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [balanceName resignFirstResponder];
    [balanceDate resignFirstResponder];
    [balanceAmount resignFirstResponder];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

#pragma TextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:balanceAmount]) {
        if ([textField.text isEqualToString:@""]) {//TextField is blank
            [textField setText:@"0"];
        }
        if (balanceTypeSegment.selectedSegmentIndex == 0) {
            [self calculateTotal];
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:balanceDate]) {
        if (![textField hasText]) {
            [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
        }
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:balanceAmount]) {
        NSCharacterSet *invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *potentialString = [textField.text stringByReplacingCharactersInRange:range withString:string];

        //Number and dot only
        if ([string rangeOfCharacterFromSet:invalidCharacters].length != 0) {
            return NO;
        }
        
        //Maximum 10000
        if (potentialString.integerValue > 10000) {
            return NO;
        }
        
        //Remove the prefix "0" if potential textField would not be "0"
        if ([potentialString hasPrefix:@"0"] && potentialString.length > 1) {
            if ([textField.text isEqualToString:@"0"]) {
                [textField setText:nil];
                return YES;
            }
            else {
                return NO;
            }
        }
    }
    return YES;
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
    CGFloat unitAmount = balanceAmount.text.floatValue;
    NSInteger numOfPlayers = playerListTableView.indexPathsForSelectedRows.count;
    NSNumber *totalAmount = [NSNumber numberWithFloat:numOfPlayers * unitAmount];
    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
    [amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [totalPlayers setText:[NSString stringWithFormat:@"%ld 人", numOfPlayers]];
    [totalTeamFund setText:[NSString stringWithFormat:@"%@ 元", [amountFormatter stringFromNumber:totalAmount]]];
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