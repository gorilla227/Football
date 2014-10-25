//
//  TeamMarket.m
//  Football
//
//  Created by Andy on 14-10-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "TeamMarket.h"

#pragma TeamMarket_SearchView
@interface TeamMarket_SearchView ()
@property IBOutlet UIView *teamNumberView;
@property IBOutlet UITextField *teamNameSearchTextField;
@property IBOutlet UILabel *teamNumberFloorLabel;
@property IBOutlet UISlider *teamNumberFloorSlider;
@property IBOutlet UILabel *teamNumberCapLabel;
@property IBOutlet UISlider *teamNumberCapSlider;
@property IBOutlet UITextFieldForActivityRegion *activityRegionSearchTextField;
@property IBOutlet UISwitch *onlyRecruitSwitch;
@property IBOutlet UISwitch *onlyChallenteamNumberSwitch;
@property IBOutlet UIButton *searchButton;
@end

@implementation TeamMarket_SearchView
@synthesize teamNumberView, teamNameSearchTextField, teamNumberFloorLabel, teamNumberFloorSlider, teamNumberCapLabel, teamNumberCapSlider, activityRegionSearchTextField, onlyChallenteamNumberSwitch, onlyRecruitSwitch, searchButton;
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [teamNumberView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamNumberView.layer setBorderWidth:1.0f];
    [teamNumberView.layer setCornerRadius:6.0f];
    [teamNumberView.layer setMasksToBounds:YES];
    
    [activityRegionSearchTextField activityRegionTextField];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setFrame:self.bounds];
    [gradient setColors:@[(id)cLightBlue(1).CGColor, (id)[UIColor grayColor].CGColor, (id)cLightBlue(1).CGColor]];
    [self.layer insertSublayer:gradient atIndex:0];
    
    [searchButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [searchButton.layer setBorderWidth:1.0f];
    [searchButton.layer setCornerRadius:10.0f];
    [searchButton.layer setMasksToBounds:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [teamNameSearchTextField resignFirstResponder];
    [activityRegionSearchTextField resignFirstResponder];
}

-(IBAction)teamNumberSliderValueChanged:(id)sender
{
    if (teamNumberFloorSlider.value <= teamNumberCapSlider.value) {
        if ([sender isEqual:teamNumberFloorSlider]) {
            [teamNumberFloorLabel setText:[NSNumber numberWithFloat:floorf(teamNumberFloorSlider.value)].stringValue];
        }
        else {
            [teamNumberCapLabel setText:[NSNumber numberWithFloat:ceilf(teamNumberCapSlider.value)].stringValue];
        }
    }
    else {
        if ([sender isEqual:teamNumberFloorSlider]) {
            [teamNumberFloorSlider setValue:teamNumberCapSlider.value];
            [teamNumberFloorLabel setText:teamNumberCapLabel.text];
        }
        else {
            [teamNumberCapSlider setValue:teamNumberFloorSlider.value];
            [teamNumberCapLabel setText:teamNumberFloorLabel.text];
        }
    }
    if (ceilf(teamNumberCapSlider.value) == teamNumberCapSlider.maximumValue) {
        [teamNumberCapLabel setText:[NSString stringWithFormat:@"%@+", [NSNumber numberWithFloat:ceilf(teamNumberCapSlider.value)].stringValue]];
    }
}

-(IBAction)flagSwitchValueChanged:(id)sender
{
    if (onlyRecruitSwitch.isOn && onlyChallenteamNumberSwitch.isOn) {
        if ([sender isEqual:onlyChallenteamNumberSwitch]) {
            [onlyRecruitSwitch setOn:NO animated:YES];
        }
        else {
            [onlyChallenteamNumberSwitch setOn:NO animated:YES];
        }
    }
}

-(NSDictionary *)searchCriteria
{
    NSMutableDictionary *searchCriteria = [NSMutableDictionary new];
    //TeamName
    NSString *teamName = [teamNameSearchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (teamName.length) {
//        [searchCriteria setObject:teamName forKey:CONNECT_SearchPlayersCriteria_ParameterKey_teamName];
    }
    
    //TeamNumberCap & TeamNumberFloor
//    [searchCriteria setObject:teamNumberCapLabel.text forKey:CONNECT_SearchPlayersCriteria_ParameterKey_teamNumberCap];
//    [searchCriteria setObject:teamNumberFloorLabel.text forKey:CONNECT_SearchPlayersCriteria_ParameterKey_teamNumberFloor];
    
    //ActivityRegion
    if (activityRegionSearchTextField.selectedActivityRegionCode) {
        [searchCriteria setObject:activityRegionSearchTextField.selectedActivityRegionCode forKey:CONNECT_SearchPlayersCriteria_ParameterKey_ActivityRegion];
    }
    
    return searchCriteria;
}
@end

#pragma TeamMarketCell
@interface TeamMarket_Cell ()
@property IBOutlet UIImageView *teamLogoImageView;
@property IBOutlet UILabel *teamNameLabel;
@property IBOutlet UILabel *myTeamFlagLabel;
@property IBOutlet UILabel *boardNameLabel;
@property IBOutlet UITextView *boardContentTextView;
@property IBOutlet UILabel *teamNumberLabel;
@property IBOutlet UILabel *activityRegionLabel;
@end

@implementation TeamMarket_Cell
@synthesize teamLogoImageView, teamNameLabel, myTeamFlagLabel, boardNameLabel, boardContentTextView, teamNumberLabel, activityRegionLabel;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [teamLogoImageView.layer setCornerRadius:10.0f];
    [teamLogoImageView.layer setMasksToBounds:YES];
    [myTeamFlagLabel.layer setCornerRadius:3.0f];
    [myTeamFlagLabel.layer setMasksToBounds:YES];
    [myTeamFlagLabel setBackgroundColor:cGray(0.9)];
}
@end

#pragma TeamMarket
@interface TeamMarket ()

@end

@implementation TeamMarket{
    JSONConnect *connection;
    NSMutableArray *teamList;
    BOOL isLoading;
    NSInteger count;
    BOOL haveMoreTeams;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    haveMoreTeams = YES;
    teamList = [NSMutableArray new];
    count = [[gSettings objectForKey:@"teamsSearchListCount"] integerValue];
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TeamMarketCell";
    TeamMarket_Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    Team *cellData = [teamList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
