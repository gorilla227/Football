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
    
    connection = [[JSONConnect alloc] initWithDelegate:self];
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
    UIImageView *accountIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_textfield_title_user.png"]];
    [accountIconImageView setFrame:CGRectMake(0, 0, 44, 34)];
    [accountIconImageView setContentMode:UIViewContentModeCenter];
    [accountIconImageView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [accountField setLeftView:accountIconImageView];
    [accountField setLeftViewMode:UITextFieldViewModeAlways];
    
    UIImageView *passwordIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_textfield_title_pwd.png"]];
    [passwordIconImageView setFrame:CGRectMake(0, 0, 44, 34)];
    [passwordIconImageView setContentMode:UIViewContentModeCenter];
    [passwordIconImageView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [passwordField setLeftView:passwordIconImageView];
    [passwordField setLeftViewMode:UITextFieldViewModeAlways];
    
    [accountField.layer setBorderColor:def_navigationBar_background.CGColor];
    [accountField.layer setBorderWidth:1.0f];
    [accountField.layer setCornerRadius:3.0f];
    
    [passwordField.layer setBorderColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor];
    [passwordField.layer setBorderWidth:1.0f];
    [passwordField.layer setCornerRadius:3.0f];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissKeyboard];
}

-(IBAction)loginButtonOnClicked:(id)sender
{
    [connection requestUserInfoById:[NSNumber numberWithInteger:1]];
    
    //    [self.parentViewController.view setUserInteractionEnabled:NO];
}

-(void)receiveUserInfo:(UserInfo *)userInfo
{
    gMyUserInfo = userInfo;
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:nil];
}

-(IBAction)registerButtonOnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"Register" sender:self];
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
