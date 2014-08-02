//
//  Captain_TeamFundInquiry.m
//  Football
//
//  Created by Andy on 14-6-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#define fake_PaidData @[[NSDictionary dictionaryWithObjectsAndKeys:@"100", @"FundAmount", @[@"Ana", @"Bob", @"Cindy", @"Dean", @"Emily"], @"PlayerList", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"200", @"FundAmount", @[@"Francis", @"Glen"], @"PlayerList", nil]]
#define fake_UnpaidData @[@"Harry", @"Illinois", @"Jack", @"Kelly", @"Lily"]

#import "Captain_TeamFundInquiry.h"

@implementation Captain_TeamFundInquiry_CollectionCell
@synthesize playerPortrait, playerName;
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [playerPortrait.layer setCornerRadius:playerPortrait.bounds.size.width / 2];
    [playerPortrait.layer setMasksToBounds:YES];
}
@end

@implementation Captain_TeamFundInquiry_TableCell
@synthesize playerCollectionView;
@end

@implementation Captain_TeamFundInquiry{
    NSArray *teamFundData_Paid;
    NSArray *teamFundData_Unpaid;
    NSDateFormatter *dateFormatter;
    UIDatePicker *startDatePicker;
    UIDatePicker *endDatePicker;
    NSString *selectedPlayer;
}
@synthesize playListType, startDateTextField, endDateTextField, paidPlayerTableView, unpaidPlayerCollectionView, notifyUnpaidPlayers;

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
    [paidPlayerTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Set dateformatter
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_MatchDateformat];
    
    //Initial TextFields
    [self initialStartDate];
    [self initialEndDate];
    [startDatePicker setMaximumDate:endDatePicker.date];
    [endDatePicker setMinimumDate:startDatePicker.date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changePlayerListType:(id)sender
{
    switch (playListType.selectedSegmentIndex) {
        case 0:
            [notifyUnpaidPlayers setEnabled:NO];
            [paidPlayerTableView setHidden:NO];
            [unpaidPlayerCollectionView setHidden:YES];
            [paidPlayerTableView reloadData];
            break;
        case 1:
            [notifyUnpaidPlayers setEnabled:teamFundData_Unpaid && teamFundData_Unpaid.count > 0];
            [paidPlayerTableView setHidden:YES];
            [unpaidPlayerCollectionView setHidden:!teamFundData_Unpaid];
            [unpaidPlayerCollectionView reloadData];
            break;
        default:
            break;
    }
}

-(IBAction)searchButtonOnClicked:(id)sender
{
    //Initial Data
    teamFundData_Paid = fake_PaidData;
    teamFundData_Unpaid = fake_UnpaidData;
    
    //Adjust the height of unpaidPlayerCollectionView
    CGRect collectionFrame = unpaidPlayerCollectionView.frame;
    collectionFrame.size.height = fmin(ceilf((CGFloat)teamFundData_Unpaid.count / 4) * 100, collectionFrame.size.height);
    [unpaidPlayerCollectionView setFrame:collectionFrame];
    
    switch (playListType.selectedSegmentIndex) {
        case 0:
            [notifyUnpaidPlayers setEnabled:NO];
            [paidPlayerTableView reloadData];
            break;
        case 1:
            [notifyUnpaidPlayers setEnabled:teamFundData_Unpaid && teamFundData_Unpaid.count > 0];
            [unpaidPlayerCollectionView setHidden:!teamFundData_Unpaid];
            [unpaidPlayerCollectionView reloadData];
            break;
        default:
            break;
    }
}

-(void)initialStartDate
{
    startDatePicker = [[UIDatePicker alloc] init];
    [startDatePicker setDatePickerMode:UIDatePickerModeDate];
    [startDatePicker setLocale:[NSLocale currentLocale]];
    
    //Set minimumdate and Maximumdate for datepicker
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *minDateComps = [[NSDateComponents alloc] init];
    [minDateComps setYear:-1];
    NSDate *minDate = [calendar dateByAddingComponents:minDateComps toDate:[NSDate date] options:0];
    NSDateComponents *defaultDateComps = [[NSDateComponents alloc] init];
    [defaultDateComps setMonth:-1];
    NSDate *defaultDate = [calendar dateByAddingComponents:defaultDateComps toDate:[NSDate date] options:0];
    [startDatePicker setMinimumDate:minDate];
    [startDatePicker setMaximumDate:[NSDate date]];
    [startDatePicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    [startDatePicker setDate:defaultDate];
    [startDateTextField setText:[dateFormatter stringFromDate:defaultDate]];
    [startDateTextField setInputView:startDatePicker];
    
    [startDateTextField initialLeftViewWithLabelName:def_TeamFundInquiry_Title_StartDate labelWidth:70 iconImage:@"leftIcon_createMatch_time.png"];
}

-(void)initialEndDate
{
    endDatePicker = [[UIDatePicker alloc] init];
    [endDatePicker setDatePickerMode:UIDatePickerModeDate];
    [endDatePicker setLocale:[NSLocale currentLocale]];
    
    //Set minimumdate and Maximumdate for datepicker
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *minDateComps = [[NSDateComponents alloc] init];
    [minDateComps setYear:-1];
    NSDate *minDate = [calendar dateByAddingComponents:minDateComps toDate:[NSDate date] options:0];
    [endDatePicker setMinimumDate:minDate];
    [endDatePicker setMaximumDate:[NSDate date]];
    [endDatePicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    [endDatePicker setDate:[NSDate date]];
    [endDateTextField setInputView:endDatePicker];
    [endDateTextField setText:[dateFormatter stringFromDate:[NSDate date]]];

    [endDateTextField initialLeftViewWithLabelName:def_TeamFundInquiry_Title_EndDate labelWidth:70 iconImage:@"leftIcon_createMatch_time.png"];
}

-(IBAction)dateSelected:(id)sender
{
    if ([sender isEqual:startDatePicker]) {
        [startDateTextField setText:[dateFormatter stringFromDate:startDatePicker.date]];
        [endDatePicker setMinimumDate:startDatePicker.date];
    }
    else if([sender isEqual:endDatePicker]) {
        [endDateTextField setText:[dateFormatter stringFromDate:endDatePicker.date]];
        [startDatePicker setMaximumDate:endDatePicker.date];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [startDateTextField resignFirstResponder];
    [endDateTextField resignFirstResponder];
}

#pragma TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return teamFundData_Paid.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TeamFundCell";
    Captain_TeamFundInquiry_TableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.playerCollectionView setTag:indexPath.section];
    [cell.playerCollectionView reloadData];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"个人队费金额：%@",[teamFundData_Paid[section] objectForKey:@"FundAmount"]];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.contentView setBackgroundColor:def_navigationBar_background];
}

