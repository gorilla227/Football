//
//  Captain_CreateMatch_StadiumList.m
//  Football
//
//  Created by Andy on 14-5-7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch_StadiumList.h"

@interface Captain_CreateMatch_StadiumList ()

@end

@implementation Captain_CreateMatch_StadiumList{
    NSArray *stadiumsList;
}
@synthesize stadiumTable;

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
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f]];
    
    //Get stadiums
    JSONConnect *connnect = [[JSONConnect alloc] initWithDelegate:self];
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
    [stadiumTable reloadData];
}

#pragma TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return stadiumsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"StadiumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    //Configure Cell
    Stadium *stadiumData = [stadiumsList objectAtIndex:indexPath.row];
    if (![stadiumData.stadiumName isEqual:[NSNull null]]) {
        [cell.textLabel setText:stadiumData.stadiumName];
    }
    else {
        [cell.textLabel setText:@"No Name"];
    }
    if (![stadiumData.phoneNumber isEqual:[NSNull null]]) {
        [cell.detailTextLabel setText:stadiumData.phoneNumber];
    }
    else {
        [cell.detailTextLabel setText:nil];
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
