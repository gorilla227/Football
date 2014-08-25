//
//  MessageCenterTabBarController.m
//  Football
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
    messageTypes = [gUIStrings objectForKey:@"UI_MessageTypes"];
    NSMutableArray *tabBarViewControllers = [NSMutableArray new];
    for (NSDictionary *messageType in messageTypes) {
        MessageCenter *messageCenter = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageCenter"];
        [messageCenter setTabBarItem:[[UITabBarItem alloc] initWithTitle:[messageType objectForKey:@"TypeName"] image:[[UIImage imageNamed:[messageType objectForKey:@"TypeIcon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] tag:[messageTypes indexOfObject:messageType]]];
        [tabBarViewControllers addObject:messageCenter];
    }
    [self.tabBar setBarTintColor:def_navigationBar_background];
    [self setViewControllers:tabBarViewControllers];
    [composeButton setEnabled:gMyUserInfo.team];
    
    [self refreshUnreadMessageAmount];
    NSTimer *timer = [NSTimer timerWithTimeInterval:[[gSettings objectForKey:@"refreshUnreadMessageAmountDuration"] integerValue] target:self selector:@selector(refreshUnreadMessageAmount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadMessageAmount) name:@"MessageStatusUpdated" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUnreadMessageAmount;
{
    for (NSDictionary *messageType in messageTypes) {
        NSArray *amountArray = [gUnreadMessageAmount objectsForKeys:[[messageType objectForKey:@"Subtypes"] allKeys] notFoundMarker:[NSNull null]];
        NSNumber *amount = [amountArray valueForKeyPath:@"@sum.self"];
        NSString *badgeString;
        if (amount.integerValue == 0) {
            badgeString = nil;
        }
        else if (amount.integerValue > 10) {
            badgeString = @"10+";
        }
        else {
            badgeString = [NSString stringWithFormat:@"%@", amount];
        }
        
        UIViewController *tabController = [self.viewControllers objectAtIndex:[messageTypes indexOfObject:messageType]];
        [tabController.tabBarItem setBadgeValue:badgeString];
    }
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
*/
@end
