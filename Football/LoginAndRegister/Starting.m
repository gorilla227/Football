//
//  Staring.m
//  Football
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Starting.h"

@implementation Starting
@synthesize loginAndRegisterView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UINavigationController *navController = self.childViewControllers.firstObject;
    id<DismissKeyboard>delegate = (id)navController.visibleViewController;
    if ([delegate respondsToSelector:@selector(dismissKeyboard)]) {
        [delegate dismissKeyboard];
    }
}

//Protocol MoveTextFieldForKeyboardShowing
-(void)keyboardWillShow:(CGAffineTransform)transform
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    [loginAndRegisterView setTransform:transform];
//    [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, -loginAndRegisterView.frame.origin.y)];
    [UIView commitAnimations];
}

-(void)keyboardWillHide
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [loginAndRegisterView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView commitAnimations];
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
