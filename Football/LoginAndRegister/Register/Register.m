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
    [self reloadData];
}

@end

@interface Register ()
@property IBOutlet UITextField *teamNameTextField;
@property IBOutlet UITextField *phoneNumberTextField;
@property IBOutlet UITextField *passwordTextField;
@property IBOutlet UITextField *nickNameTextField;
@property IBOutlet UIToolbar *registerBar;
@end

@implementation Register{
    NSArray *textFieldArray;
}
@synthesize teamNameTextField, phoneNumberTextField, passwordTextField, nickNameTextField, registerBar;
@synthesize roleCode;

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
    
    switch (roleCode) {
        case 0:
            [self.navigationItem setTitle:def_registerViewTitle_Captain];
            break;
        case 1:
            [self.navigationItem setTitle:def_registerViewTitle_Player];
            break;
        default:
            break;
    }
    
    textFieldArray = @[teamNameTextField, phoneNumberTextField, passwordTextField, nickNameTextField];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO];
    
    //Add observer for keyboardShowinng
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shiftUpViewForKeyboardShowing) name:UIKeyboardWillShowNotification object:nil];
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

-(IBAction)registerButtonOnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"RegisterCompleted" sender:self];
}

////DismissKeyboard
//-(void)dismissKeyboard
//{
//    for (UITextField *textField in textFieldArray) {
//        [textField resignFirstResponder];
//    }
//}

//ShiftUp/Restore view for keyboard
//-(void)shiftUpViewForKeyboardShowing
//{
//    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)]];
//}

-(void)restoreViewForKeyboardHiding
{
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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
        [self performSegueWithIdentifier:@"RegisterCompleted" sender:self];
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
            break;
        }
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (roleCode) {
        case 0://Captain
            return 2;
        case 1://Player
            return 1;
        default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"RegisterCompleted"]) {
        RegisterCompleted *completedView = segue.destinationViewController;
        [completedView setRoleCode:roleCode];
    }
}


@end
