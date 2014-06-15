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
@property IBOutlet UIButton *selectPlayerIconButton;
@property IBOutlet UITextField *nickNameTextField;
@property IBOutlet UITextField *qqTextField;
@property IBOutlet UITextField *birthdateTextField;
@property IBOutlet UITextField *activityRegionTextField;
@property IBOutlet UIButton *clearPlayerIconButton;
@property IBOutlet UITextField *accountNameTextField;
@property IBOutlet UITextField *legalNameTextField;
@property IBOutlet UITextField *phoneNumberTextField;
@end

@implementation FillPlayerProfile{
    UIDatePicker *datePicker;
    UIPickerView *placePicker;
    NSDictionary *pickerData;
    NSArray *provinces;
    NSArray *cities;
    NSString *selectedProvince;
    NSString *selectedCity;
    NSArray *textFieldArray;
}
@synthesize saveBar, playerIconImageView, selectPlayerIconButton, nickNameTextField, qqTextField, birthdateTextField, activityRegionTextField, clearPlayerIconButton, accountNameTextField, legalNameTextField, phoneNumberTextField;

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
    textFieldArray = @[accountNameTextField, legalNameTextField, nickNameTextField, phoneNumberTextField, qqTextField, birthdateTextField, activityRegionTextField];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    //Set the playerIcon related controls
    [playerIconImageView.layer setCornerRadius:40.0f];
    [playerIconImageView.layer setMasksToBounds:YES];
    [playerIconImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [playerIconImageView.layer setBorderWidth:1.0f];
    [clearPlayerIconButton setHidden:!playerIconImageView.image];
    
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
        [playerIconImageView setImage:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [clearPlayerIconButton setHidden:!image];
    }
}

-(IBAction)clearPlayerIconButtonOnClicked:(id)sender
{
    [playerIconImageView setImage:nil];
    [clearPlayerIconButton setHidden:YES];
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
//    NSInteger indexOfNextTextField = [textFieldArray indexOfObject:textField] + 1;
//    if (indexOfNextTextField >= textFieldArray.count) {
//        for (UITextField *eachTextField in textFieldArray) {
//            if (![eachTextField hasText]) {
//                [eachTextField becomeFirstResponder];
//                return NO;
//            }
//        }
//        [textField resignFirstResponder];
//    }
//    else {
//        UIResponder *nextResponder = [textFieldArray objectAtIndex:indexOfNextTextField];
//        [nextResponder becomeFirstResponder];
//    }
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
