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
#warning roleCode is a test variable, it would be replaced by one from gMyUserInfo
    NSInteger roleCode;
    JSONConnect *connection;
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

    //Get UI strings
    actionButtons = [gUIStrings objectForKey:@"UI_FillAdditionalProfile_Actions"];
    
    //Fake the roleCode
    roleCode = 1;//0 - Captain, 1 - Player
    
    //Initial JSON connection
    connection = [[JSONConnect alloc] initWithDelegate:self];
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
    [connection requestUserInfoById:[NSNumber numberWithInteger:1]];
}

-(void)receiveUserInfo:(UserInfo *)userInfo
{
    gMyUserInfo = userInfo;
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
            if (indexPath.row == 3) {
                [cell setAlpha:0.5f];
                [cell setUserInteractionEnabled:NO];
            }
            break;
        case 1:
            if (indexPath.row == 1 || indexPath.row == 2) {
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
        [headerLabel setText:[gUIStrings objectForKey:roleCode?@"UI_FillAdditionalProfile_Header_Player":@"UI_FillAdditionalProfile_Header_Captain"]];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [headerLabel setAdjustsFontSizeToFitWidth:YES];
        [headerView addSubview:headerLabel];
        return headerView;
    }
    return nil;
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
