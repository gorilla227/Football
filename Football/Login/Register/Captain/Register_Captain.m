//
//  Register_Captain.m
//  Football
//
//  Created by Andy on 14-3-22.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Register_Captain.h"

@interface Register_Captain ()

@end

@implementation Register_Captain{
    id<LoginAndRegisterView>delegate;
    NSArray *textFieldArray;
}
@synthesize teamName;
@synthesize cellphoneNumber;
@synthesize password;

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
    textFieldArray = [[NSArray alloc] initWithObjects:teamName, cellphoneNumber, password, nil];
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
    [teamName resignFirstResponder];
    [cellphoneNumber resignFirstResponder];
    [password resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissKeyboard];
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
