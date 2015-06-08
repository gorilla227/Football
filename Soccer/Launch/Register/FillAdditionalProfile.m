//
//  FillAdditionalProfile.m
//  Soccer
//
//  Created by Andy on 14-6-10.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "FillAdditionalProfile.h"
#import "EditPlayerProfile.h"
#import "EditTeamProfile.h"

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
    NSInteger roleCode;
}
@synthesize toolBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self setToolbarItems:toolBar.items];
    roleCode = gMyUserInfo.userType;
    [self.collectionView setCollectionViewLayout:[self collectionViewFlowLayoutByScreenResolution]];

    //Get UI strings
    actionButtons = [gUIStrings objectForKey:@"UI_FillAdditionalProfile_Actions"];
    
    callFriends = [[CallFriends alloc] initWithPresentingViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonOnClicked:(id)sender {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)completeButtonOnClicked:(id)sender {
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Captain" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    [self presentViewController:mainController animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

//CollectionView
- (UICollectionViewFlowLayout *)collectionViewFlowLayoutByScreenResolution {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGSize screenSize = self.collectionView.bounds.size;
    [layout setItemSize:CGSizeMake(screenSize.width / 2 * 0.85, screenSize.width / 2 * 0.85)];
    [layout setHeaderReferenceSize:CGSizeMake(screenSize.width, (screenSize.height - screenSize.width - 88) / 2)];
    [layout setFooterReferenceSize:CGSizeZero];
    [layout setMinimumInteritemSpacing:screenSize.width / 2 * 0.05];
    [layout setMinimumLineSpacing:screenSize.width / 2 * 0.1];
    [layout setSectionInset:UIEdgeInsetsMake(0, screenSize.width / 2 * 0.1, 0, screenSize.width / 2 * 0.1)];
    NSLog(@"%f, %f", self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    return layout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return actionButtons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Soccer" bundle:nil];
    if (indexPath.row == 0) {
        EditPlayerProfile *targetViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"EditPlayerProfile"];
        [targetViewController setViewType:EditProfileViewType_Register];
        [self.navigationController pushViewController:targetViewController animated:YES];

    }
    else if (indexPath.row == 1){
        EditTeamProfile *targetViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"EditTeamProfile"];
        [targetViewController setViewType:EditProfileViewType_Register];
        [self.navigationController pushViewController:targetViewController animated:YES];
    }
    else if (indexPath.row == 2){
        [callFriends showInView:self.view];
    }
    else if (indexPath.row == 3){
        UIViewController *targetViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"FindTeam"];
        [self.navigationController pushViewController:targetViewController animated:YES];
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
