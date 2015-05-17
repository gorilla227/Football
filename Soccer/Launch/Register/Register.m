//
//  Register.m
//  Soccer
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
@property IBOutlet UITextField *mobileTextField;
@property IBOutlet UITextField *passwordTextField;
@property IBOutlet UITextField *nickNameTextField;
@property IBOutlet UITextField *mailTextField;
@property IBOutlet UIToolbar *registerBar;
@property IBOutlet UIBarButtonItem *registerButton;
@property IBOutlet UISegmentedControl *roleSegment;
@end

@implementation Register{
    NSArray *textFieldArray;
    NSInteger numOfAvailableTextFields;
    JSONConnect *connection;
}
@synthesize teamNameTextField, mobileTextField, passwordTextField, nickNameTextField, mailTextField, registerBar, registerButton, roleSegment;

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
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:registerBar.items];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    textFieldArray = @[mobileTextField, passwordTextField, nickNameTextField, teamNameTextField, mailTextField];
    
    //Initial JSONConnection
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    //Set leftIcon for textFields
    [teamNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_TeamName.png"];
    [mobileTextField initialLeftViewWithIconImage:@"TextFieldIcon_Mobile.png"];
    [passwordTextField initialLeftViewWithIconImage:@"TextFieldIcon_Password.png"];
    [nickNameTextField initialLeftViewWithIconImage:@"TextFieldIcon_Account.png"];
    [mailTextField initialLeftViewWithIconImage:@"TextFieldIcon_Email.png"];
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
    switch (roleSegment.selectedSegmentIndex) {
        case 0:
            [connection registerCaptain:mobileTextField.text email:mailTextField.text password:passwordTextField.text.MD5 nickName:nickNameTextField.text teamName:teamNameTextField.text];
            break;
        case 1:
            [connection registerPlayer:mobileTextField.text email:mailTextField.text password:passwordTextField.text.MD5 nickName:nickNameTextField.text];
        default:
            break;
    }
}

-(void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference
{
    gMyUserInfo = userInfo;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[gUIStrings objectForKey:@"UI_RegisterView_Success_Title"]
                                                        message:[gUIStrings objectForKey:@"UI_RegisterView_Success_Message"]
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:[gUIStrings objectForKey:@"UI_RegisterView_Success_OK"], nil];
    [alertView show];
}

-(void)registerCaptainSuccessfully:(NSInteger)userId teamId:(NSInteger)teamId
{
    [connection requestUserInfo:userId withTeam:YES withReference:nil];
}

-(void)registerPlayerSuccessfully:(NSInteger)userId
{
    [connection requestUserInfo:userId withTeam:NO withReference:nil];
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
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell.contentView.subviews containsObject:textField]) {
            if ([textField hasText]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [cell setAccessoryView:nil];
            }
            else {
                [cell setAccessoryView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 0)]];
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
            break;
        case 1://Player
            numOfAvailableTextFields = 3;
            break;
        default:
            numOfAvailableTextFields = 0;
            break;
    }
    [self refreshRegisterButtonEnable];
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (roleSegment.selectedSegmentIndex) {
        case 0:
            switch (section) {
                case 0:
                    return 1;
                case 1:
                    return 5;
                default:
                    return 0;
            }
        case 1:
            switch (section) {
                case 0:
                    return 0;
                case 1:
                    return 4;
                default:
                    return 0;
            }
            
        default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
//    [headerView setBackgroundView:nil];
//    [headerView.textLabel setTextColor:[UIColor whiteColor]];
//    [headerView.textLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView.textLabel setFont:[UIFont fontWithName:headerView.textLabel.font.fontName size:17.0f]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UIView *subview in cell.contentView.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subview;
            if ([textField hasText]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [cell setAccessoryView:nil];
            }
            else {
                [cell setAccessoryView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 0)]];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && roleSegment.selectedSegmentIndex == 1) {
        return 0;
    }
    else {
        return tableView.sectionHeaderHeight;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (roleSegment.selectedSegmentIndex) {
        case 0:
            switch (section) {
                case 0:
                    return [gUIStrings objectForKey:@"UI_RegisterView_Captain_Section_01"];
                case 1:
                    return [gUIStrings objectForKey:@"UI_RegisterView_Captain_Section_02"];
                default:
                    return nil;
            }
        case 1:
            return [gUIStrings objectForKey:@"UI_RegisterView_Player_Section_01"];
        default:
            return nil;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"FillAdditionalProfile"]) {
//        FillAdditionalProfile *fillAdditionalProfile = segue.destinationViewController;
//        [fillAdditionalProfile setRoleCode:roleSegment.selectedSegmentIndex];
//    }
}

@end
