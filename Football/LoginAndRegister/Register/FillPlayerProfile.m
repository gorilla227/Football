//
//  FillPlayerProfile.m
//  Football
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "FillPlayerProfile.h"

@implementation FillPlayerProfile_TableView
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setDelegateForDismissKeyboard:(id)self.delegate];
    [self.delegateForDismissKeyboard dismissKeyboard];
}
@end


@interface FillPlayerProfile ()
@property IBOutlet UIToolbar *saveBar;
@property IBOutlet UIImageView *playerIconImageView;
@property IBOutlet UIButton *playerIconActionButton;
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

@implementation FillPlayerProfile{
    UIDatePicker *datePicker;
    UIImagePickerController *imagePicker;
    UIActionSheet *editPlayerIconMenu;
    NSArray *textFieldArray;
    NSDateFormatter *birthdayDateFormatter;
    UIPickerView *positionPicker;
    NSArray *positionList;
    JSONConnect *connection;
}
@synthesize saveBar, playerIconImageView, playerIconActionButton, nickNameTextField, qqTextField, birthdateTextField, activityRegionTextField, legalNameTextField, mobileTextField, mailTextField, positionTextField, styleTextField;

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
    [self setToolbarItems:saveBar.items];
    textFieldArray = @[legalNameTextField, nickNameTextField, mobileTextField, qqTextField, birthdateTextField, activityRegionTextField, mailTextField, legalNameTextField, positionTextField, styleTextField];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    connection = [[JSONConnect alloc] initWithDelegate:self];
    
    //Set DateFormatter
    birthdayDateFormatter = [[NSDateFormatter alloc] init];
    [birthdayDateFormatter setDateFormat:def_MatchDateformat];
    
    //Set PostionList
    positionList = [gUIStrings objectForKey:@"UI_Positions"];
    
    //Set the playerIcon related controls
    [playerIconImageView.layer setCornerRadius:10.0f];
    [playerIconImageView.layer setMasksToBounds:YES];
    [playerIconImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerIconImageView.layer setBorderWidth:1.0f];
    
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
    
    //Set EditTeamIcon menu
    NSString *menuTitleFile = [[NSBundle mainBundle] pathForResource:@"ActionSheetMenu" ofType:@"plist"];
    NSArray *menuTitleList = [[[NSDictionary alloc] initWithContentsOfFile:menuTitleFile] objectForKey:@"EditPlayerIconMenu"];
    editPlayerIconMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:menuTitleList.lastObject otherButtonTitles:menuTitleList[0], nil];

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
    
    //Set selectTeamIconButton
    if (playerIconImageView.image) {
        [playerIconActionButton setTitle:nil forState:UIControlStateNormal];
    }
    else {
        [playerIconActionButton setTitle:[gUIStrings objectForKey:@"UI_FillPlayerProfile_PlayerIconButton_New"] forState:UIControlStateNormal];
    }
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
    [styleTextField setText:gMyUserInfo.style];
    if (gMyUserInfo.playerPortrait) {
        [playerIconImageView setImage:gMyUserInfo.playerPortrait];
        [playerIconActionButton setTitle:nil forState:UIControlStateNormal];
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
    NSDictionary *updatedDictionary = [userInfo dictionaryForUpdate:gMyUserInfo];
    NSLog(@"%@", updatedDictionary);
    if (updatedDictionary.count > 1) {
        [self.navigationController.view setUserInteractionEnabled:NO];
        [connection updatePlayerProfile:updatedDictionary];
    }
    else if (![gMyUserInfo.playerPortrait isEqual:playerIconImageView.image]) {
        //Update the portrait
        [connection updatePlayerPortrait:playerIconImageView.image forPlayer:gMyUserInfo.userId];
    }
}

-(void)unlockView
{
    [self.navigationController.view setUserInteractionEnabled:YES];
}

//Update PlayerProfile Sucessfully
-(void)updatePlayerProfileSuccessfully
{
    if (![gMyUserInfo.playerPortrait isEqual:playerIconImageView.image]) {
        //Update the portrait
        [connection updatePlayerPortrait:playerIconImageView.image forPlayer:gMyUserInfo.userId];
    }
    else {
        [connection requestUserInfo:gMyUserInfo.userId];
    }
}

//Update PlayerPortrait Successfully
-(void)updatePlayerPortraitSuccessfully
{
    [connection requestUserInfo:gMyUserInfo.userId];
}

//Receive updated UserInfo
-(void)receiveUserInfo:(UserInfo *)userInfo
{
    gMyUserInfo = userInfo;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)selectPlayerIconButtonOnClicked:(id)sender
{
    if (playerIconImageView.image) {
        [editPlayerIconMenu showInView:self.view];
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
    if ([actionSheet isEqual:editPlayerIconMenu]) {
        switch (buttonIndex) {
            case 0://Delete playerIcon
                [playerIconImageView setImage:nil];
                [playerIconActionButton setTitle:[gUIStrings objectForKey:@"UI_FillPlayerProfile_PlayerIconButton_New"] forState:UIControlStateNormal];
                break;
            case 1://Change playerIcon
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
        [playerIconImageView setImage:image];
        [playerIconActionButton setTitle:nil forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (!playerIconImageView.image) {
        [playerIconActionButton setTitle:[gUIStrings objectForKey:@"UI_FillPlayerProfile_PlayerIconButton_New"] forState:UIControlStateNormal];
    }
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
