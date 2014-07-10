//
//  FillTeamProfile.m
//  Football
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "FillTeamProfile.h"

@implementation FillTeamProfile_TableView
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setDelegateForDismissKeyboard:(id)self.delegate];
    [self.delegateForDismissKeyboard dismissKeyboard];
}
@end

@interface FillTeamProfile ()
@property IBOutlet UIToolbar *saveBar;
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UIButton *teamLogoActionButton;
@property IBOutlet UITextField *teamNameTextField;
@property IBOutlet UITextFieldForActivityRegion *activityRegionTextField;
@property IBOutlet UITextField *homeStadiumTextField;
@property IBOutlet UITextView *sloganTextView;
@end

@implementation FillTeamProfile{
    NSArray *textFieldArray;
    UIImagePickerController *imagePicker;
    UIActionSheet *editteamLogoMenu;
}
@synthesize saveBar, teamLogoImageView, teamLogoActionButton, teamNameTextField, activityRegionTextField, homeStadiumTextField, sloganTextView;

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
    [self setToolbarItems:saveBar.items];
    textFieldArray = @[teamNameTextField, activityRegionTextField, homeStadiumTextField, sloganTextView];
    
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
    editteamLogoMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:menuTitleList.lastObject otherButtonTitles:menuTitleList[0], nil];
    
    //Set selectteamLogoButton
    if (teamLogoImageView.image) {
        [teamLogoActionButton setTitle:nil forState:UIControlStateNormal];
    }
    else {
        [teamLogoActionButton setTitle:[gUIStrings objectForKey:@"UI_FillTeamProfile_teamLogoButton_New"] forState:UIControlStateNormal];
    }
    
    //Set activityregion Picker
    [activityRegionTextField setTintColor:[UIColor clearColor]];
    [activityRegionTextField activityRegionTextField];
    
    //Set sloganTextView border style consistent with TextField
    [sloganTextView.layer setBorderColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1].CGColor];
    [sloganTextView.layer setBorderWidth:0.6f];
    [sloganTextView.layer setCornerRadius:6.0f];
    
    //Set LeftIcon for textFields
    [teamNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_TeamName.png"];
    [homeStadiumTextField initialLeftViewWithIconImage:@"TextFieldIcon_Stadium.png"];
    [activityRegionTextField initialLeftViewWithIconImage:@"TextFieldIcon_ActivityRegion.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillInitialTeamProfile
{
    
}

-(void)unlockView
{
    [self.navigationController.view setUserInteractionEnabled:YES];
}

-(IBAction)saveButtonOnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)selectteamLogoButtonOnClicked:(id)sender
{
    if (teamLogoImageView.image) {
        [editteamLogoMenu showInView:self.view];
    }
    else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:editteamLogoMenu]) {
        switch (buttonIndex) {
            case 0://Delete teamLogo
                [teamLogoImageView setImage:nil];
                [teamLogoActionButton setTitle:[gUIStrings objectForKey:@"UI_FillTeamProfile_teamLogoButton_New"] forState:UIControlStateNormal];
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
        [teamLogoActionButton setTitle:nil forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (!teamLogoImageView.image) {
        [teamLogoActionButton setTitle:[gUIStrings objectForKey:@"UI_FillTeamProfile_teamLogoButton_New"] forState:UIControlStateNormal];
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
