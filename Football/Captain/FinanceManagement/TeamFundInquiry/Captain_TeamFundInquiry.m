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
@synthesize playerIcon, playerName;
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [playerIcon.layer setCornerRadius:playerIcon.bounds.size.width / 2];
    [playerIcon.layer setMasksToBounds:YES];
}
@end

@implementation Captain_TeamFundInquiry_TableCell
@synthesize playerCollectionView;
@end

@implementation Captain_TeamFundInquiry{
    NSArray *teamFundData_Paid;
    NSArray *teamFundData_Unpaid;
}
@synthesize playListType, paidPlayerTableView, unpaidPlayerCollectionView;

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
    
    //Set menu button
    [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
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
            [paidPlayerTableView setHidden:NO];
            [unpaidPlayerCollectionView setHidden:YES];
            [paidPlayerTableView reloadData];
            break;
        case 1:
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
            [paidPlayerTableView reloadData];
            break;
        case 1:
            [unpaidPlayerCollectionView setHidden:!teamFundData_Unpaid];
            [unpaidPlayerCollectionView reloadData];
            break;
        default:
            break;
    }
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
