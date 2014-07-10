//
//  Captain_MyPlayers.m
//  Football
//
//  Created by Andy Xu on 14-4-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MyPlayers.h"
#pragma Captain_MyPlayerCell
@implementation Captain_MyPlayerCell
@synthesize playerPortrait, playerName, signUpStatusOfNextMatch, likeView, likeScore, likeIcon, actionButton;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [likeView setBackgroundColor:[UIColor clearColor]];
    [likeView.layer setBorderWidth:1.0f];
    [likeView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [likeView.layer setCornerRadius:8.0f];
    [actionButton.layer setCornerRadius:3.0f];
    [actionButton setBackgroundColor:def_warmUpMatch_actionButtonBG_Enable];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

#pragma Captain_MyPlayer
@implementation Captain_MyPlayers
@synthesize playersTableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [playersTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor clearColor]];

    //Set menu button
    [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (Captain_MyPlayerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Captain_MyPlayerCell";
    Captain_MyPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [playersTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell setTag:indexPath.row];
    return cell;
}

-(IBAction)actionButtonOnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MyPlayer" sender:self];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MyPlayer"]) {
        Captain_PlayerDetails *playerDetails = segue.destinationViewController;
        [playerDetails setViewType:PlayerDetails_MyPlayer];
    }
    else if ([segue.identifier isEqualToString:@"NotifyTeamPlayers"]) {
        Captain_NotifyPlayers *notifyPlayers = segue.destinationViewController;
        [notifyPlayers setViewType:NotifyPlayers_MyTeamPlayers];
        [notifyPlayers setPlayerList:@[@"张三", @"李四", @"王五"]];
    }
}

@end
