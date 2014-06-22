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
@property IBOutlet UITextField *phoneNumberTextField;
@end

@implementation FillPlayerProfile{
    UIDatePicker *datePicker;
    UIImagePickerController *imagePicker;
    UIActionSheet *editPlayerIconMenu;
    NSArray *textFieldArray;
}
@synthesize saveBar, playerIconImageView, playerIconActionButton, nickNameTextField, qqTextField, birthdateTextField, activityRegionTextField, legalNameTextField, phoneNumberTextField, mailTextField;

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
    textFieldArray = @[legalNameTextField, nickNameTextField, phoneNumberTextField, qqTextField, birthdateTextField, activityRegionTextField, mailTextField];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    //Set the playerIcon related controls
    [playerIconImageView.layer setCornerRadius:10.0f];
    [playerIconImageView.layer setMasksToBounds:YES];
    [playerIconImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerIconImageView.layer setBorderWidth:1.0f];
    
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
    
    //Set selectTeamIconButton
    if (playerIconImageView.image) {
        [playerIconActionButton setTitle:nil forState:UIControlStateNormal];
    }
    else {
        [playerIconActionButton setTitle:[gUIStrings objectForKey:@"UI_FillPlayerProfile_PlayerIconButton_New"] forState:UIControlStateNormal];
    }

    //Set activityregion Picker
    [activityRegionTextField setTintColor:[UIColor clearColor]];
    [activityRegionTextField activityRegionTextField];
    
    //Set LeftIcon for textFields
    [phoneNumberTextField initialLeftViewWithIconImage:@"TextFieldIcon_Mobile.png"];
//    [mailTextField initialLeftViewWithIconImage:@""];
    [nickNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_Account.png"];
    [legalNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_Account.png"];
    [qqTextField initialLeftViewWithIconImage:@"TextFieldIcon_QQ.png"];
    [birthdateTextField initialLeftViewWithIconImage:@"TextFieldIcon_Birthday.png"];
    [activityRegionTextField initialLeftViewWithIconImage:@"TextFieldIcon_ActivityRegion.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveButtonOnClicked:(id)sender
{
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_MatchDateformat];
    [birthdateTextField setText:[dateFormatter stringFromDate:datePicker.date]];
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
