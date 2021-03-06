//
//  Login_Content.m
//  Football
//
//  Created by Andy on 14-3-22.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Login_Content.h"

#define kSoccerColor [UIColor colorWithRed:59/255.0 green:175/255.0 blue:218/255.0 alpha:1]

@interface Login_Content ()

@end

@implementation Login_Content{
    Register_Captain *registerCaptain;
    id<LoginAndRegisterView>delegate;
    NSArray *textFieldArray;
    JSONConnect *connection;
}
@synthesize accountField;
@synthesize passwordField;
@synthesize registerButton;
@synthesize loginButton;
@synthesize qqAccountButton;
@synthesize sinaAccountButton;

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
    textFieldArray = [[NSArray alloc] initWithObjects:accountField, passwordField, nil];
    
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
    
    [accountField.layer setBorderColor:kSoccerColor.CGColor];
    [accountField.layer setBorderWidth:1.0f];
    [accountField.layer setCornerRadius:3.0f];
    
    [passwordField.layer setBorderColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor];
    [passwordField.layer setBorderWidth:1.0f];
    [passwordField.layer setCornerRadius:3.0f];
    
    connection = [[JSONConnect alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeTextFieldFocus:(id)sender
{
    NSInteger indexOfNextTextField = [textFieldArray indexOfObject:sender] + 1;
    if (indexOfNextTextField >= textFieldArray.count) {
        [self performSelector:@selector(loginButtonOnClicked:) withObject:loginButton];
    }
    else {
        UIResponder *nextResponder = [textFieldArray objectAtIndex:indexOfNextTextField];
        [nextResponder becomeFirstResponder];
    }
}

-(void)dismissKeyboard
{
    [accountField resignFirstResponder];
    [passwordField resignFirstResponder];
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
    myUserInfo = userInfo;
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:nil];
}

-(IBAction)registerButtonOnClicked:(id)sender
{
    delegate = (id)self.parentViewController;
    [delegate presentRegisterView];
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
