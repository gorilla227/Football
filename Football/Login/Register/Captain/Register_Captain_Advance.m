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
    NSString *callFriendsMenuListFile = [[NSBundle mainBundle] pathForResource:@"ActionSheetMenu" ofType:@"plist"];
    callFriendsMenuList = [[[[NSDictionary alloc] initWithContentsOfFile:callFriendsMenuListFile] objectForKey:@"CallFriendsMenu"] objectForKey:@"MenuList"];
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
    for (NSDictionary *menuItem in callFriendsMenuList) {
        [callFriendsMenu addButtonWithTitle:[menuItem objectForKey:@"Title"]];
        [[callFriendsMenu.subviews lastObject] setImage:[UIImage imageNamed:[menuItem objectForKey:@"Icon"]] forState:UIControlStateNormal];
    }
    [callFriendsMenu setCancelButtonIndex:[callFriendsMenu addButtonWithTitle:@"取消"]];
    [callFriendsMenu showInView:self.parentViewController.parentViewController.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < callFriendsMenuList.count) {
        NSLog(@"%@", [[callFriendsMenuList objectAtIndex:buttonIndex] objectForKey:@"Title"]);
    }
    else {
        NSLog(@"取消");
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