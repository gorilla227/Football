//
//  Staring.m
//  Soccer
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Login.h"
@import CoreLocation;

@interface Login()
@property IBOutlet UITextField *accountField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UIButton *loginButton;
@property IBOutlet UIView *loginContentView;
@property IBOutlet UIView *loginAndRegisterView;
@property IBOutlet UIImageView *appLogoImageView;
@end

@implementation Login{
    JSONConnect *connection;
    CLLocationManager *locationManager;
}
@synthesize accountField, passwordField, loginButton, loginContentView, loginAndRegisterView, appLogoImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Get Settings
    NSArray *sandBoxPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    gSettingsFile = [[sandBoxPaths firstObject] stringByAppendingPathComponent:@"Setting.plist"];
    NSString *defaultSettingFile = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSDictionary *defaultSetting = [[NSDictionary alloc] initWithContentsOfFile:defaultSettingFile];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:gSettingsFile] || [[defaultSetting objectForKey:@"clearSettingWhileLaunch"] boolValue]) {
        [defaultSetting writeToFile:gSettingsFile atomically:YES];
    }
    
    gSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:gSettingsFile];
    if (![[gSettings objectForKey:@"isDebug"] isEqualToNumber:[defaultSetting objectForKey:@"isDebug"]]) {
        [gSettings setObject:[defaultSetting objectForKey:@"isDebug"] forKey:@"isDebug"];
        [gSettings writeToFile:gSettingsFile atomically:YES];
    }
    
    //Get UIStrings
    NSString *fileNameOfUIStrings = [[NSBundle mainBundle] pathForResource:@"UIStrings" ofType:@"plist"];
    gUIStrings = [NSDictionary dictionaryWithContentsOfFile:fileNameOfUIStrings];
    
    //Grant Location Authrization
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:(id)self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    //Set the background image
    [self.view.layer setContents:(__bridge id)bgImage];
    [self initialTextFields];
    [appLogoImageView setTransform:CGAffineTransformMakeTranslation(0, windowSize.height/10)];
    [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, loginAndRegisterView.bounds.size.height)];
    [loginAndRegisterView setAlpha:0];
    
    //Initial JSONConnection
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestAllStadiums];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    //Add observer for keyboardShowinng
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [appLogoImageView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [loginAndRegisterView setAlpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialTextFields {
    [accountField setPlaceholder:[gUIStrings objectForKey:@"UI_LoginViewAccountPH"]];
    [accountField initialLeftViewWithIconImage:@"TextFieldIcon_Account.png"];
    [accountField.layer setBorderColor:def_navigationBar_background.CGColor];
    [accountField.layer setBorderWidth:1.0f];
    
    [passwordField initialLeftViewWithIconImage:@"TextFieldIcon_Password.png"];
    [passwordField.layer setBorderColor:def_textFieldBorderColor.CGColor];
    [passwordField.layer setBorderWidth:1.0f];
}

- (void)receiveAllStadiums:(NSArray *)stadiums {
    gStadiums = stadiums;
    
    if ([[gSettings objectForKey:@"isRememberAccount"] boolValue] && [gSettings objectForKey:@"accountName"] && [gSettings objectForKey:@"passwordMD5"]) {
        [connection loginVerification:[gSettings objectForKey:@"accountName"] password:[gSettings objectForKey:@"passwordMD5"]];
    }
    else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8f];
        [appLogoImageView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [loginAndRegisterView setAlpha:1.0f];
        [UIView commitAnimations];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self dismissKeyboard];
}

- (IBAction)loginButtonOnClicked:(id)sender {
    [self dismissKeyboard];
    [connection loginVerification:accountField.text password:passwordField.text.MD5];
}

- (void)loginVerificationSuccessfully:(NSInteger)userId {
    if ([[gSettings objectForKey:@"isRememberAccount"] boolValue] && accountField.text.length && passwordField.text.length) {
        [gSettings setObject:accountField.text forKey:@"accountName"];
        [gSettings setObject:passwordField.text.MD5 forKey:@"passwordMD5"];
        [gSettings writeToFile:gSettingsFile atomically:YES];
    }
    
    [connection requestUserInfo:userId withTeam:YES withReference:nil];
}

- (void)loginVerificationFailed {
    UIAlertView *loginFailedAlertView = [[UIAlertView alloc] initWithTitle:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Title"]
                                                                   message:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Message"]
                                                                  delegate:self
                                                         cancelButtonTitle:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Cancel"] otherButtonTitles:nil];
    [loginFailedAlertView show];
    [appLogoImageView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [loginAndRegisterView setAlpha:1.0f];
}

- (void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference {
    gMyUserInfo = userInfo;
    [self enterMainScreen];
}

- (void)enterMainScreen {
    [accountField setText:nil];
    [passwordField setText:nil];
    
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Soccer" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:nil];
}

- (IBAction)registerButtonOnClicked:(id)sender {
    [self performSegueWithIdentifier:@"Register" sender:self];
}

- (IBAction)forgetPasswordButtonOnClicked:(id)sender {
//    UIViewController *targetViewController = [[UIStoryboard storyboardWithName:@"Soccer" bundle:nil] instantiateViewControllerWithIdentifier:@"Test"];
//    [self.navigationController pushViewController:targetViewController animated:YES];
}

//Location
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
    else if (status == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[gUIStrings objectForKey:@"UI_LocationDisableWarning_Title"] message:[gUIStrings objectForKey:@"UI_LocationDisableWarning_Message"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
        [alertView show];
    }
}

//DissmissKeyboard
- (void)dismissKeyboard {
    [accountField resignFirstResponder];
    [passwordField resignFirstResponder];
}

//Move view for keyboard
- (void)keyboardWillShow {
    CGFloat heightForViewShiftUp = MIN(loginAndRegisterView.bounds.size.height - loginContentView.bounds.size.height - def_keyboardHeight, 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    [loginAndRegisterView setTransform:CGAffineTransformTranslate(loginAndRegisterView.transform, 0, heightForViewShiftUp)];
    [UIView commitAnimations];
}

- (void)keyboardWillHide {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView commitAnimations];
}

//TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:accountField]) {
        [passwordField becomeFirstResponder];
    }
    else {
        [self loginButtonOnClicked:self];
    }
    return NO;
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
