//
//  PlayerMarket.m
//  Football
//
//  Created by Andy on 14-8-25.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "PlayerMarket.h"
#import "PositionCheckboxView.h"

#pragma PlayerMarket_SearchView
@interface PlayerMarket_SearchView ()
@property IBOutlet UISegmentedControl *haveTeamSegement;
@property IBOutlet PositionCheckboxView *positionView;
@property IBOutlet UIView *ageView;
@property IBOutlet UITextField *nickNameSearchTextField;
@property IBOutlet UILabel *ageFloorLabel;
@property IBOutlet UISlider *ageFloorSlider;
@property IBOutlet UILabel *ageCapLabel;
@property IBOutlet UISlider *ageCapSlider;
@property IBOutlet UITextFieldForActivityRegion *activityRegionSearchTextField;
@end

@implementation PlayerMarket_SearchView
@synthesize haveTeamSegement, positionView, ageView, ageFloorLabel, ageFloorSlider, ageCapLabel, ageCapSlider, nickNameSearchTextField, activityRegionSearchTextField;
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [positionView initWithPositionTitles:[gUIStrings objectForKey:@"UI_Positions"] padding:CGPointMake(5, 5)];
    [positionView changeButtonFont:[UIFont systemFontOfSize:14.0f]];
    [positionView changeButtonTintColor:[UIColor whiteColor]];
    [positionView changebuttonTextColor:[UIColor whiteColor]];
    [positionView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [positionView.layer setBorderWidth:1.0f];
    [positionView.layer setCornerRadius:6.0f];
    [positionView.layer setMasksToBounds:YES];
    
    [ageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [ageView.layer setBorderWidth:1.0f];
    [ageView.layer setCornerRadius:6.0f];
    [ageView.layer setMasksToBounds:YES];
    
    [activityRegionSearchTextField activityRegionTextField];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [nickNameSearchTextField resignFirstResponder];
    [activityRegionSearchTextField resignFirstResponder];
}

-(IBAction)ageSliderValueChanged:(id)sender
{
    if (ageFloorSlider.value <= ageCapSlider.value) {
        if ([sender isEqual:ageFloorSlider]) {
            [ageFloorLabel setText:[NSNumber numberWithFloat:floorf(ageFloorSlider.value)].stringValue];
        }
        else {
            [ageCapLabel setText:[NSNumber numberWithFloat:ceilf(ageCapSlider.value)].stringValue];
        }
    }
    else {
        if ([sender isEqual:ageFloorSlider]) {
            [ageFloorSlider setValue:ageCapSlider.value];
            [ageFloorLabel setText:ageCapLabel.text];
        }
        else {
            [ageCapSlider setValue:ageFloorSlider.value];
            [ageCapLabel setText:ageFloorLabel.text];
        }
    }
}

-(NSDictionary *)searchCriteria
{
    NSMutableDictionary *searchCriteria = [NSMutableDictionary new];
    //Nickname
    NSString *nickname = [nickNameSearchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nickname.length) {
        [searchCriteria setObject:nickname forKey:CONNECT_SearchPlayersCriteria_ParameterKey_Nickname];
    }
    
    //HaveTeam
    switch (haveTeamSegement.selectedSegmentIndex) {
        case 1:
            [searchCriteria setObject:[NSNumber numberWithBool:YES] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_HaveTeam];
            break;
        case 2:
            [searchCriteria setObject:[NSNumber numberWithBool:NO] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_HaveTeam];
            break;
        default:
            break;
    }
    
    //Position
    [searchCriteria setObject:[positionView selectedPositions] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_Position];
    
    //AgeCap & AgeFloor
    [searchCriteria setObject:ageCapLabel.text forKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeCap];
    [searchCriteria setObject:ageFloorLabel.text forKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeFloor];
    
    //ActivityRegion
    if (activityRegionSearchTextField.selectedActivityRegionCode) {
        [searchCriteria setObject:activityRegionSearchTextField.selectedActivityRegionCode forKey:CONNECT_SearchPlayersCriteria_ParameterKey_ActivityRegion];
    }
    
    return searchCriteria;
}
@end

#pragma PlayerMarket_Cell
@interface PlayerMarket_Cell ()
@property IBOutlet UIView *checkMarkBackground;
@property IBOutlet UIImageView *playerPortraitImageView;
@property IBOutlet UILabel *nickNameLabel;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *positionLabel;
@property IBOutlet UILabel *styleLabel;
@property IBOutlet UILabel *ageLabel;
@property IBOutlet UILabel *activityRegionLabel;
@end

@implementation PlayerMarket_Cell
@synthesize playerInfo;
@synthesize checkMarkBackground, playerPortraitImageView, nickNameLabel, teamNameLabel, positionLabel, styleLabel, ageLabel, activityRegionLabel;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [checkMarkBackground.layer setCornerRadius:15.0f];
    [checkMarkBackground.layer setMasksToBounds:YES];
}

-(IBAction)showPlayerDetails:(id)sender
{
    NSLog(@"Show Player Details");
}
@end

#pragma PlayerMarket
@interface PlayerMarket ()
@property BOOL isSearchViewShowed;
@property IBOutlet PlayerMarket_SearchView *searchView;
@property IBOutlet UIButton *searchViewSwitchButton;
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *recruitButton;
@property IBOutlet UIBarButtonItem *temporaryFavorButton;
@end

@implementation PlayerMarket{
    JSONConnect *connection;
    NSArray *playerList;
}
@synthesize isSearchViewShowed;
@synthesize searchView, searchViewSwitchButton, actionBar, recruitButton, temporaryFavorButton;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setTableHeaderView:searchView];
    isSearchViewShowed = YES;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [searchViewSwitchButton setTransform:CGAffineTransformMakeRotation(M_PI)];
    [self setToolbarItems:actionBar.items];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateActionButtonsStatus) name:UITableViewSelectionDidChangeNotification object:nil];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    playerList = [NSArray new];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:!self.toolbarItems.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)searchViewSwitchButtonOnClicked:(id)sender
{
    isSearchViewShowed = !isSearchViewShowed;
    [self.tableView setTableHeaderView:isSearchViewShowed?searchView:[[UIView alloc] initWithFrame:CGRectZero]];
    [searchViewSwitchButton setTransform:isSearchViewShowed?CGAffineTransformMakeRotation(M_PI):CGAffineTransformMakeRotation(0)];
    [self.tableView reloadData];
}

-(IBAction)searchButtonOnClicked:(id)sender
{
    [searchView.nickNameSearchTextField resignFirstResponder];
    [searchView.activityRegionSearchTextField resignFirstResponder];
    [connection requestPlayersBySearchCriteria:[searchView searchCriteria] startIndex:0 count:[[gSettings objectForKey:@"playersSearchListCount"] integerValue] isSync:YES];
}

-(void)updateActionButtonsStatus
{
    [temporaryFavorButton setEnabled:self.tableView.indexPathsForSelectedRows.count];
}

-(void)receivePlayers:(NSArray *)players
{
    playerList = players;
    if (playerList.count) {
        isSearchViewShowed = NO;
        [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
        [searchViewSwitchButton setTransform:CGAffineTransformMakeRotation(0)];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return playerList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerMarketCell";
    PlayerMarket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setAccessoryType:[tableView.indexPathsForSelectedRows containsObject:indexPath]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return searchViewSwitchButton;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return searchViewSwitchButton.frame.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
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
