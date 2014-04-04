//
//  Captain_MyMatches.m
//  Football
//
//  Created by Andy Xu on 14-4-4.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MyMatches.h"

@interface Captain_MyMatches ()

@end

@implementation Captain_MyMatches{
    Captain_MatchArrangement *matchArrangement;
    UIViewController *currentViewController;
    NSMutableDictionary *myTeamViewControllers;
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
    myTeamViewControllers = [[NSMutableDictionary alloc] init];
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController.restorationIdentifier isEqualToString:@"Captain_MatchArrangement"]) {
            matchArrangement = (Captain_MatchArrangement *)viewController;
        }
        [myTeamViewControllers setObject:viewController forKey:viewController.restorationIdentifier];
    }
    currentViewController = matchArrangement;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self switchSelectMenuView:@"Captain_MatchArrangement"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchSelectMenuView:(NSString *)selectedView
{
    UIViewController *targetViewController = [myTeamViewControllers objectForKey:selectedView];
    if ([myTeamViewControllers.allKeys containsObject:selectedView] && currentViewController != targetViewController) {
        [self transitionFromViewController:currentViewController toViewController:[myTeamViewControllers objectForKey:selectedView] duration:0.3f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished){
            currentViewController = targetViewController;
        }];
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
