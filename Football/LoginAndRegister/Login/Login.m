//
//  Login.m
//  Football
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Login.h"

@implementation Login{
    JSONConnect *connection;
}
@synthesize accountField, passwordField, registerButton, loginButton, qqAccountButton, sinaAccountButton, roleSegment, loginContentView;

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
    
    connection = [[JSONConnect alloc] initWithDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    //Add observer for keyboardShowinng
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftUpViewForKeyboardShowing) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreViewForKeyboardHiding) name:UIKeyboardWillHideNotification object:nil];
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

-(IBAction)loginButtonOnClicked:(id)sender
{
    [connection requestUserInfoById:[NSNumber numberWithInteger:1]];
    
//    [self.parentViewController.view setUserInteractionEnabled:NO];
}

-(void)receiveUserInfo:(UserInfo *)userInfo
{
    myUserInfo = userInfo;
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:nil];
}

-(IBAction)registerButtonOnClicked:(id)sender
{
    [self dismissKeyboard];
    switch (roleSegment.selectedSegmentIndex) {
        case 0:
            [self performSegueWithIdentifier:@"Register_Captain" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"Register_Player" sender:self];
            break;
        default:
            break;
    }
}

//Protocol DissmissKeyboard
-(void)dismissKeyboard
{
    [accountField resignFirstResponder];
    [passwordField resignFirstResponder];
}

//ShiftUp/Restore view for keyboard
-(void)shiftUpViewForKeyboardShowing
{
    id<MoveTextFieldForKeyboardShowing>delegate = (id)self.navigationController.parentViewController;
    CGFloat keyboardShiftHeight = self.view.bounds.size.height - loginContentView.bounds.size.height - def_keyboardHeight;
    [delegate keyboardWillShow:CGAffineTransformMakeTranslation(0, keyboardShiftHeight)];
}

-(void)restoreViewForKeyboardHiding
{
    id<MoveTextFieldForKeyboardShowing>delegate = (id)self.navigationController.parentViewController;
    [delegate keyboardWillHide];
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
