//
//  MessageCenterTabBarController.m
//  Football
//
//  Created by Andy on 14-8-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageCenterTabBarController.h"
#import "MessageCenter.h"

@interface MessageCenterTabBarController ()

@end

@implementation MessageCenterTabBarController{
    NSArray *messageTypes;
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
    messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes"];
    NSMutableArray *tabBarViewControllers = [NSMutableArray new];
    for (NSDictionary *messageType in messageTypes) {
        MessageCenter *messageCenter = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageCenter"];
        [messageCenter setTabBarItem:[[UITabBarItem alloc] initWithTitle:[messageType objectForKey:@"TypeName"] image:[[UIImage imageNamed:[messageType objectForKey:@"TypeIcon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:[messageTypes indexOfObject:messageType]]];
        [tabBarViewControllers addObject:messageCenter];
    }
    [self.tabBar setBarTintColor:def_navigationBar_background];
//    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self setViewControllers:tabBarViewControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
