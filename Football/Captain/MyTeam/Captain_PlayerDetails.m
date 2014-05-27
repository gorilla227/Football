//
//  Captain_PlayerDetails.m
//  Football
//
//  Created by Andy Xu on 14-5-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#define fake_PlayerDetails @[@[@"1986.2.18", @"北京", @"五道口", @"左脚 前锋 速度快"], @[@"2013.2.18", @"20", @"18", @"13", @"0"]]

#import "Captain_PlayerDetails.h"

@implementation Captain_PlayerDetails
@synthesize playerDetailsTableView;

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
    [playerDetailsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [playerDetailsTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [def_PlayerDetails[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.textLabel setText:def_PlayerDetails[indexPath.section][indexPath.row]];
    [cell.detailTextLabel setText:fake_PlayerDetails[indexPath.section][indexPath.row]];
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
