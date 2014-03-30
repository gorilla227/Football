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
    UIViewController *blankView;
    CallFriendsMenu *callFriendsMenu;
    UIViewController *currentView;
    CGRect greyFrame;
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
    blankView = [[UIViewController alloc] init];
    [blankView.view setBackgroundColor:[UIColor clearColor]];
    [self addChildViewController:blankView];
    [callFriendsMenuView addSubview:blankView.view];
    currentView = blankView;
    
    callFriendsMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"CallFriendsMenu"];
    [self addChildViewController:callFriendsMenu];
    
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
    [self transitionFromViewController:currentView toViewController:callFriendsMenu duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    for (UIView *view in self.view.subviews) {
        if (![view isEqual:callFriendsMenuView]) {
            [view setUserInteractionEnabled:NO];
        }
    }
    currentView = callFriendsMenu;
    
    //Grey the background
    [delegate greyBackground:YES inFrame:greyFrame];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissCallFriendsMenu];
    [delegate greyBackground:NO inFrame:greyFrame];
}

-(void)dismissCallFriendsMenu
{
    if (currentView == callFriendsMenu) {
        [self transitionFromViewController:currentView toViewController:blankView duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
        for (UIView *view in self.view.subviews) {
            [view setUserInteractionEnabled:YES];
        }
        currentView = blankView;
    }
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
