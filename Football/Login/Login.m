//
//  Login.m
//  Football
//
//  Created by Andy on 14-3-16.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Login.h"

@interface Login ()

@end

@implementation Login{
    Login_Content *loginContent;
    UINavigationController *registerCaptain;
    UINavigationController *registerPlayer;
    UIViewController *currentViewController;
    CGPoint contentViewCenter_ShowKeyboard;
    CGPoint contentViewCenter_HideKeyboard;
    CALayer *greyBackgroundLayer;
}
@synthesize roleSegment;
@synthesize contentView;

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
    registerCaptain = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterCaptain"];
    registerPlayer = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterPlayer"];
    [self addChildViewController:registerCaptain];
    [self addChildViewController:registerPlayer];
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController.restorationIdentifier isEqualToString: @"LoginContent"]) {
            loginContent = (Login_Content *)viewController;
        }
    }
    currentViewController = loginContent;
    
    contentViewCenter_ShowKeyboard = CGPointMake(contentView.center.x, contentView.center.y - 195);
    contentViewCenter_HideKeyboard = contentView.center;
    
    //Set layer for grey background
    greyBackgroundLayer = [CALayer layer];
    [greyBackgroundLayer setBackgroundColor:[UIColor blackColor].CGColor];
    [greyBackgroundLayer setOpacity:0.5f];
    
    //Set the background image
    UIImage *backgroundImage = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:backgroundImage]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentRegisterView
{
    switch (roleSegment.selectedSegmentIndex) {
        case 0:
            [self transitionFromViewController:currentViewController toViewController:registerCaptain duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
            currentViewController = registerCaptain;
            break;
        case 1:
            [self transitionFromViewController:currentViewController toViewController:registerPlayer duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
            currentViewController = registerPlayer;
        default:
            break;
    }
    [roleSegment setUserInteractionEnabled:NO];
}

-(void)presentLoginView
{
    [self transitionFromViewController:currentViewController toViewController:loginContent duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    currentViewController = loginContent;
    [roleSegment setUserInteractionEnabled:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    id<DismissKeyboard>delegate;
    if (currentViewController == loginContent) {
        delegate = (id)currentViewController;
    }
    [delegate dismissKeyboard];
}

-(void)keyboardWillShow
{
    //Animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [contentView setCenter:contentViewCenter_ShowKeyboard];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    //Animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [contentView setCenter:contentViewCenter_HideKeyboard];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [UIView commitAnimations];
}

-(void)greyBackground:(BOOL)isCallFriendsMenuShowed inFrame:(CGRect)frame
{
    [greyBackgroundLayer setFrame:frame];
    if (isCallFriendsMenuShowed) {
        [self.view.layer addSublayer:greyBackgroundLayer];
    }
    else {
        [greyBackgroundLayer removeFromSuperlayer];
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
