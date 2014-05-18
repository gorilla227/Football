//
//  Captain_WarmupMatch.m
//  Football
//
//  Created by Andy Xu on 14-5-17.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_WarmupMatch.h"

#pragma Captain_WarmupMatch_Cell
@implementation Captain_WarmupMatch_Cell
@synthesize opponentTeamIcon, invitationStatusText, matchPlace, matchDate, matchTime, matchType, matchCost, actionView_beInvited, actionView_invitationAccepted, actionView_invitationRejected, stamp_cancelled, stamp_rejected, beInvited, acceptInvitation, rejectInvitation, invitationStatusBackgroundView, acceptOrRejectInvitationTextView, invitationDetailsView;
@end

#pragma Captain_WarmupMatch
@implementation Captain_WarmupMatch{
    HintTextView *hintView;
}
@synthesize announcementBar, invitaionTableView, announcementTextView;

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
    [invitaionTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [announcementBar setBackgroundColor:def_warmUpMatch_announcementBarBG];
    
    //Set menu button
    [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
    
    //Show hintview when announcement is null
    hintView = [[HintTextView alloc] init];
    [self.view addSubview:hintView];
    [hintView settingHintWithTextKey:@"WarmupMatch" underView:announcementBar wantShow:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateAnnouncement:(NSString *)announcement
{
    [announcementTextView setText:announcement];
    [announcementTextView setHidden:NO];
    [hintView showOrHideHint:NO];
}

#pragma TableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Captain_WarmupMatch_Cell";
    Captain_WarmupMatch_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell.opponentTeamIcon.layer setCornerRadius:cell.opponentTeamIcon.bounds.size.height/2];
    [cell.opponentTeamIcon.layer setBorderWidth:1.0f];
    [cell.opponentTeamIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cell.opponentTeamIcon.layer setMasksToBounds:YES];
    
    switch (indexPath.row) {
        case 0:
            //Be invited, not accept not reject
            [cell.invitationStatusText setText:def_WM_statusText_beInvited(@"Inter Milan")];
            [cell.invitationStatusBackgroundView setBackgroundColor:def_warmUpMatch_statusBarBG_Enable];
            [cell.invitationDetailsView setHidden:NO];
            [cell.acceptOrRejectInvitationTextView setHidden:YES];
            [cell.actionView_beInvited setHidden:NO];
            [cell.beInvited setEnabled:YES];
            [cell.acceptInvitation setEnabled:YES];
            [cell.rejectInvitation setEnabled:YES];
            [cell.acceptInvitation setBackgroundColor:def_warmUpMatch_actionButtonBG_Enable];
            [cell.rejectInvitation setBackgroundColor:def_warmUpMatch_actionButtonBG_Disable];
            [cell.actionView_invitationAccepted setHidden:YES];
            [cell.actionView_invitationRejected setHidden:YES];
            [cell.stamp_rejected setHidden:YES];
            [cell.stamp_cancelled setHidden:YES];
            break;
        case 1:
            //Be invited, other team accepted, so this invitation is cancelled by system
            [cell.invitationStatusText setText:def_WM_statusText_beInvited_cancelled(@"Inter Milan")];
            [cell.invitationStatusBackgroundView setBackgroundColor:def_warmUpMatch_statusBarBG_Disable];
            [cell.invitationDetailsView setHidden:NO];
            [cell.acceptOrRejectInvitationTextView setHidden:YES];
            [cell.actionView_beInvited setHidden:NO];
            [cell.beInvited setEnabled:NO];
            [cell.acceptInvitation setEnabled:NO];
            [cell.rejectInvitation setEnabled:NO];
            [cell.acceptInvitation setBackgroundColor:def_warmUpMatch_actionButtonBG_Disable];
            [cell.rejectInvitation setBackgroundColor:def_warmUpMatch_actionButtonBG_Disable];
            [cell.actionView_invitationAccepted setHidden:YES];
            [cell.actionView_invitationRejected setHidden:YES];
            [cell.stamp_rejected setHidden:YES];
            [cell.stamp_cancelled setHidden:NO];
            [cell.opponentTeamIcon setImage:[UIImage convertImageToGreyScale:cell.opponentTeamIcon.image]];
            break;
        case 2:
            //Be invited, accepted
            [cell.invitationStatusText setText:def_WM_statusText_beInvited(@"Inter Milan")];
            [cell.invitationStatusBackgroundView setBackgroundColor:def_warmUpMatch_statusBarBG_Enable];
            [cell.invitationDetailsView setHidden:YES];
            [cell.acceptOrRejectInvitationTextView setHidden:NO];
            [cell.acceptOrRejectInvitationTextView setText:def_WM_acceptInvitationText(@"Inter Milan")];
            [cell.stamp_rejected setHidden:YES];
            [cell.stamp_cancelled setHidden:YES];
            break;
        case 3:
            //Be invited, rejected
            [cell.invitationStatusText setText:def_WM_statusText_beInvited(@"Inter Milan")];
            [cell.invitationStatusBackgroundView setBackgroundColor:def_warmUpMatch_statusBarBG_Enable];
            [cell.invitationDetailsView setHidden:YES];
            [cell.acceptOrRejectInvitationTextView setHidden:NO];
            [cell.acceptOrRejectInvitationTextView setText:def_WM_rejectInvitationText(@"Inter Milan")];
            [cell.stamp_rejected setHidden:YES];
            [cell.stamp_cancelled setHidden:YES];
            break;
        case 4:
            //My invitation be accepted
            [cell.invitationStatusText setText:def_WM_statusText_myInvitationAccepted(@"Inter Milan")];
            [cell.invitationStatusBackgroundView setBackgroundColor:def_warmUpMatch_statusBarBG_Enable];
            [cell.invitationDetailsView setHidden:NO];
            [cell.acceptOrRejectInvitationTextView setHidden:YES];
            [cell.actionView_beInvited setHidden:YES];
            [cell.actionView_invitationAccepted setHidden:NO];
            [cell.actionView_invitationRejected setHidden:YES];
            [cell.stamp_rejected setHidden:YES];
            [cell.stamp_cancelled setHidden:YES];
            break;
        case 5:
            //My invitation be rejected
            [cell.invitationStatusText setText:def_WM_statusText_myInvitationRejected(@"Inter Milan")];
            [cell.invitationStatusBackgroundView setBackgroundColor:def_warmUpMatch_statusBarBG_Disable];
            [cell.invitationDetailsView setHidden:NO];
            [cell.acceptOrRejectInvitationTextView setHidden:YES];
            [cell.actionView_beInvited setHidden:YES];
            [cell.actionView_invitationAccepted setHidden:YES];
            [cell.actionView_invitationRejected setHidden:NO];
            [cell.stamp_rejected setHidden:NO];
            [cell.stamp_cancelled setHidden:YES];
            [cell.opponentTeamIcon setImage:[UIImage convertImageToGreyScale:cell.opponentTeamIcon.image]];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"UpdateAnnouncement"]) {
        Captain_WarmupMatch_UpdateAnnouncement *targetController = segue.destinationViewController;
        [targetController setDelegate:self];
        [targetController setAnnouncementText:announcementTextView.text];
    }
}

@end
