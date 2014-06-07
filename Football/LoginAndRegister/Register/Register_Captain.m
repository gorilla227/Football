//
//  Register_Captain.m
//  Football
//
//  Created by Andy on 14-6-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Register_Captain.h"

@implementation Register_Captain{
    NSArray *textFieldArray;
}
@synthesize teamName, cellphoneNumber, password, registerButton;

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
    //Add icon for each textfield
//    UIImage *teamNameImage = [UIImage imageNamed:@"login_textfield_title_user.png"];
//    [teamName setLeftView:[[UIImageView alloc] initWithImage:teamNameImage]];
//    [teamName setLeftViewMode:UITextFieldViewModeAlways];
//    UIImage *cellphoneNumberImage = [UIImage imageNamed:@"register_phone.png"];
//    [cellphoneNumber setLeftView:[[UIImageView alloc] initWithImage:cellphoneNumberImage]];
//    [cellphoneNumber setLeftViewMode:UITextFieldViewModeAlways];
//    UIImage *passwordImage = [UIImage imageNamed:@"login_textfield_title_pwd.png"];
//    [password setLeftView:[[UIImageView alloc] initWithImage:passwordImage]];
//    [password setLeftViewMode:UITextFieldViewModeAlways];
    textFieldArray = @[teamName, cellphoneNumber, password];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    //Add observer for keyboardShowinng
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftUpViewForKeyboardShowing) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreViewForKeyboardHiding) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButtonOnClicked:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Protocol DissmissKeyboard
-(void)dismissKeyboard
{
    [teamName resignFirstResponder];
    [cellphoneNumber resignFirstResponder];
    [password resignFirstResponder];
}

//ShiftUp/Restore view for keyboard
-(void)shiftUpViewForKeyboardShowing
{
    id<MoveTextFieldForKeyboardShowing>delegate = (id)self.navigationController.parentViewController;
    [delegate keyboardWillShow:CGAffineTransformMakeTranslation(0, -100)];
    
    //ShiftUp Register Button
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    [registerButton setTransform:CGAffineTransformMakeTranslation(0, -110)];
    [UIView commitAnimations];
}

-(void)restoreViewForKeyboardHiding
{
    id<MoveTextFieldForKeyboardShowing>delegate = (id)self.navigationController.parentViewController;
    [delegate keyboardWillHide];
    
    //Restore Register Button
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [registerButton setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView commitAnimations];
}

//TextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger indexOfNextTextField = [textFieldArray indexOfObject:textField] + 1;
    if (indexOfNextTextField >= textFieldArray.count) {
        for (UITextField *eachTextField in textFieldArray) {
            if (![eachTextField hasText]) {
                [eachTextField becomeFirstResponder];
                return NO;
            }
        }
        [self performSegueWithIdentifier:@"CaptainRegisterAdvance" sender:self];
    }
    else {
        UIResponder *nextResponder = [textFieldArray objectAtIndex:indexOfNextTextField];
        [nextResponder becomeFirstResponder];
    }
    return NO;
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
