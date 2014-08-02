//
//  Soccer_BaseNavigationController.m
//  Football
//
//  Created by Andy on 14-4-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Soccer_BaseNavigationController.h"

@interface Soccer_BaseNavigationController ()
@property IBOutlet UIBarButtonItem *menuButton;
@property IBOutlet MessageBarButtonItem *messageButton;
@end

@implementation Soccer_BaseNavigationController{
    MainMenu *mainMenu;
    UIView *contentView;
    UIActivityIndicatorView *busyIndicator;
}
@synthesize menuButton, messageButton;

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
    //Set the background image
    UIImage *backgroundImage = [UIImage imageNamed:@"soccer_grass_bg@2x.png"];
    [self.view.layer setContents:(id)backgroundImage.CGImage];

    contentView = self.view.subviews.firstObject;
    mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"Captain_MainMenu"];
    [mainMenu setDelegateOfMenuAppearance:self];
    [mainMenu setDelegateOfViewSwitch:self];
    [self.view addSubview:mainMenu.view];
    
    //Set Menu button and Message button;
    [messageButton setDelegate:self];
    [messageButton initBadgeView];
    
    //Set busyIndicator
    busyIndicator = [[UIActivityIndicatorView alloc] init];
    [busyIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [busyIndicator setColor:[UIColor blackColor]];
    [busyIndicator setCenter:self.view.center];
    [busyIndicator setHidesWhenStopped:YES];
    [self.view addSubview:busyIndicator];
    
    //Load the initial view
    [mainMenu tableView:mainMenu.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    [self menuSwitch];
}

-(void)logout
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)menuSwitch
{
    [UIView beginAnimations:@"ShowMenu" context:nil];
    [UIView setAnimationDuration:0.3f];
    CGAffineTransform showMenu = CGAffineTransformMakeTranslation(mainMenu.view.bounds.size.width, 0);
    if (CGAffineTransformEqualToTransform(mainMenu.view.transform, showMenu)) {
        //Hide menu
        for (UIView *view in self.visibleViewController.view.subviews) {
            [view setTransform:CGAffineTransformMakeTranslation(0, 0)];
        }
        [self.toolbar setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [self.visibleViewController.view setUserInteractionEnabled:YES];
        [mainMenu.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [mainMenu.view setUserInteractionEnabled:NO];
    }
    else {
        //Show menu
        for (UIView *view in self.visibleViewController.view.subviews) {
            [view setTransform:showMenu];
        }
        [self.toolbar setTransform:showMenu];
        [self.visibleViewController.view setUserInteractionEnabled:NO];
        [mainMenu.view setTransform:showMenu];
        [mainMenu.view setUserInteractionEnabled:YES];
        [mainMenu resetMenuFolder];
    }
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self menuSwitch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchSelectMenuView:(NSString *)selectedView
{
    if(![self.visibleViewController.restorationIdentifier isEqualToString:selectedView]) {
        UIViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:selectedView];
        [targetViewController.navigationItem setLeftBarButtonItem:menuButton];
        [targetViewController.navigationItem setRightBarButtonItem:messageButton];
        [self setViewControllers:@[targetViewController] animated:YES];
    }
}

-(IBAction)menuButtonOnClicked:(id)sender
{
    [self menuSwitch];
}

-(void)messageButtonOnClicked
{
    NSLog(@"MessageButtonClicked!");
}

//BusyIndicatorDelegate
-(void)lockView
{
    [self.view.window setUserInteractionEnabled:NO];
    [busyIndicator startAnimating];
}

-(void)unlockView
{
    [self.view.window setUserInteractionEnabled:YES];
    [busyIndicator stopAnimating];
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
