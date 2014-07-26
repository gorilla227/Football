//
//  FillAdditionalProfile.m
//  Football
//
//  Created by Andy on 14-6-10.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "FillAdditionalProfile.h"

#pragma FillAdditionalProfile_Cell
@interface FillAdditionalProfile_Cell ()
@property IBOutlet UIImageView *actionIcon;
@property IBOutlet UILabel *actionLabel;
@end

@implementation FillAdditionalProfile_Cell
@synthesize actionIcon, actionLabel;
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self.layer setCornerRadius:30.0f];
}
@end

#pragma FillAdditionalProfile
@interface FillAdditionalProfile ()
@property IBOutlet UIToolbar *toolBar;
@end

@implementation FillAdditionalProfile{
    NSArray *actionButtons;
    CallFriends *callFriends;
    ABPeoplePickerNavigationController *addressbookPeoplePicker;
    NSInteger roleCode;
}
@synthesize toolBar;

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
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:toolBar.items];
    
    roleCode = gMyUserInfo.userType;

    //Get UI strings
    actionButtons = [gUIStrings objectForKey:@"UI_FillAdditionalProfile_Actions"];
    
    callFriends = [[CallFriends alloc] initWithDelegate:self];
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
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)completeButtonOnClicked:(id)sender
{
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

//CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return actionButtons.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FillAdditionalProfile_Cell";
    FillAdditionalProfile_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.actionIcon setImage:[UIImage imageNamed:[actionButtons[indexPath.row] objectForKey:@"Icon"]]];
    [cell.actionLabel setText:[actionButtons[indexPath.row] objectForKey:@"Title"]];
    switch (roleCode) {
        case 0:
            if (indexPath.row == 1) {
                [cell setAlpha:0.5f];
                [cell setUserInteractionEnabled:NO];
            }
            
            break;
        case 1:
            if (indexPath.row == 3) {
                [cell setAlpha:0.5f];
                [cell setUserInteractionEnabled:NO];
            }
            break;
        default:
            break;
    }
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HeaderIdentifier = @"FillAdditionalProfile_Header";
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
        [headerLabel setText:[NSString stringWithFormat:@"%@%@", gMyUserInfo.nickName, [gUIStrings objectForKey:roleCode?@"UI_FillAdditionalProfile_Header_Captain":@"UI_FillAdditionalProfile_Header_Player"]]];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [headerLabel setAdjustsFontSizeToFitWidth:YES];
        [headerView addSubview:headerLabel];
        return headerView;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Soccer" bundle:nil];
    UIViewController *targetViewController;
    switch (indexPath.row) {
        case 0:
            targetViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"EditPlayerProfile"];
            [self.navigationController pushViewController:targetViewController animated:YES];
            break;
        case 1:
            targetViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"EditTeamProfile"];
            [self.navigationController pushViewController:targetViewController animated:YES];
            break;
        case 2:
            [callFriends showInView:self.view];
            break;
        case 3:
            targetViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"FindTeam"];
            [self.navigationController pushViewController:targetViewController animated:YES];
            break;
        default:
            break;
    }
}

//CallFriends
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@", [actionSheet buttonTitleAtIndex:buttonIndex]);
    if (buttonIndex == 0) {
        //Phone_Message
        addressbookPeoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        [addressbookPeoplePicker setPeoplePickerDelegate:self];
        [addressbookPeoplePicker setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:addressbookPeoplePicker animated:YES completion:nil];
    }
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSArray *displayedProperties = @[[NSNumber numberWithInt:kABPersonPhoneProperty], [NSNumber numberWithInt:kABPersonEmailProperty]];
    [peoplePicker setDisplayedProperties:displayedProperties];
    return YES;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    if (property == kABPersonPhoneProperty) {
        //MFMessage
        if ([MFMessageComposeViewController canSendText]) {
            ABMutableMultiValueRef phoneProperties = ABRecordCopyValue(person, property);
            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneProperties, ABMultiValueGetIndexForIdentifier(phoneProperties, identifier)));
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            NSString *messageTemplateFile = [[NSBundle mainBundle] pathForResource:@"MessageTemplate" ofType:@"plist"];
            NSDictionary *messageTemplate = [NSDictionary dictionaryWithContentsOfFile:messageTemplateFile];
            [messageController setMessageComposeDelegate:self];
            [messageController setRecipients:@[phoneNumber]];
            [messageController setBody:[messageTemplate objectForKey:@"SMS_InviteFriends"]];
            [peoplePicker presentViewController:messageController animated:YES completion:nil];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Unsupported"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
            [alertView show];
        }
    }
    return NO;
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIAlertView *alertView;
    switch (result) {
        case MessageComposeResultCancelled:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Cancelled"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
            break;
        case MessageComposeResultFailed:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Failed"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
            break;
        case MessageComposeResultSent:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Successful"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
        default:
            break;
    }
    [alertView show];
    [controller dismissViewControllerAnimated:NO completion:^{
        [addressbookPeoplePicker dismissViewControllerAnimated:NO completion:nil];
    }];
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
