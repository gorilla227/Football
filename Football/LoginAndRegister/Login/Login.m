//
//  Staring.m
//  Football
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Login.h"
@interface Login()
@property IBOutlet UITextField *accountField;
@property IBOutlet UITextField *passwordField;
@property IBOutlet UIButton *loginButton;
@property IBOutlet UIView *loginContentView;
@property IBOutlet UIView *loginAndRegisterView;
@end

@implementation Login{
    JSONConnect *connection;
}
@synthesize accountField, passwordField, loginButton, loginContentView, loginAndRegisterView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Set the background image
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self initialTextFields];
    
    //Initial JSONConnection
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    //Add observer for keyboardShowinng
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialTextFields
{
    [accountField setPlaceholder:[gUIStrings objectForKey:@"UI_LoginViewAccountPH"]];
    [accountField initialLeftViewWithIconImage:@"TextFieldIcon_Account.png"];
    [accountField.layer setBorderColor:def_navigationBar_background.CGColor];
    [accountField.layer setBorderWidth:1.0f];
    
    [passwordField initialLeftViewWithIconImage:@"TextFieldIcon_Password.png"];
    [passwordField.layer setBorderColor:def_textFieldBorderColor.CGColor];
    [passwordField.layer setBorderWidth:1.0f];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissKeyboard];
}

-(IBAction)loginButtonOnClicked:(id)sender
{
    [self dismissKeyboard];
    [connection loginVerification:accountField.text password:passwordField.text.MD5];
}

-(void)loginVerificationSuccessfully:(NSInteger)userId
{
    [connection requestUserInfo:userId withTeam:YES];
}

-(void)loginVerificationFailed
{
    UIAlertView *loginFailedAlertView = [[UIAlertView alloc] initWithTitle:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Title"]
                                                                   message:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Message"]
                                                                  delegate:self
                                                         cancelButtonTitle:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Cancel"] otherButtonTitles:nil];
    [loginFailedAlertView show];
}

-(void)receiveUserInfo:(UserInfo *)userInfo
{
    gMyUserInfo = userInfo;
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Soccer" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:nil];
}

-(IBAction)registerButtonOnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"Register" sender:self];
}

-(IBAction)forgetPasswordButtonOnClicked:(id)sender
{
//    [connection loginVerification:@"18611542707" password:@"123456"];
//    UIViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FillPlayerProfile"];
    UIViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FindTeam"];
    [self.navigationController pushViewController:targetViewController animated:YES];
}
//DissmissKeyboard
-(void)dismissKeyboard
{
    [accountField resignFirstResponder];
    [passwordField resignFirstResponder];
}

//Move view for keyboard
-(void)keyboardWillShow
{
    CGFloat heightForViewShiftUp = loginAndRegisterView.bounds.size.height - loginContentView.bounds.size.height - def_keyboardHeight;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, heightForViewShiftUp)];
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView commitAnimations];
}

//TextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:accountField]) {
        [passwordField becomeFirstResponder];
    }
    else {
        [self loginButtonOnClicked:self];
    }
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
