//
//  EditTeamProfile.m
//  Soccer
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "EditTeamProfile.h"

@implementation EditTeamProfile_TableView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setDelegateForDismissKeyboard:(id)self.delegate];
    [self.delegateForDismissKeyboard dismissKeyboard];
}
@end

@interface EditTeamProfile ()
@property IBOutlet UIToolbar *saveBar;
@property IBOutlet UIToolbar *createTeamBar;
@property IBOutlet UIBarButtonItem *createTeamButton;
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UITextField *teamNameTextField;
@property IBOutlet UITextFieldForActivityRegion *activityRegionTextField;
@property IBOutlet UITextFieldForStadiumSelection *homeStadiumTextField;
@property IBOutlet UITextView *sloganTextView;
@property IBOutlet UIButton *selectTeamLogoButton;
@property IBOutlet UIView *numOfTeamMemberView;
@property IBOutlet UILabel *numOfTeamMemberLabel;
@property IBOutlet UISwitch *recruitFlagSwitch;
@property IBOutlet UITextView *recruitAnnouncementTextView;
@property IBOutlet UISwitch *challengeFlagSwitch;
@property IBOutlet UITextView *challengeAnnouncementTextView;
@end

@implementation EditTeamProfile {
    NSArray *textFieldArray;
    UIImagePickerController *imagePicker;
    UIActionSheet *editTeamLogoMenu;
    JSONConnect *connection;
}
@synthesize viewType;
@synthesize saveBar, createTeamBar, createTeamButton, teamLogoImageView, teamNameTextField, activityRegionTextField, homeStadiumTextField, sloganTextView, selectTeamLogoButton, numOfTeamMemberView, numOfTeamMemberLabel, recruitFlagSwitch, recruitAnnouncementTextView, challengeFlagSwitch, challengeAnnouncementTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)bgImage];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
//    [self.tableView setBackgroundColor:[UIColor clearColor]];
    textFieldArray = @[teamNameTextField, activityRegionTextField, homeStadiumTextField, sloganTextView, recruitAnnouncementTextView, challengeAnnouncementTextView];
    
    //Set the controls enable status
    if (viewType == EditProfileViewType_Default) {
        if (gMyUserInfo.team) {
            //Team Member check the teamProfile
            for (UIControl * control in textFieldArray) {
                [control setEnabled:gMyUserInfo.userType];
            }
            [selectTeamLogoButton setEnabled:gMyUserInfo.userType];
            [recruitFlagSwitch setEnabled:gMyUserInfo.userType];
            [challengeFlagSwitch setEnabled:gMyUserInfo.userType];
            [self setToolbarItems:gMyUserInfo.userType?saveBar.items:nil];
            [numOfTeamMemberView setHidden:NO];
            [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_EditTeamProfile_Title"]];
        }
        else {
            //Player without Team creates new team
            for (UIControl * control in textFieldArray) {
                [control setEnabled:YES];
            }
            [selectTeamLogoButton setEnabled:YES];
            [recruitFlagSwitch setEnabled:YES];
            [challengeFlagSwitch setEnabled:YES];
            [self setToolbarItems:createTeamBar.items];
            [numOfTeamMemberView setHidden:YES];
            [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_CreateTeam_Title"]];
        }
    }
    else {
        //Register new player with new team
        [self setToolbarItems:saveBar.items];
        [numOfTeamMemberView setHidden:YES];
        [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_EditTeamProfile_Title"]];
    }
    
    
    //Set the playerPortrait related controls
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setMasksToBounds:YES];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setBorderWidth:1.0f];
    
    //Set imagePicker
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:(id)self];
    [imagePicker setAllowsEditing:YES];
    [imagePicker.navigationBar setTranslucent:NO];
    [imagePicker.navigationBar setTitleTextAttributes:self.navigationController.navigationBar.titleTextAttributes];
    
    //Set EditteamLogo menu
    NSString *menuTitleFile = [[NSBundle mainBundle] pathForResource:@"ActionSheetMenu" ofType:@"plist"];
    NSArray *menuTitleList = [[[NSDictionary alloc] initWithContentsOfFile:menuTitleFile] objectForKey:@"EditteamLogoMenu"];
    editTeamLogoMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:menuTitleList.lastObject otherButtonTitles:menuTitleList[0], nil];
    
    //Set activityregion Picker
    [activityRegionTextField setTintColor:[UIColor clearColor]];
    
    //Set slogan, recruitAnnouncement, challengeAnnouncement textViews border style consistent with TextField
    [sloganTextView initializeUITextFieldRoundCornerStyle];
    [recruitAnnouncementTextView initializeUITextFieldRoundCornerStyle];
    [challengeAnnouncementTextView initializeUITextFieldRoundCornerStyle];
    
    //Set LeftIcon for textFields
    [teamNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_TeamName.png"];
    [homeStadiumTextField initialLeftViewWithIconImage:@"TextFieldIcon_Stadium.png"];
    [activityRegionTextField initialLeftViewWithIconImage:@"TextFieldIcon_ActivityRegion.png"];
    
    //Fill Initial TeamInfo
    [self fillInitialTeamProfile];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!self.toolbarItems.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillInitialTeamProfile {
    [homeStadiumTextField textFieldInitialization:gStadiums homeStadium:nil showSelectHomeStadium:NO];
    if (gMyUserInfo.team) {
        [teamNameTextField setText:gMyUserInfo.team.teamName];
        [activityRegionTextField presetActivityRegionCode:gMyUserInfo.team.activityRegion];
        [homeStadiumTextField presetStadium:gMyUserInfo.team.homeStadium];
        [sloganTextView setText:gMyUserInfo.team.slogan];
        if (gMyUserInfo.team.teamLogo) {
            [teamLogoImageView setImage:gMyUserInfo.team.teamLogo];
        }
        else {
            [teamLogoImageView setImage:def_defaultTeamLogo];
        }
        [numOfTeamMemberLabel setText:[NSString stringWithFormat:@"%li", (long)gMyUserInfo.team.numOfMember]];
        [recruitFlagSwitch setOn:gMyUserInfo.team.recruitFlag];
        [challengeFlagSwitch setOn:gMyUserInfo.team.challengeFlag];
        [recruitAnnouncementTextView setText:gMyUserInfo.team.recruitAnnouncement];
        [challengeAnnouncementTextView setText:gMyUserInfo.team.challengeAnnouncement];
    }
    else {
        [activityRegionTextField presetActivityRegionCode:gMyUserInfo.activityRegion];
        if (gMyUserInfo.team.teamLogo) {
            [teamLogoImageView setImage:gMyUserInfo.team.teamLogo];
        }
        else {
            [teamLogoImageView setImage:def_defaultTeamLogo];
        }
        [recruitFlagSwitch setOn:YES];
        [challengeFlagSwitch setOn:YES];
    }
}

- (IBAction)saveButtonOnClicked:(id)sender {
    Team *teamInfo = [gMyUserInfo.team copy];
    [teamInfo setTeamName:teamNameTextField.text];
    [teamInfo setActivityRegion:activityRegionTextField.selectedActivityRegionCode];
    [teamInfo setHomeStadium:homeStadiumTextField.selectedStadium];
    [teamInfo setSlogan:sloganTextView.text];
    [teamInfo setTeamLogo:[teamLogoImageView.image isEqual:def_defaultTeamLogo]?nil:teamLogoImageView.image];
    [teamInfo setRecruitFlag:recruitFlagSwitch.on];
    [teamInfo setChallengeFlag:challengeFlagSwitch.on];
    [teamInfo setRecruitAnnouncement:recruitAnnouncementTextView.text];
    [teamInfo setChallengeAnnouncement:challengeAnnouncementTextView.text];
    NSDictionary *updateDictionary = [teamInfo dictionaryForUpdate:gMyUserInfo.team withPlayer:gMyUserInfo.userId];
    if (updateDictionary.count > 2) {
        [connection updateTeamProfile:updateDictionary];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[gUIStrings objectForKey:@"UI_EditTeamProfile_NoChange"]
                                                           delegate:nil
                                                  cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"]
                                                  otherButtonTitles:nil];
        [alertView setTag:1];
        [alertView show];
    }
}

