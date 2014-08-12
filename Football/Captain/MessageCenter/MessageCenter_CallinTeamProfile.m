//
//  MessageCenter_CallinTeamProfile.m
//  Football
//
//  Created by Andy on 14-8-10.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenter_CallinTeamProfile.h"

@interface MessageCenter_CallinTeamProfile ()
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UILabel *numOfTeamMemberLabel;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *homeStadiumLabel;
@property IBOutlet UILabel *activityRegionLabel;
@property IBOutlet UILabel *sloganLabel;
@property IBOutlet UIToolbar *actionBar;
@end

@implementation MessageCenter_CallinTeamProfile{
    JSONConnect *connection;
    Team *senderTeam;
}
@synthesize message;
@synthesize teamLogoImageView, teamNameLabel, numOfTeamMemberLabel, homeStadiumLabel, activityRegionLabel, sloganLabel, actionBar;

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
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Set the playerPortrait related controls
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setMasksToBounds:YES];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setBorderWidth:1.0f];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveTeam:(Team *)team
{
    senderTeam = team;
    if (team.teamLogo) {
        [teamLogoImageView setImage:team.teamLogo];
    }
    else {
        [teamLogoImageView setImage:def_defaultTeamLogo];
    }
    [teamNameLabel setText:team.teamName];
    [numOfTeamMemberLabel setText:[[NSNumber numberWithInteger:team.numOfMember] stringValue]];
    [homeStadiumLabel setText:team.homeStadium.stadiumName];
    [activityRegionLabel setText:[[ActivityRegion stringWithCode:team.activityRegion] componentsJoinedByString:@" "]];
    [sloganLabel setText:team.slogan];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (message.status == 0 || message.status == 1) {
        [self setToolbarItems:self.actionBar.items];
        [self.navigationController setToolbarHidden:NO];
    }
    else {
        [self.navigationController setToolbarHidden:YES];
    }
    [connection requestTeamById:message.senderId isSync:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    id<BusyIndicatorDelegate>busyIndicatorDelegate = (id)self.navigationController;
    [busyIndicatorDelegate unlockView];
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
