//
//  Captain_NewPlayer.m
//  Football
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_NewPlayer.h"

#pragma Captain_NewPlayer_ApplyinCell
@interface Captain_NewPlayer_ApplyinCell ()
@property IBOutlet UIImageView *playerPortaitImageView;
@property IBOutlet UILabel *activityRegionLabel;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *positionLabel;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *styleLabel;
@property IBOutlet UILabel *timeStampLabel;
@property IBOutlet UISegmentedControl *agreementSegment;
@end

@implementation Captain_NewPlayer_ApplyinCell
@synthesize nickNameLabel, positionLabel, ageLabel, agreementSegment, playerPortaitImageView, activityRegionLabel, styleLabel, timeStampLabel;

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
    [super drawRect:rect];
    [playerPortaitImageView.layer setCornerRadius:10.0f];
    [playerPortaitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerPortaitImageView.layer setBorderWidth:1.0f];
    [playerPortaitImageView.layer setMasksToBounds:YES];
}

-(IBAction)agreementOnClicked:(id)sender
{
    UIAlertView *confirmAgreement = [[UIAlertView alloc] init];
    [confirmAgreement setDelegate:self];
    switch (agreementSegment.selectedSegmentIndex) {
        case 0:
            [confirmAgreement setTitle:@"同意入队确认"];
            [confirmAgreement setMessage:[NSString stringWithFormat:@"确认同意%@入队？", nickNameLabel.text]];
            [confirmAgreement addButtonWithTitle:@"取消"];
            [confirmAgreement addButtonWithTitle:@"同意入队"];
            [confirmAgreement setCancelButtonIndex:0];
            break;
        case 1:
            [confirmAgreement setTitle:@"拒绝入队确认"];
            [confirmAgreement setMessage:[NSString stringWithFormat:@"确认拒绝%@入队？", nickNameLabel.text]];
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

#pragma Captain_NewPlayer_CallinCell
@interface Captain_NewPlayer_CallinCell ()
@property IBOutlet UILabel *playerName;
@property IBOutlet UILabel *postion;
@property IBOutlet UILabel *age;
@property IBOutlet UILabel *team;
@property IBOutlet UITextView *comment;
@property IBOutlet UILabel *status;
@property IBOutlet UIButton *cancelInvitationButton;
@end
@implementation Captain_NewPlayer_CallinCell
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
@interface Captain_NewPlayer ()
@property IBOutlet UITableView *playerNewTableView;
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UISegmentedControl *typeSegement;
@property IBOutlet UILabel *numOfTeamMemberLabel;
@property IBOutlet UILabel *numOfApplyinLabel;
@property IBOutlet UILabel *numOfCallinLabel;
@end

@implementation Captain_NewPlayer{
    JSONConnect *connection;
    NSArray *applyinList;
    NSArray *callinList;
    NSMutableDictionary *messageReferenceDictionary;
}
@synthesize playerNewTableView, teamLogoImageView, typeSegement, numOfApplyinLabel, numOfCallinLabel, numOfTeamMemberLabel;

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
    messageReferenceDictionary = [NSMutableDictionary new];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //Set tableView
    [playerNewTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Set TeamLogo ImageView
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setBorderWidth:1.0f];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setMasksToBounds:YES];
    
    //Set TeamInfo
    [teamLogoImageView setImage:gMyUserInfo.team.teamLogo?gMyUserInfo.team.teamLogo:def_defaultTeamLogo];
    [numOfTeamMemberLabel setText:[NSNumber numberWithInteger:gMyUserInfo.team.numOfMember].stringValue];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestReceivedMessage:gMyUserInfo.userId messageTypes:@[[NSNumber numberWithInteger:2]] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:0 count:[[gSettings objectForKey:@"messageListCount"] integerValue] isSync:YES];
    [connection requestSentMessage:gMyUserInfo.userId messageTypes:@[[NSNumber numberWithInteger:1]] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:0 count:[[gSettings objectForKey:@"messageListCount"] integerValue] isSync:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType
{
    if (sourceType == RequestMessageSourceType_Receiver) {
        if (applyinList) {
            applyinList = [applyinList arrayByAddingObjectsFromArray:messages];
        }
        else {
            applyinList = messages;
        }
        if (messages.count == [[gSettings objectForKey:@"messageListCount"] integerValue]) {
            [connection requestReceivedMessage:gMyUserInfo.userId messageTypes:@[[NSNumber numberWithInteger:2]] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:applyinList.count count:[[gSettings objectForKey:@"messageListCount"] integerValue] isSync:YES];
        }
        else {
            for (Message *message in applyinList) {
                [connection requestUserInfo:message.senderId withTeam:NO withReference:[NSNumber numberWithInteger:message.messageId]];
            }
            if (typeSegement.selectedSegmentIndex == 0) {
                [playerNewTableView reloadData];
            }
        }
    }
    else if (sourceType == RequestMessageSourceType_Sender) {
        if (callinList) {
            callinList = [callinList arrayByAddingObjectsFromArray:messages];
        }
        else {
            callinList = messages;
        }
        if (messages.count == [[gSettings objectForKey:@"messageListCount"] integerValue]) {
            [connection requestSentMessage:gMyUserInfo.userId messageTypes:@[[NSNumber numberWithInteger:1]] status:CONNECT_RequestMessages_Parameters_DefaultStatus startIndex:callinList.count count:[[gSettings objectForKey:@"messageListCount"] integerValue] isSync:YES];
        }
        else {
            for (Message *message in callinList) {
                [connection requestUserInfo:message.senderId withTeam:NO withReference:[NSNumber numberWithInteger:message.messageId]];
            }
            if (typeSegement.selectedSegmentIndex == 1) {
                [playerNewTableView reloadData];
            }
        }
    }
}

-(void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference
{
    [messageReferenceDictionary setObject:userInfo forKey:reference];
    [playerNewTableView reloadData];
}

//TableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (typeSegement.selectedSegmentIndex == 0) {
        return applyinList.count;
    }
    else {
        return callinList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (typeSegement.selectedSegmentIndex == 0) {
        Message *message = [applyinList objectAtIndex:indexPath.row];
        UserInfo *sender = [messageReferenceDictionary objectForKey:[NSNumber numberWithInteger:message.messageId]];
        Captain_NewPlayer_ApplyinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Applyin_Cell"];
        // Configure the cell...
        [cell.nickNameLabel setText:sender.nickName];
        [cell.ageLabel setText:[NSNumber numberWithInteger:[Age ageFromString:sender.birthday]].stringValue];
        [cell.activityRegionLabel setText:[[ActivityRegion stringWithCode:sender.activityRegion] componentsJoinedByString:@" "]];
        [cell.styleLabel setText:sender.style];
        [cell.positionLabel setText:[Position stringWithCode:sender.position]];
        switch (message.status) {
            case 0:
            case 1:
                [cell.agreementSegment setSelectedSegmentIndex:-1];
                [cell.agreementSegment setEnabled:YES];
                break;
            case 2:
                [cell.agreementSegment setSelectedSegmentIndex:0];
                [cell.agreementSegment setEnabled:NO];
                break;
            case 3:
                [cell.agreementSegment setSelectedSegmentIndex:1];
                [cell.agreementSegment setEnabled:NO];
                break;
            case 4:
                [cell.agreementSegment setSelectedSegmentIndex:-1];
                [cell.agreementSegment setEnabled:NO];
                break;
            default:
                break;
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:def_MessageDateformat];
        [cell.timeStampLabel setText:[dateFormatter stringFromDate:message.creationDate]];
        return cell;
    }
    else {
        Captain_NewPlayer_CallinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Callin_Cell"];

        // Configure the cell...
        [cell.cancelInvitationButton.layer setBorderWidth:1.0f];
        [cell.cancelInvitationButton.layer setBorderColor:[UIColor magentaColor].CGColor];
        [cell.cancelInvitationButton.layer setCornerRadius:5.0f];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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

-(IBAction)switchType:(id)sender
{
    [playerNewTableView reloadData];
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