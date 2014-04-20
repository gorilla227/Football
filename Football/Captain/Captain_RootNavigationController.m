//
//  Captain_RootNavigationController.m
//  Football
//
//  Created by Andy on 14-4-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_RootNavigationController.h"

@interface Captain_RootNavigationController ()

@end

@implementation Captain_RootNavigationController{
    Captain_MainMenu *mainMenu;
    UIView *contentView;
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
    //Set the background image
    UIImage *backgroundImage = [UIImage imageNamed:@"soccer_grass_bg@2x.png"];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:backgroundImage]];

    contentView = self.view.subviews.firstObject;
    mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"Captain_MainMenu"];
    [mainMenu setDelegateOfMenuAppearance:self];
    [mainMenu setDelegateOfViewSwitch:self];
    [self.view addSubview:mainMenu.view];
}

-(void)menuSwitch
{
    [UIView beginAnimations:@"ShowMenu" context:nil];
    [UIView setAnimationDuration:0.3f];
    CGAffineTransform showMenu = CGAffineTransformMakeTranslation(124, 0);
    if (CGAffineTransformEqualToTransform(mainMenu.view.transform, showMenu)) {
        for (UIView *view in self.view.subviews) {
            [view setTransform:CGAffineTransformMakeTranslation(0, 0)];
            [view setUserInteractionEnabled:view != mainMenu.view];
        }
    }
    else {
        for (UIView *view in self.view.subviews) {
            [view setTransform:showMenu];
            [view setUserInteractionEnabled:view == mainMenu.view];
        }
    }
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGAffineTransform showMenu = CGAffineTransformMakeTranslation(124, 0);
    if (CGAffineTransformEqualToTransform(mainMenu.view.transform, showMenu)) {
        [self menuSwitch];
    }
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
        [self setViewControllers:@[targetViewController] animated:YES];
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
