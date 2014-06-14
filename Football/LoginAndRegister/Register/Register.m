//
//  Register.m
//  Football
//
//  Created by Andy Xu on 14-6-8.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Register.h"

@implementation Register_TableView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setDelegateForDismissKeyboard:(id)self.delegate];
    [self.delegateForDismissKeyboard dismissKeyboard];
}

@end

@interface Register ()
@property IBOutlet UITextField *teamNameTextField;
@property IBOutlet UITextField *phoneNumberTextField;
@property IBOutlet UITextField *passwordTextField;
@property IBOutlet UITextField *nickNameTextField;
@property IBOutlet UIToolbar *registerBar;
@property IBOutlet UIBarButtonItem *registerButton;
@property IBOutlet UISegmentedControl *roleSegment;
@end

@implementation Register{
    NSArray *textFieldArray;
    NSInteger numOfAvailableTextFields;
}
@synthesize teamNameTextField, phoneNumberTextField, passwordTextField, nickNameTextField, registerBar, registerButton, roleSegment;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setToolbarItems:registerBar.items];
    
//    switch (roleSegment.selectedSegmentIndex) {
//        case 0:
//            [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_RegisterViewTitle_Captain"]];
//            break;
//        case 1:
//            [self.navigationItem setTitle:[gUIStrings objectForKey:@"UI_RegisterViewTitle_Player"]];
//            break;
//        default:
//            break;
//    }
    
    textFieldArray = @[phoneNumberTextField, passwordTextField, nickNameTextField, teamNameTextField];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)roleChanged:(id)sender
{
    [self.tableView reloadData];
}

-(IBAction)cancelButtonOnClicked:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)registerButtonOnClicked:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册成功!"
                                                        message:@"恭喜，你已加入“我要踢球”的大家庭！"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"补充详细资料", nil];
    [alertView show];
}

//UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self performSegueWithIdentifier:@"FillAdditionalProfile" sender:self];
}

//Protocol DismissKeyboard
-(void)dismissKeyboard
{
    for (UITextField *textField in textFieldArray) {
        [textField resignFirstResponder];
    }
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
        [self registerButtonOnClicked:self];
    }
    else {
        UIResponder *nextResponder = [textFieldArray objectAtIndex:indexOfNextTextField];
        [nextResponder becomeFirstResponder];
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath;
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell.contentView.subviews containsObject:textField]) {
            indexPath = [self.tableView indexPathForCell:cell];
            break;
        }
    }
    if (indexPath) {
        [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)]];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell.contentView.subviews containsObject:textField]) {
            if ([textField hasText]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
            else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            [self refreshRegisterButtonEnable];
            break;
        }
    }
}

//Refresh RegisterButton isEnable
-(void)refreshRegisterButtonEnable
{
    BOOL textAllFilled = YES;
    for (int i = 0; i < numOfAvailableTextFields; i++) {
        textAllFilled = textAllFilled && [textFieldArray[i] hasText];
    }
    [registerButton setEnabled:textAllFilled];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (roleSegment.selectedSegmentIndex) {
        case 0://Captain
            numOfAvailableTextFields = 4;
            [self refreshRegisterButtonEnable];
            return 2;
        case 1://Player
            numOfAvailableTextFields = 3;
            [self refreshRegisterButtonEnable];
            return 1;
        default:
            numOfAvailableTextFields = 0;
            [self refreshRegisterButtonEnable];
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setTextAlignment:NSTextAlignmentCenter];
//    [headerView.contentView setBackgroundColor:tableView.tintColor];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"FillAdditionalProfile"]) {
        FillAdditionalProfile *fillAdditionalProfile = segue.destinationViewController;
        [fillAdditionalProfile setRoleCode:roleSegment.selectedSegmentIndex];
    }
}


@end
