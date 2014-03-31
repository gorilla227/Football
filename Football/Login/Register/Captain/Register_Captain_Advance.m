//
//  Register_Captain_Advance.m
//  Football
//
//  Created by Andy on 14-3-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Register_Captain_Advance.h"

@interface Register_Captain_Advance ()

@end

@implementation Register_Captain_Advance{
    id<LoginAndRegisterView>delegate;
    CallFriendsMenu *callFriendsMenu;
    CGRect greyFrame;
    CGPoint callFriendsMenu_menuShowed;
    CGPoint callFriendsMenu_menuHidden;
}
@synthesize callFriendsMenuView;

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
    delegate = (id)self.parentViewController.parentViewController;
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController.restorationIdentifier isEqualToString:@"CallFriendsMenu"]) {
            callFriendsMenu = (CallFriendsMenu *)viewController;
        }
    }
    callFriendsMenu_menuShowed = callFriendsMenuView.center;
    callFriendsMenu_menuHidden = CGPointMake(callFriendsMenuView.center.x, callFriendsMenuView.center.y + callFriendsMenuView.frame.size.height);
    [callFriendsMenuView setCenter:callFriendsMenu_menuHidden];
    
    greyFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - callFriendsMenuView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonOnClicked:(id)sender
{
    [delegate presentLoginView];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(IBAction)callFriendsButtonOnClicked:(id)sender
{
    [UIView beginAnimations:@"showMenu" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:callFriendsMenuView cache:YES];
    [callFriendsMenuView setCenter:callFriendsMenu_menuShowed];
    [UIView commitAnimations];
    
    //Grey the background
    [delegate greyBackground:YES inFrame:greyFrame];
    
    for (UIView *view in self.view.subviews) {
        [view setUserInteractionEnabled:(view == callFriendsMenuView)];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissCallFriendsMenu];
}

-(void)dismissCallFriendsMenu
{
    [UIView beginAnimations:@"hideMenu" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:callFriendsMenuView cache:YES];
    [callFriendsMenuView setCenter:callFriendsMenu_menuHidden];
    [UIView commitAnimations];
    for (UIView *view in self.view.subviews) {
        [view setUserInteractionEnabled:YES];
    }
    [delegate greyBackground:NO inFrame:greyFrame];
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