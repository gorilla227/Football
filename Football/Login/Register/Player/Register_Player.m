//
//  Register_Player.m
//  Football
//
//  Created by Andy on 14-3-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Register_Player.h"

@interface Register_Player ()

@end

@implementation Register_Player{
    id<LoginAndRegisterView>delegate;
    NSArray *textFieldArray;
    UIDatePicker *datePicker;
    UIPickerView *placePicker;
    NSDictionary *pickerData;
    NSArray *provinces;
    NSArray *cities;
    NSString *selectedProvince;
    NSString *selectedCity;
}
@synthesize personalID, cellphoneNumber, qqNumber, birthday, activityRegion, password, registerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //Clear all fields
    for (UITextField *textField in textFieldArray) {
        [textField setText:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (id)self.parentViewController.parentViewController;
    textFieldArray = [[NSArray alloc] initWithObjects:personalID, cellphoneNumber, qqNumber, birthday, activityRegion, password, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:delegate selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:delegate selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    //Set Datepicker for Birthday(UITextField)
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [birthday setInputView:datePicker];
    [birthday setTintColor:[UIColor clearColor]];
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
    [activityRegion setInputView:placePicker];
    [activityRegion setTintColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonOnClicked:(id)sender
{
    [delegate presentLoginView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissKeyboard];
}

-(IBAction)changeTextFieldFocus:(id)sender
{
    NSInteger indexOfNextTextField = [textFieldArray indexOfObject:sender] + 1;
    if (indexOfNextTextField >= textFieldArray.count) {
        [self performSegueWithIdentifier:@"PlayerRegisterAdvance" sender:registerButton];
    }
    else {
        UIResponder *nextResponder = [textFieldArray objectAtIndex:indexOfNextTextField];
        [nextResponder becomeFirstResponder];
    }
}

-(void)dismissKeyboard
{
    for (UITextField *textField in textFieldArray) {
        [textField resignFirstResponder];
    }
}

#pragma DatePicker
-(void)finishDateEditing
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    [birthday setText:[dateFormatter stringFromDate:datePicker.date]];
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
    [activityRegion setText:[NSString stringWithFormat:@"%@ %@", selectedProvince, selectedCity]];
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
