//
//  Captain_MyTeam.m
//  Football
//
//  Created by Andy Xu on 14-4-4.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MyTeam.h"

@interface Captain_MyTeam ()

@end

@implementation Captain_MyTeam{
    Captain_MyPlayers *myPlayers;
    Captain_NewPlayer *newPlayer;
    Captain_TeamProfile *teamProfile;
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

    newPlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"Captain_NewPlayer"];
    [self addChildViewController:newPlayer];
    teamProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"Captain_TeamProfile"];
    [self addChildViewController:teamProfile];
    
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController.restorationIdentifier isEqualToString:@"Captain_MyPlayers"]) {
            myPlayers = (Captain_MyPlayers *)viewController;
        }
        [myTeamViewControllers setObject:viewController forKey:viewController.restorationIdentifier];
    }
    currentViewController = myPlayers;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self switchSelectMenuView:@"Captain_MyPlayers"];
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
