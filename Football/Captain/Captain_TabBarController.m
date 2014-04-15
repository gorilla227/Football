//
//  Captain_TabBarController.m
//  Football
//
//  Created by Andy on 14-3-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_TabBarController.h"

@implementation Captain_TabBarController{
    NSInteger currentViewControllerIndex;
}
//@synthesize mainMenuDelegate;

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
    currentViewControllerIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger selectedItemIndex = [tabBar.items indexOfObject:item];
    if (currentViewControllerIndex != selectedItemIndex) {
//        [mainMenuDelegate changeRootMenuToIndex:selectedItemIndex];
        currentViewControllerIndex = selectedItemIndex;
    }
}

-(void)switchSelectMenuView:(NSString *)selectedView
{
    id<MenuSelected>delegate = (id)self.selectedViewController;
    [delegate switchSelectMenuView:selectedView];
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
