//
//  Captain_NewPlayer.m
//  Football
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_NewPlayer.h"

#pragma Captain_NewPlayer_ApplicantCell
@implementation Captain_NewPlayer_ApplicantCell
@synthesize nickName, postion, age, team, commentTitle, comment, status, agreementSegment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [commentTitle sizeToFit];
    [comment setTextContainerInset:UIEdgeInsetsZero];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)agreementOnClicked:(id)sender
{
    UIAlertView *confirmAgreement = [[UIAlertView alloc] init];
    [confirmAgreement setDelegate:self];
    switch (agreementSegment.selectedSegmentIndex) {
        case 0:
            [confirmAgreement setTitle:@"同意入队确认"];
            [confirmAgreement setMessage:[NSString stringWithFormat:@"确认同意%@入队？", nickName.text]];
            [confirmAgreement addButtonWithTitle:@"取消"];
            [confirmAgreement addButtonWithTitle:@"同意入队"];
            [confirmAgreement setCancelButtonIndex:0];
            break;
        case 1:
            [confirmAgreement setTitle:@"拒绝入队确认"];
            [confirmAgreement setMessage:[NSString stringWithFormat:@"确认拒绝%@入队？", nickName.text]];
            [confirmAgreement addButtonWithTitle:@"取消"];
            [confirmAgreement addButtonWithTitle:@"拒绝入队"];
            [confirmAgreement setCancelButtonIndex:0];
            break;
        default:
            break;
    }
    [confirmAgreement show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        switch (agreementSegment.selectedSegmentIndex) {
            case 0:
                NSLog(@"同意入队");
                break;
            case 1:
                NSLog(@"拒绝入队");
                break;
            default:
                break;
        }
        [agreementSegment setEnabled:NO];
    }
    else {
        [agreementSegment setSelectedSegmentIndex:-1];
    }
    
}
@end

#pragma Captain_NewPlayer_InviteeCell
@implementation Captain_NewPlayer_InviteeCell
@synthesize playerName, postion, age, team, comment, status, cancelInvitationButton;

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

-(IBAction)cancelInvitationButtonOnClicked:(id)sender
{
    UIAlertView *confirmCancel = [[UIAlertView alloc] initWithTitle:@"取消邀请" message:[NSString stringWithFormat:@"确定要取消对%@的邀请吗？", playerName.text] delegate:self cancelButtonTitle:@"撤销操作" otherButtonTitles:@"确定", nil];
    [confirmCancel show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [cancelInvitationButton setEnabled:NO];
        [cancelInvitationButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        NSLog(@"取消邀请");
    }
}
@end

#pragma Captain_NewPlayer
@implementation Captain_NewPlayer
@synthesize playerNewTableView;

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
    
    //Set menu button
    [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
    
    //Set tableView
    [playerNewTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TableView methods
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        Captain_NewPlayer_ApplicantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Captain_NewPlayer_ApplicantCell"];
        
        // Configure the cell...
        [cell.comment setText:@"一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十"];
        [cell.comment setContentInset:UIEdgeInsetsZero];
        return cell;
    }
    else if (indexPath.row == 1) {
        Captain_NewPlayer_InviteeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Captain_NewPlayer_InviteeCell"];
        
        // Configure the cell...
        [cell.cancelInvitationButton.layer setBorderWidth:1.0f];
        [cell.cancelInvitationButton.layer setBorderColor:[UIColor magentaColor].CGColor];
        [cell.cancelInvitationButton.layer setCornerRadius:5.0f];
        return cell;
    }
    return nil;
}

-(IBAction)callFriendsButtonOnClicked:(id)sender
{
    CallFriends *callFriends = [[CallFriends alloc] initWithDelegate:self];
    [callFriends showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", [actionSheet buttonTitleAtIndex:buttonIndex]);
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Applicant"]) {
        Captain_PlayerDetails *playerDetails = segue.destinationViewController;
        [playerDetails setViewType:PlayerDetails_Applicant];
    }
}
@end