#pragma CollectionView Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (playListType.selectedSegmentIndex) {
        case 0:
            return [[teamFundData_Paid[collectionView.tag] objectForKey:@"PlayerList"] count];
        case 1:
            return teamFundData_Unpaid.count;
        default:
            return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier_Paid = @"PaidPlayerCollectionCell";
    static NSString *CellIdentifier_Unpaid = @"UnpaidPlayerCollectionCell";
    Captain_TeamFundInquiry_CollectionCell *cell;

    switch (playListType.selectedSegmentIndex) {
        case 0:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier_Paid forIndexPath:indexPath];
            [cell.playerName setText:[teamFundData_Paid[collectionView.tag] objectForKey:@"PlayerList"][indexPath.row]];
            break;
        case 1:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier_Unpaid forIndexPath:indexPath];
            [cell.playerName setText:[teamFundData_Unpaid objectAtIndex:indexPath.row]];
             break;
        default:
            break;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (playListType.selectedSegmentIndex) {
        case 0:
            selectedPlayer = [teamFundData_Paid[collectionView.tag] objectForKey:@"PlayerList"][indexPath.row];
            break;
        case 1:
            selectedPlayer = teamFundData_Unpaid[indexPath.row];
        default:
            break;
    }
    [self performSegueWithIdentifier:@"ViewPlayerDetails" sender:self];
    NSLog(@"%@", selectedPlayer);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"NotifyUnpaidPlayers"]) {
        Captain_NotifyPlayers *notifyPlayers = segue.destinationViewController;
        [notifyPlayers setPredefinedNotification:teamFundData_Paid.count == 0?def_Message_UnpaidWithoutAmount:def_Message_Unpaid([teamFundData_Paid.lastObject objectForKey:@"FundAmount"])];
        [notifyPlayers setViewType:NotifyPlayers_UnpaidPlayers];
        [notifyPlayers setPlayerList:teamFundData_Unpaid];
    }
    else if ([segue.identifier isEqualToString:@"ViewPlayerDetails"]) {
        Captain_PlayerDetails *playerDetails = segue.destinationViewController;
        [playerDetails setViewType:PlayerDetails_MyPlayer];
#warning Send "selectedPlayer" to playerDetails
    }
}

@end