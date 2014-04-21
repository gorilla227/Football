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
    UIView *accountIconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 34)];
    [accountIconImageView setFrame:CGRectMake(12, 7, 20, 20)];
    [accountIconView addSubview:accountIconImageView];
    [accountIconView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [accountField setLeftView:accountIconView];
    [accountField setLeftViewMode:UITextFieldViewModeAlways];

    UIImageView *passwordIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_textfield_title_pwd.png"]];
    UIView *passwordIconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 34)];
    [passwordIconImageView setFrame:CGRectMake(14.5, 7, 15, 20)];
    [passwordIconView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [passwordIconView addSubview:passwordIconImageView];
    [passwordField setLeftView:passwordIconView];
    [passwordField setLeftViewMode:UITextFieldViewModeAlways];
    
    [accountField.layer setBorderColor:kSoccerColor.CGColor];
    [accountField.layer setBorderWidth:1.0f];
    [accountField.layer setCornerRadius:3.0f];
    
    [passwordField.layer setBorderColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor];
    [passwordField.layer setBorderWidth:1.0f];
    [passwordField.layer setCornerRadius:3.0f];
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

-(void)loginWithUser:(NSData *)userData
{
    extern NSDictionary *myUserInfo;
    myUserInfo = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:nil];
    
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
//    [mainController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:mainController animated:YES completion:nil];
}

-(void)retrieveData:(NSData *)data forSelector:(SEL)selector
{
    if ([self canPerformAction:selector withSender:self]) {
        [self performSelectorOnMainThread:selector withObject:data waitUntilDone:YES];
        [self.parentViewController.view setUserInteractionEnabled:YES];
    }
}

-(IBAction)loginButtonOnClicked:(id)sender
{
    WebUtils *requestUserInfo = [[WebUtils alloc] initWithServerURL:def_serverURL andDelegate:self];
    [requestUserInfo requestData:[def_JSONSuffix_userInfo stringByAppendingString:@"1"] forSelector:@selector(loginWithUser:)];
//    [self.parentViewController.view setUserInteractionEnabled:NO];
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
