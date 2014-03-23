//
//  Login.m
//  Football
//
//  Created by Andy on 14-3-16.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Login.h"

@interface Login ()

@end

@implementation Login
@synthesize roleSegment;
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
    UIImage *accountIcon = [UIImage imageNamed:@"LoginAccountIcon.jpg"];
    UIImageView *accountIconView = [[UIImageView alloc] initWithImage:accountIcon];
    [accountField setLeftView:accountIconView];
    [accountField setLeftViewMode:UITextFieldViewModeAlways];
    UIImage *passwordIcon = [UIImage imageNamed:@"PasswordIcon.jpg"];
    UIImageView *passwordIconView = [[UIImageView alloc] initWithImage:passwordIcon];
    [passwordField setLeftView:passwordIconView];
    [passwordField setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [accountField resignFirstResponder];
    [passwordField resignFirstResponder];
}

-(IBAction)focusToPasswordTextField:(id)sender
{
    [passwordField becomeFirstResponder];
}

-(IBAction)loginButtonOnClicked:(id)sender
{
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:nil];
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
