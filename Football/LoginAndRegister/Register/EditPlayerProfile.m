//
//  EditPlayerProfile.m
//  Football
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "EditPlayerProfile.h"

@implementation EditPlayerProfile_TableView
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setDelegateForDismissKeyboard:(id)self.delegate];
    [self.delegateForDismissKeyboard dismissKeyboard];
}
@end

@interface EditPlayerProfile ()
@property IBOutlet UIToolbar *saveBar;
@property IBOutlet UIImageView *playerPortraitImageView;
@property IBOutlet UITextField *mailTextField;
@property IBOutlet UITextField *nickNameTextField;
@property IBOutlet UITextField *qqTextField;
@property IBOutlet UITextField *birthdateTextField;
@property IBOutlet UITextFieldForActivityRegion *activityRegionTextField;
@property IBOutlet UITextField *legalNameTextField;
@property IBOutlet UITextField *mobileTextField;
@property IBOutlet UITextField *positionTextField;
@property IBOutlet UITextField *styleTextField;
@end

@implementation EditPlayerProfile{
    UIDatePicker *datePicker;
    UIImagePickerController *imagePicker;
    UIActionSheet *editPlayerPortraitMenu;
    NSArray *textFieldArray;
    NSDateFormatter *birthdayDateFormatter;
    UIPickerView *positionPicker;
    NSArray *positionList;
    JSONConnect *connection;
    enum EditProfileViewSource viewSource;
}
@synthesize saveBar, playerPortraitImageView, nickNameTextField, qqTextField, birthdateTextField, activityRegionTextField, legalNameTextField, mobileTextField, mailTextField, positionTextField, styleTextField;

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
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:saveBar.items];
    textFieldArray = @[legalNameTextField, nickNameTextField, mobileTextField, qqTextField, birthdateTextField, activityRegionTextField, mailTextField, legalNameTextField, positionTextField, styleTextField];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    //Set menu button and message button
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
        [self.navigationItem setRightBarButtonItem:self.navigationController.navigationBar.topItem.rightBarButtonItem];
        viewSource = EditProfileViewSource_Main;
    }
    else {
        viewSource = EditProfileViewSource_Register;
    }
    
    //Set DateFormatter
    birthdayDateFormatter = [[NSDateFormatter alloc] init];
    [birthdayDateFormatter setDateFormat:def_MatchDateformat];
    
    //Set PostionList
    positionList = [gUIStrings objectForKey:@"UI_Positions"];
    
    //Set the playerPortrait related controls
    [playerPortraitImageView.layer setCornerRadius:10.0f];
    [playerPortraitImageView.layer setMasksToBounds:YES];
    [playerPortraitImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerPortraitImageView.layer setBorderWidth:1.0f];
    
    //Set Position picker
    positionPicker = [[UIPickerView alloc] init];
    [positionPicker setDelegate:self];
    [positionPicker setDataSource:self];
    [positionTextField setInputView:positionPicker];
    
    //Set Datepicker for birthdateTextField
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [birthdateTextField setInputView:datePicker];
    [birthdateTextField setTintColor:[UIColor clearColor]];
    [datePicker addTarget:self action:@selector(finishDateEditing) forControlEvents:UIControlEventValueChanged];
    //Set minimumdate and Maximumdate for datepicker
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setMinimumDate:minDate];
    
    //Set imagePicker
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    [imagePicker.navigationBar setTitleTextAttributes:self.navigationController.navigationBar.titleTextAttributes];
    
    //Set EditteamLogo menu
    NSString *menuTitleFile = [[NSBundle mainBundle] pathForResource:@"ActionSheetMenu" ofType:@"plist"];
    NSArray *menuTitleList = [[[NSDictionary alloc] initWithContentsOfFile:menuTitleFile] objectForKey:@"EditplayerPortraitMenu"];
    editPlayerPortraitMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:menuTitleList.lastObject otherButtonTitles:menuTitleList[0], nil];

    //Set activityregion Picker
    [activityRegionTextField setTintColor:[UIColor clearColor]];
    [activityRegionTextField activityRegionTextField];
    
    //Set LeftIcon for textFields
    [mobileTextField initialLeftViewWithIconImage:@"TextFieldIcon_Mobile.png"];
    [mailTextField initialLeftViewWithIconImage:@"TextFieldIcon_Email.png"];
    [nickNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_Account.png"];
    [legalNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_Account.png"];
    [qqTextField initialLeftViewWithIconImage:@"TextFieldIcon_QQ.png"];
    [birthdateTextField initialLeftViewWithIconImage:@"TextFieldIcon_Birthday.png"];
    [activityRegionTextField initialLeftViewWithIconImage:@"TextFieldIcon_ActivityRegion.png"];
    
    //Fill Initial PlayerInfo
    [self fillInitialPlayerProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillInitialPlayerProfile
{
    [mobileTextField setText:gMyUserInfo.mobile];
    [mailTextField setText:gMyUserInfo.email];
    [nickNameTextField setText:gMyUserInfo.nickName];
    [legalNameTextField setText:gMyUserInfo.legalName];
    [qqTextField setText:gMyUserInfo.qq];
    [birthdateTextField setText:gMyUserInfo.birthday];
    [activityRegionTextField presetActivityRegionCode:gMyUserInfo.activityRegion];
    [positionTextField setText:positionList[gMyUserInfo.position]];
    [positionPicker selectRow:gMyUserInfo.position inComponent:0 animated:NO];
    [styleTextField setText:gMyUserInfo.style];
    if (gMyUserInfo.playerPortrait) {
        [playerPortraitImageView setImage:gMyUserInfo.playerPortrait];
    }
    else {
        [playerPortraitImageView setImage:def_defaultPlayerPortrait];
    }
}

-(IBAction)saveButtonOnClicked:(id)sender
{
    UserInfo *userInfo = [gMyUserInfo copy];
    [userInfo setBirthday:birthdateTextField.text];
    [userInfo setActivityRegion:activityRegionTextField.selectedActivityRegionCode];
    [userInfo setLegalName:legalNameTextField.text];
    [userInfo setQq:qqTextField.text];
    [userInfo setPosition:[positionPicker selectedRowInComponent:0]];
    [userInfo setStyle:styleTextField.text];
    [userInfo setPlayerPortrait:[playerPortraitImageView.image isEqual:def_defaultPlayerPortrait]?nil:playerPortraitImageView.image];
    NSDictionary *updatedDictionary = [userInfo dictionaryForUpdate:gMyUserInfo];
    if (updatedDictionary.count > 1) {
        [connection updatePlayerProfile:updatedDictionary];
    }
    else {
        if (viewSource == EditProfileViewSource_Register) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:[gUIStrings objectForKey:@"UI_EditPlayerProfile_NoChange"]
                                                               delegate:nil
                                                      cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"]
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

//Update PlayerProfile Sucessfully
-(void)updatePlayerProfileSuccessfully
{
    [connection requestUserInfo:gMyUserInfo.userId withTeam:YES];
}

//Receive updated UserInfo
-(void)receiveUserInfo:(UserInfo *)userInfo
{
    gMyUserInfo = userInfo;
    if (viewSource == EditProfileViewSource_Register) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[gUIStrings objectForKey:@"UI_EditPlayerProfile_Successful"]
                                                           delegate:nil
                                                  cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"]
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(IBAction)selectplayerPortraitButtonOnClicked:(id)sender
{
    if (![playerPortraitImageView.image isEqual:def_defaultPlayerPortrait]) {
        [editPlayerPortraitMenu showInView:self.view];
    }
    else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

//Position Selections
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return positionList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return positionList[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [positionTextField setText:positionList[row]];
}

//Portrait Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:editPlayerPortraitMenu]) {
        switch (buttonIndex) {
            case 0://Reset playerPortrait
                [playerPortraitImageView setImage:def_defaultPlayerPortrait];
                break;
            case 1://Change playerPortrait
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
        [playerPortraitImageView setImage:image];
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

#pragma DatePicker
-(void)finishDateEditing
{
    [birthdateTextField setText:[birthdayDateFormatter stringFromDate:datePicker.date]];
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
