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
@property IBOutlet UIImageView *teamIconImageView;
@property IBOutlet UIButton *selectTeamIconButton;
@property IBOutlet UIButton *clearTeamIconButton;
@property IBOutlet UITextField *teamNameTextField;
@property IBOutlet UITextField *activityRegionTextField;
@property IBOutlet UITextField *homeStadium;
@property IBOutlet UITextView *sloganTextView;
@end

@implementation FillTeamProfile{
    UIPickerView *placePicker;
    NSDictionary *pickerData;
    NSArray *provinces;
    NSArray *cities;
    NSString *selectedProvince;
    NSString *selectedCity;
    NSArray *textFieldArray;
}
@synthesize saveBar, teamIconImageView, selectTeamIconButton, clearTeamIconButton, teamNameTextField, activityRegionTextField, homeStadium, sloganTextView;

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
    textFieldArray = @[teamNameTextField, activityRegionTextField, homeStadium, sloganTextView];
    
    //Set the playerIcon related controls
    [teamIconImageView.layer setCornerRadius:40.0f];
    [teamIconImageView.layer setMasksToBounds:YES];
    [teamIconImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamIconImageView.layer setBorderWidth:1.0f];
    [clearTeamIconButton setHidden:!teamIconImageView.image];
    
    //Set activityregion Picker
    NSString *file = [[NSBundle mainBundle] pathForResource:@"ActivityRegion" ofType:@"plist"];
    pickerData = [[NSDictionary alloc] initWithContentsOfFile:file];
    provinces = [pickerData allKeys];
    selectedProvince = [provinces firstObject];
    cities = [pickerData objectForKey:selectedProvince];
    selectedCity = [cities firstObject];
    placePicker = [[UIPickerView alloc] init];
    [placePicker setDataSource:self];
    [placePicker setDelegate:self];
    [activityRegionTextField setInputView:placePicker];
    [activityRegionTextField setTintColor:[UIColor clearColor]];
    
    //Set sloganTextView border style consistent with TextField
    [sloganTextView.layer setBorderColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1].CGColor];
    [sloganTextView.layer setBorderWidth:0.6f];
    [sloganTextView.layer setCornerRadius:6.0f];
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

-(IBAction)selectTeamIconButtonOnClicked:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    [imagePicker.navigationBar setTitleTextAttributes:self.navigationController.navigationBar.titleTextAttributes];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *imageType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([imageType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [teamIconImageView setImage:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [clearTeamIconButton setHidden:!image];
    }
}

-(IBAction)clearTeamIconButtonOnClicked:(id)sender
{
    [teamIconImageView setImage:nil];
    [clearTeamIconButton setHidden:YES];
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

#pragma ActivityRegion Picker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger number = 0;
    switch (component) {
        case 0:
            number = provinces.count;
            break;
        case 1:
            number = cities.count;
            break;
        default:
            break;
    }
    return number;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    switch (component) {
        case 0:
            title = [provinces objectAtIndex:row];
            break;
        case 1:
            title = [cities objectAtIndex:row];
            break;
        default:
            break;
    }
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            selectedProvince = [provinces objectAtIndex:row];
            cities = [pickerData objectForKey:selectedProvince];
            selectedCity = [cities firstObject];
            [placePicker reloadComponent:1];
            [placePicker selectRow:0 inComponent:1 animated:YES];
            break;
        case 1:
            selectedCity = [cities objectAtIndex:row];
            break;
        default:
            break;
    }
    [activityRegionTextField setText:[NSString stringWithFormat:@"%@ %@", selectedProvince, selectedCity]];
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
