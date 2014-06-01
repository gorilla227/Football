//
//  Captain_BalanceManagement.m
//  Football
//
//  Created by Andy Xu on 14-5-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#define fake_blanceData @[@[@"支出", @"场地费", @"2014.3.26", @"500"], @[@"收入", @"队费", @"2014.5.20", @"1000"]]
#import "Captain_BalanceManagement.h"

@implementation Captain_BalanceManagement_Cell
@synthesize balanceType, balanceName, balanceDate, balanceAmount;

-(void)drawRect:(CGRect)rect
{
//    UIColor *lineColor = [UIColor grayColor];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextFillRect(context, self.bounds);
//    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
//    CGContextSetLineWidth(context, 0.25f);
//
//    for (UILabel *label in self.contentView.subviews) {
//        if (label.tag != 0) {
//            CGFloat positionX = label.frame.origin.x - 4;
//            CGFloat lineLength = self.bounds.size.height;
//            CGContextMoveToPoint(context, positionX, 0);
//            CGContextAddLineToPoint(context, positionX, lineLength);
//        }
//    }
//    CGContextStrokePath(context);
    [super drawRect:rect];
    for (UILabel *label in self.contentView.subviews) {
        [label.layer setBorderColor:[UIColor grayColor].CGColor];
        [label.layer setBorderWidth:0.5f];
    }
}
@end

@implementation Captain_BalanceManagement{
    NSMutableArray *balanceData;
}
@synthesize addBalanceRecordButton, teamIcon, balanceTableView, balanceTableViewHeaderView;

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
    [balanceTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self drawLineForHeaderView];
    
    //Set the teamIcon
    [teamIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamIcon.layer setBorderWidth:2.0f];
    [teamIcon.layer setCornerRadius:teamIcon.bounds.size.width/2];
    [teamIcon.layer setMasksToBounds:YES];
    
    //Initial data
    balanceData = [NSMutableArray arrayWithArray:fake_blanceData];
    
    //Set menu button
    [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
    [self.navigationItem setRightBarButtonItem:addBalanceRecordButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawLineForHeaderView
{
    for (UILabel *label in balanceTableViewHeaderView.subviews) {
        [label.layer setBorderColor:[UIColor grayColor].CGColor];
        [label.layer setBorderWidth:0.5f];
    }
}

#pragma TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return balanceData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BalanceManagementCell";
    Captain_BalanceManagement_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell.balanceType setText:balanceData[indexPath.row][0]];
    [cell.balanceName setText:balanceData[indexPath.row][1]];
    [cell.balanceDate setText:balanceData[indexPath.row][2]];
    [cell.balanceAmount setText:balanceData[indexPath.row][3]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return balanceTableViewHeaderView.bounds.size.height;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [balanceData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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
