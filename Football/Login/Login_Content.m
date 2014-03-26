//
//  Login_Content.m
//  Football
//
//  Created by Andy on 14-3-22.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Login_Content.h"

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
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [mainController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
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
