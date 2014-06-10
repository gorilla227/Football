//
//  RegisterCompleted.m
//  Football
//
//  Created by Andy on 14-6-9.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "RegisterCompleted.h"

@interface RegisterCompleted ()

@end

@implementation RegisterCompleted{
    JSONConnect *connection;
}
@synthesize roleCode;

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    
    switch (roleCode) {
        case 0:
            [self.navigationItem setTitle:def_registerViewTitle_Captain];
            break;
        case 1:
            [self.navigationItem setTitle:def_registerViewTitle_Player];
            break;
        default:
            break;
    }
    
    connection = [[JSONConnect alloc] initWithDelegate:self];
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

-(IBAction)cancelButtonOnClicked:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)receiveUserInfo:(UserInfo *)userInfo
{
    myUserInfo = userInfo;
    UIViewController *fillAdditional = [self.storyboard instantiateViewControllerWithIdentifier:@"FillAdditionalNav"];
    [self presentViewController:fillAdditional animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
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
