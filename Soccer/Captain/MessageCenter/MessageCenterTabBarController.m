//
//  MessageCenterTabBarController.m
//  Soccer
//
//  Created by Andy on 14-8-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenterTabBarController.h"
#import "MessageCenter.h"
#import "MessageCenter_Compose.h"

@interface MessageCenterTabBarController ()
@property IBOutlet UIBarButtonItem *composeButton;
@end

@implementation MessageCenterTabBarController{
    NSArray *messageTypes;
}
@synthesize composeButton;

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
    messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes_ForCaptain"];
    NSMutableArray *tabBarViewControllers = [NSMutableArray new];
    for (NSDictionary *boxInfo in messageTypes) {
        MessageCenter *messageCenter = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageCenter"];
        [messageCenter setTabBarItem:[[UITabBarItem alloc] initWithTitle:[boxInfo objectForKey:@"TabBarItemName"] image:[[UIImage imageNamed:[boxInfo objectForKey:@"TabBarItemImage"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:[messageTypes indexOfObject:boxInfo]]];
        [tabBarViewControllers addObject:messageCenter];
    }
    
    
    [self.tabBar setBarTintColor:def_navigationBar_background];
    [self setViewControllers:tabBarViewControllers];
    [composeButton setEnabled:gMyUserInfo.team];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
*/
@end
