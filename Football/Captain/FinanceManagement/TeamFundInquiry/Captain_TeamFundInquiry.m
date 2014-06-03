//
//  Captain_TeamFundInquiry.m
//  Football
//
//  Created by Andy on 14-6-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_TeamFundInquiry.h"

@implementation Captain_TeamFundInquiry_Cell
@synthesize playerScrollView;
@end

@implementation Captain_TeamFundInquiry
@synthesize teamFundTableView;

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
    [teamFundTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Set menu button
    [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TeamFundCell";
    Captain_TeamFundInquiry_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    for (int i = 0 ; i < 10; i++) {
        UIImageView *playerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i * 80, 10, 60, 60)];
        NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"TeamIcon" ofType:@"jpg"];
        [playerIcon setImage:[UIImage imageWithContentsOfFile:imageFile]];
        [playerIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
        [playerIcon.layer setBorderWidth:1.0f];
        [playerIcon.layer setCornerRadius:30];
        [playerIcon.layer setMasksToBounds:YES];
        UILabel *playeName = [[UILabel alloc] initWithFrame:CGRectMake(10 + i * 80, 73, 60, 21)];
        [playeName setText:@"队内名字"];
        [playeName setFont:[UIFont fontWithName:playeName.font.fontName size:13]];
        [playeName setAdjustsFontSizeToFitWidth:YES];
        [playeName setTextAlignment:NSTextAlignmentCenter];
        [cell.playerScrollView addSubview:playerIcon];
        [cell.playerScrollView addSubview:playeName];
    }
    [cell.playerScrollView setContentSize:CGSizeMake(800, 0)];
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [NSString stringWithFormat:@"个人队费金额：%@", [NSNumber numberWithInteger:section].stringValue];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.contentView setBackgroundColor:def_navigationBar_background];
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
