//
//  Captain_CreateMatch_StadiumList.m
//  Football
//
//  Created by Andy on 14-5-7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch_StadiumList.h"

@implementation Captain_CreateMatch_StadiumList_Cell
@synthesize stadiumName, phoneNumber, phoneIcon;

-(IBAction)callPhone:(id)sender
{
    NSString *callNumber = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callNumber]];
}
@end

@implementation Captain_CreateMatch_StadiumList_Base
@synthesize delegate;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [delegate notSelectStadium:self.childViewControllers.lastObject];
}

@end

@implementation Captain_CreateMatch_StadiumList{
    NSArray *stadiumsList;
    NSArray *filterStadiumsList;
}
@synthesize delegate;

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
    [self setEdgesForExtendedLayout:UIRectEdgeTop];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.searchDisplayController.searchResultsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.searchDisplayController.searchResultsTableView setSeparatorInset:self.tableView.separatorInset];
//    [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f]];
    
    //Get stadiums
    JSONConnect *connnect = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connnect requestAllStadiums];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveStadiums:(NSArray *)stadiums
{
    stadiumsList = stadiums;
    [self.tableView reloadData];
}

#pragma TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return filterStadiumsList.count;
    }
    else {
        return stadiumsList.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"StadiumCell";
    Captain_CreateMatch_StadiumList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
//        cell = [[Captain_CreateMatch_StadiumList_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    //Configure Cell
    Stadium *stadiumData;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        stadiumData = [filterStadiumsList objectAtIndex:indexPath.row];
    }
    else {
        stadiumData = [stadiumsList objectAtIndex:indexPath.row];
    }
    
    [cell.stadiumName setText:stadiumData.stadiumName];

    if (![stadiumData.phoneNumber isEqual:[NSNull null]]) {
        [cell.phoneNumber setText:stadiumData.phoneNumber];
    }
    else {
        [cell.phoneNumber setText:nil];
    }
    [cell.phoneIcon setHidden:[stadiumData.phoneNumber isEqual:[NSNull null]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        [delegate stadiumSelected:[filterStadiumsList objectAtIndex:indexPath.row]];
    }
    else {
        [delegate stadiumSelected:[stadiumsList objectAtIndex:indexPath.row]];
    }
    
    if ([self.searchDisplayController.searchBar isFirstResponder]) {
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
}

#pragma Search Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.stadiumName contains[c] %@", searchString];
    filterStadiumsList = [stadiumsList filteredArrayUsingPredicate:predicate];
    return YES;
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
