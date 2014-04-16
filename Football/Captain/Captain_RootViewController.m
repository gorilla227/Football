//
//  Captain_RootViewController.m
//  Football
//
//  Created by Andy on 14-3-15.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_RootViewController.h"

@implementation Captain_RootViewController{
    Captain_MainMenu *mainMenu;
    Captain_MatchArrangement *matchArrangement;
    CGPoint mainView_menuShowed;
    CGPoint mainView_menuHidden;
    CGPoint mainMenu_menuShowed;
    CGPoint mainMenu_menuHidden;
}
@synthesize mainView;
@synthesize mainMenuView;

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
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController.restorationIdentifier  isEqual: @"Captain_MainMenu"]) {
            mainMenu = (Captain_MainMenu *)viewController;
        }
        else if ([viewController.restorationIdentifier isEqual: @"Captain_MatchArrangement"]) {
            matchArrangement = (Captain_MatchArrangement *)viewController;
        }
    }
//    [tabBar setMainMenuDelegate:mainMenu];

    mainView_menuHidden = mainView.center;
    mainView_menuShowed = CGPointMake(mainView.center.x + mainMenuView.frame.size.width, mainView.center.y);
    mainMenu_menuShowed = mainMenuView.center;
    mainMenu_menuHidden = CGPointMake(mainMenuView.center.x - mainMenuView.frame.size.width, mainMenuView.center.y);
    [mainMenuView setCenter:mainMenu_menuHidden];
    
    //Set the background image
    UIImage *backgroundImage = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:backgroundImage]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (CGPointEqualToPoint(mainView.center, mainView_menuShowed)) {
        [self menuSwitch:NO];
    }
}

-(IBAction)menuOnClicked:(id)sender
{
    [self menuSwitch:CGPointEqualToPoint(mainView.center, mainView_menuHidden)];
}

-(void)menuSwitch:(BOOL)showMenu
{
    if (showMenu) {
        [UIView beginAnimations:@"showMenu" context:nil];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:mainView cache:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:mainMenuView cache:YES];
        [mainView setCenter:mainView_menuShowed];
        [mainMenuView setCenter:mainMenu_menuShowed];
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:@"hideMenu" context:nil];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:mainView cache:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:mainMenuView cache:YES];
        [mainView setCenter:mainView_menuHidden];
        [mainMenuView setCenter:mainMenu_menuHidden];
        [UIView commitAnimations];
    }
    [mainView setUserInteractionEnabled:!showMenu];
}

-(void)switchSelectMenuView:(NSString *)selectedView
{
//    id<SwitchSelectedMenuView>delegate = (id)tabBar;
//    [delegate switchSelectMenuView:selectedView];
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