- (IBAction)createTeamButtonOnClicked:(id)sender {
    Team *newTeamProfile = [Team new];
    [newTeamProfile setTeamLogo:[teamLogoImageView.image isEqual:def_defaultTeamLogo]?nil:teamLogoImageView.image];
    [newTeamProfile setTeamName:teamNameTextField.text];
    [newTeamProfile setHomeStadium:homeStadiumTextField.selectedStadium];
    [newTeamProfile setActivityRegion:activityRegionTextField.selectedActivityRegionCode];
    [newTeamProfile setSlogan:sloganTextView.text];
    [newTeamProfile setRecruitFlag:recruitFlagSwitch.isOn];
    [newTeamProfile setRecruitAnnouncement:recruitAnnouncementTextView.text];
    [newTeamProfile setChallengeFlag:challengeFlagSwitch.isOn];
    [newTeamProfile setChallengeAnnouncement:challengeAnnouncementTextView.text];
    
    [connection createTeamByCaptainId:gMyUserInfo.userId teamProfile:newTeamProfile];
}

//Update TeamProfile Sucessfully
- (void)updateTeamProfileSuccessfully {
    [connection requestUserInfo:gMyUserInfo.userId withTeam:YES withReference:nil];
}

//Receive updated UserInfo
- (void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference {
    gMyUserInfo = userInfo;
    if (viewType == EditProfileViewType_Register) {
        if (userInfo.team && !gMyUserInfo.team) {
            //Create new team successfully
            gMyUserInfo = userInfo;
            UIAlertView *createTeamSuccessAleartView = [[UIAlertView alloc] initWithTitle:[gUIStrings objectForKey:@"UI_CreateTeamSucc_AlertView_Title"]
                                                                                  message:[gUIStrings objectForKey:@"UI_CreateTeamSucc_AlertView_Message"]
                                                                                 delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_CreateTeamSucc_AlertView_Button"]
                                                                        otherButtonTitles:nil];
            [createTeamSuccessAleartView setTag:0];
            [createTeamSuccessAleartView show];
        }
        else {
            gMyUserInfo = userInfo;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[gUIStrings objectForKey:@"UI_EditTeamProfile_Successful"]
                                                           delegate:nil
                                                  cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"]
                                                  otherButtonTitles:nil];
        [alertView setTag:1];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Soccer" bundle:nil];
        UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
        [self.view.window.rootViewController presentViewController:mainController animated:YES completion:nil];
    }
}

- (IBAction)selectTeamLogoButtonOnClicked:(id)sender {
    if (![teamLogoImageView.image isEqual:def_defaultTeamLogo]) {
        [editTeamLogoMenu showInView:self.view];
    }
    else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet isEqual:editTeamLogoMenu]) {
        switch (buttonIndex) {
            case 0://Reset teamLogo
                [teamLogoImageView setImage:def_defaultTeamLogo];
                break;
            case 1://Change teamLogo
                [self presentViewController:imagePicker animated:YES completion:nil];
                break;
            default:
                break;
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *imageType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([imageType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [teamLogoImageView setImage:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//Protocol DismissKeyboard
- (void)dismissKeyboard {
    for (UIControl *control in textFieldArray) {
        [control resignFirstResponder];
    }
}

//TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:teamNameTextField]) {
        NSString *teamNameString = [teamNameTextField.text stringByReplacingCharactersInRange:range withString:string];
        [createTeamButton setEnabled:[teamNameString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length];
    }
    return YES;
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
