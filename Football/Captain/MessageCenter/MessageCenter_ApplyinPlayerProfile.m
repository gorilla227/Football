//
//  MessageCenter_ApplyinPlayerProfile.m
//  Football
//
//  Created by Andy Xu on 14-8-16.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenter_ApplyinPlayerProfile.h"

@interface MessageCenter_ApplyinPlayerProfile ()
@property IBOutlet UIImageView *playerPortraitImageView;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *legalNameLabel;
@property IBOutlet UILabel *phoneNumberLabel;
@property IBOutlet UILabel *emailLabel;
@property IBOutlet UILabel *qqLabel;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *activityRegionLabel;
@property IBOutlet UILabel *positionLabel;
@property IBOutlet UILabel *styleLabel;
@property IBOutlet UIToolbar *actionBar;
@end

@implementation MessageCenter_ApplyinPlayerProfile{
    JSONConnect *connection;
    UserInfo *senderPlayer;}
@synthesize message;
@synthesize playerPortraitImageView, nickNameLabel, legalNameLabel, phoneNumberLabel, emailLabel, qqLabel, ageLabel, activityRegionLabel, positionLabel, styleLabel, actionBar;

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
    [playerPortraitImageView.layer setCornerRadius:10.0f];
    [playerPortraitImageView.layer setMasksToBounds:YES];
    [playerPortraitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerPortraitImageView.layer setBorderWidth:1.0f];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (message.status == 0 || message.status == 1) {
        [self setToolbarItems:actionBar.items];
        [self.navigationController setToolbarHidden:NO];
    }
    else {
        [self.navigationController setToolbarHidden:YES];
    }
    [connection requestUserInfo:message.senderId withTeam:NO withReference:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    id<BusyIndicatorDelegate>busyIndicatorDelegate = (id)self.navigationController;
    [busyIndicatorDelegate unlockView];
}

-(IBAction)acceptButtonOnClicked:(id)sender
{
    [connection replyApplyinMessage:message.messageId response:2];
}

-(IBAction)declineButtonOnClicked:(id)sender
{
    [connection replyApplyinMessage:message.messageId response:3];
}

-(void)replyApplyinMessageSuccessfully:(NSInteger)responseCode
{
    [message setStatus:responseCode];
    NSString *responseString;
    switch (responseCode) {
        case 2:
            responseString = [gUIStrings objectForKey:@"UI_ReplayApplyin_Accepted"];
            break;
        case 3:
            responseString = [gUIStrings objectForKey:@"UI_ReplayApplyin_Declined"];
            break;
        default:
            break;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:responseString delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTableView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference
{
    senderPlayer = userInfo;
    if (userInfo.playerPortrait) {
        [playerPortraitImageView setImage:userInfo.playerPortrait];
    }
    else {
        [playerPortraitImageView setImage:def_defaultPlayerPortrait];
    }
    [nickNameLabel setText:userInfo.nickName];
    [legalNameLabel setText:userInfo.legalName];
    [emailLabel setText:userInfo.email];
    [phoneNumberLabel setText:userInfo.mobile];
    [qqLabel setText:userInfo.qq];
    [ageLabel setText:[NSNumber numberWithInteger:[Age ageFromString:userInfo.birthday]].stringValue];
    [activityRegionLabel setText:[[ActivityRegion stringWithCode:userInfo.activityRegion] componentsJoinedByString:@" "]];
    [positionLabel setText:[Position stringWithCode:userInfo.position]];
    [styleLabel setText:userInfo.style];
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
