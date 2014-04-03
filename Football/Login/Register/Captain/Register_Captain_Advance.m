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
    NSArray *callFriendsMenuList;
}

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
    NSString *callFriendsMenuListFile = [[NSBundle mainBundle] pathForResource:@"CallFriendsMenu" ofType:@"plist"];
    callFriendsMenuList = [[NSArray alloc] initWithContentsOfFile:callFriendsMenuListFile];
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
    UIActionSheet *callFriendsMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *menuItem in callFriendsMenuList) {
        [callFriendsMenu addButtonWithTitle:menuItem];
    }
    [callFriendsMenu setCancelButtonIndex:[callFriendsMenu addButtonWithTitle:@"取消"]];
    [callFriendsMenu showInView:self.parentViewController.parentViewController.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", [callFriendsMenuList objectAtIndex:buttonIndex]);
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