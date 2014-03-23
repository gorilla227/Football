//
//  VC_Login.m
//  Football
//
//  Created by Andy on 14-3-9.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "VC_Login.h"

@interface VC_Login ()

@end

@implementation VC_Login{
    NSString *settingFile;
    NSMutableDictionary *setting;
}
@synthesize accountName;
@synthesize password;
@synthesize rememberSwitch;
@synthesize loginButton;
@synthesize registerButton;
@synthesize forgetPasswordButton;

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
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    settingFile = [filePath stringByAppendingPathComponent:@"Setting.plist"];
    setting = [[NSMutableDictionary alloc] initWithContentsOfFile:settingFile];
    if (!setting) {
        settingFile = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
        setting = [[NSMutableDictionary alloc] initWithContentsOfFile:settingFile];
        [setting writeToFile:[filePath stringByAppendingString:@"Setting.plist"] atomically:YES];
    }
    [rememberSwitch setOn:[[setting objectForKey:@"isRemember"] boolValue]];
    if (rememberSwitch.on) {
        [accountName setText:[setting objectForKey:@"accountName"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginButtonOnClicked:(id)sender
{
    //Save the account
    [setting setObject:accountName.text forKey:@"accountName"];
    [setting setObject:[NSNumber numberWithBool:rememberSwitch.on] forKey:@"isRemember"];
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain_New" bundle:nil];
    UITabBarController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:nil];
}

-(IBAction)changeLoginButtonEnabled:(id)sender
{
    [loginButton setEnabled:(accountName.hasText && password.hasText)];
}

-(IBAction)focusToPasswordTextField:(id)sender
{
    [password becomeFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [accountName resignFirstResponder];
    [password resignFirstResponder];
}
@end
