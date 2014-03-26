//
//  Register_Player.m
//  Football
//
//  Created by Andy on 14-3-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Register_Player.h"

@interface Register_Player ()

@end

@implementation Register_Player{
    id<LoginAndRegisterView>delegate;
    NSArray *textFieldArray;
}
@synthesize personalID, cellphoneNumber, qqNumber, birthday, activityRegion, password;

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
    textFieldArray = [[NSArray alloc] initWithObjects:personalID, cellphoneNumber, qqNumber, birthday, activityRegion, password, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonOnClicked:(id)sender
{
    delegate = (id)self.parentViewController.parentViewController;
    [delegate presentLoginView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissKeyboard];
}

-(IBAction)changeTextFieldFocus:(id)sender
{
    NSInteger indexOfNextTextField = [textFieldArray indexOfObject:sender] + 1;
    if (indexOfNextTextField >= textFieldArray.count) {

    }
    else {
        UIResponder *nextResponder = [textFieldArray objectAtIndex:indexOfNextTextField];
        [nextResponder becomeFirstResponder];
    }
}

-(void)dismissKeyboard
{
    [personalID resignFirstResponder];
    [cellphoneNumber resignFirstResponder];
    [qqNumber resignFirstResponder];
    [birthday resignFirstResponder];
    [activityRegion resignFirstResponder];
    [password resignFirstResponder];
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
