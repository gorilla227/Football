//
//  EditTeamProfile.m
//  Football
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "EditTeamProfile.h"
#import "UITextView+UITextFieldRoundCornerStyle.h"

@implementation EditTeamProfile_TableView
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setDelegateForDismissKeyboard:(id)self.delegate];
    [self.delegateForDismissKeyboard dismissKeyboard];
}
@end

@interface EditTeamProfile ()
@property IBOutlet UIToolbar *saveBar;
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

@implementation EditTeamProfile{
    NSArray *textFieldArray;
    UIImagePickerController *imagePicker;
    UIActionSheet *editTeamLogoMenu;
    JSONConnect *connection;
    enum EditProfileViewSource viewSource;
}
@synthesize saveBar, teamLogoImageView, teamNameTextField, activityRegionTextField, homeStadiumTextField, sloganTextView, selectTeamLogoButton, numOfTeamMemberView, numOfTeamMemberLabel, recruitFlagSwitch, recruitAnnouncementTextView, challengeFlagSwitch, challengeAnnouncementTextView;

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
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self setToolbarItems:saveBar.items];
    textFieldArray = @[teamNameTextField, activityRegionTextField, homeStadiumTextField, sloganTextView, recruitAnnouncementTextView, challengeAnnouncementTextView];
    
    //Set menu button and message button
    if (self.navigationController.viewControllers.count == 1) {
        viewSource = EditProfileViewSource_Main;
        [numOfTeamMemberView setHidden:NO];
    }
    else {
        viewSource = EditProfileViewSource_Register;
        [numOfTeamMemberView setHidden:YES];
    }
    
    //Set the controls enable status
    if (gMyUserInfo.userType == 0) {
        for (UIControl * control in textFieldArray) {
            [control setEnabled:NO];
        }
        [selectTeamLogoButton setEnabled:NO];
        [self.navigationController setToolbarHidden:YES];
    }
    
    //Set the playerPortrait related controls
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setMasksToBounds:YES];
    [teamLogoImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamLogoImageView.layer setBorderWidth:1.0f];
    
    //Set imagePicker
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    [imagePicker.navigationBar setTitleTextAttributes:self.navigationController.navigationBar.titleTextAttributes];
    
    //Set EditteamLogo menu
    NSString *menuTitleFile = [[NSBundle mainBundle] pathForResource:@"ActionSheetMenu" ofType:@"plist"];
    NSArray *menuTitleList = [[[NSDictionary alloc] initWithContentsOfFile:menuTitleFile] objectForKey:@"EditteamLogoMenu"];
    editTeamLogoMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:menuTitleList.lastObject otherButtonTitles:menuTitleList[0], nil];
    
    //Set activityregion Picker
    [activityRegionTextField setTintColor:[UIColor clearColor]];
    [activityRegionTextField activityRegionTextField];
    
    //Set slogan, recruitAnnouncement, challengeAnnouncement textViews border style consistent with TextField
    [sloganTextView initializeUITextFieldRoundCornerStyle];
    [recruitAnnouncementTextView initializeUITextFieldRoundCornerStyle];
    [challengeAnnouncementTextView initializeUITextFieldRoundCornerStyle];
    
    //Set LeftIcon for textFields
    [teamNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_TeamName.png"];
    [homeStadiumTextField initialLeftViewWithIconImage:@"TextFieldIcon_Stadium.png"];
    [activityRegionTextField initialLeftViewWithIconImage:@"TextFieldIcon_ActivityRegion.png"];
    
    //Get all stadiums
    [connection requestAllStadiums];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillInitialTeamProfile
{
    [teamNameTextField setText:gMyUserInfo.team.teamName];
    [activityRegionTextField presetActivityRegionCode:gMyUserInfo.team.activityRegion];
    [homeStadiumTextField presetHomeStadium:gMyUserInfo.team.homeStadium];
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

-(IBAction)saveButtonOnClicked:(id)sender
{
    Team *teamInfo = [gMyUserInfo.team copy];
    [teamInfo setTeamName:teamNameTextField.text];
    [teamInfo setActivityRegion:activityRegionTextField.selectedActivityRegionCode];
    [teamInfo setHomeStadium:homeStadiumTextField.selectedHomeStadium];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//Update TeamProfile Sucessfully
-(void)updateTeamProfileSuccessfully
{
    [connection requestUserInfo:gMyUserInfo.userId withTeam:YES];
}

//Receive updated UserInfo
-(void)receiveUserInfo:(UserInfo *)userInfo
{
    gMyUserInfo = userInfo;
    [self.navigationController popViewControllerAnimated:YES];
}

//Receive all stadiums
-(void)receiveAllStadiums:(NSArray *)stadiums
{
    [homeStadiumTextField textFieldInitialization:stadiums];
    
    //Fill Initial TeamInfo
    [self fillInitialTeamProfile];
}

-(IBAction)selectTeamLogoButtonOnClicked:(id)sender
{
    if (![teamLogoImageView.image isEqual:def_defaultTeamLogo]) {
        [editTeamLogoMenu showInView:self.view];
    }
    else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *imageType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([imageType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [teamLogoImageView setImage:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//Protocol DismissKeyboard
-(void)dismissKeyboard
{
    for (UITextField *textField in textFieldArray) {
        [textField resignFirstResponder];
    }
}

//TextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

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
