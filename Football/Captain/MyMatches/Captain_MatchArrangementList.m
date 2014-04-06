//
//  Captain_MatchArrangementList.m
//  Football
//
//  Created by Andy on 14-4-6.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MatchArrangementList.h"

@interface Captain_MatchArrangementList ()

@end

@implementation Captain_MatchArrangementList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}


- (Captain_MatchArrangementListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Captain_MatchArrangementListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Captain_MatchArrangementListCell"];
    
    // Configure the cell...
    [cell.numberOfAcceptPlayers setText:[NSString stringWithFormat:@"%li/10", (long)indexPath.row]];
    [cell.progressOfAcceptPlayers setProgress:indexPath.row / 10];
    NSDateFormatter *matchDateFormatter = [[NSDateFormatter alloc] init];
    [matchDateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSDateFormatter *matchTimeFormatter = [[NSDateFormatter alloc] init];
    [matchTimeFormatter setDateFormat:@"HH:MM"];

    [cell.matchDate setText:[matchDateFormatter stringFromDate:[NSDate date]]];
    [cell.matchTime setText:[matchTimeFormatter stringFromDate:[NSDate date]]];
    [cell.matchOpponent setText:@"Inter Milan"];
    [cell.matchPlace setText:@"San Siro"];
    [cell.matchType setText:@"11人制"];
    [cell.noticePlayer setEnabled:(indexPath.row%2 == 0)?YES:NO];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
