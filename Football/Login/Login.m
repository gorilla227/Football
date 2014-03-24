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

@implementation Login{
    Login_Content *loginContent;
    Register_Captain *registerCaptain;
    Register_Player *registerPlayer;
    UIViewController *currentViewController;
}
@synthesize roleSegment;
@synthesize contentView;

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
    loginContent = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginContent"];
    registerCaptain = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterCaptain"];
    registerPlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterPlayer"];
    [self addChildViewController:loginContent];
    [self addChildViewController:registerCaptain];
    [self addChildViewController:registerPlayer];
    [contentView addSubview:loginContent.view];
    currentViewController = loginContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentRegisterView
{
    switch (roleSegment.selectedSegmentIndex) {
        case 0:
            [self transitionFromViewController:currentViewController toViewController:registerCaptain duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
            currentViewController = registerCaptain;
            break;
        case 1:
            [self transitionFromViewController:currentViewController toViewController:registerPlayer duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
            currentViewController = registerPlayer;
        default:
            break;
    }
    [roleSegment setUserInteractionEnabled:NO];
}

-(void)presentLoginView
{
    [self transitionFromViewController:currentViewController toViewController:loginContent duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    currentViewController = loginContent;
    [roleSegment setUserInteractionEnabled:YES];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [loginContent dismissKeyboard];
//}

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
