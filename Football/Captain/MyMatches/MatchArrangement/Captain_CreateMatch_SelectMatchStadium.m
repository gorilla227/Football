//
//  Captain_CreateMatch_SelectMatchStadium.m
//  Football
//
//  Created by Andy on 14-4-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch_SelectMatchStadium.h"

@implementation Captain_CreateMatch_SelectMatchStadium{
    NSArray *homeStadiumList;
    HintTextView *hintView;
    JSONConnect *connection;
}
@synthesize homeStadiumTableView, matchPlaceTextField, saveButton, stadiumListView;
@synthesize delegate, matchStadium, indexOfSelectedHomeStadium;

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    [homeStadiumTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Fake MainStadiums
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
//    [connection requestStadiumById:[NSNumber numberWithInteger:1]];
//    [connection requestStadiumById:[NSNumber numberWithInteger:4]];
//    homeStadiumList = [[NSArray alloc] initWithObjects:@"北京邮电大学操场", @"北京大学一体", nil];
    homeStadiumList = [[NSArray alloc]init];
    if (matchStadium) {
        [matchPlaceTextField setText:matchStadium.stadiumName];
    }
    
    //Initial HintView;
    hintView = [[HintTextView alloc] init];
    [self.view addSubview:hintView];
    [hintView settingHintWithTextKey:@"SelectPlayground" underView:matchPlaceTextField wantShow:YES];
    
    //Set delegate for StadiumList
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:[Captain_CreateMatch_StadiumList_Base class]]) {
            Captain_CreateMatch_StadiumList_Base *stadiumListBaseController = (Captain_CreateMatch_StadiumList_Base *)controller;
            [stadiumListBaseController setDelegate:self];
            Captain_CreateMatch_StadiumList *stadiumListController = (Captain_CreateMatch_StadiumList *) stadiumListBaseController.childViewControllers.lastObject;
            [stadiumListController setDelegate:self];
        }
    }
    
    //Set stadiumListView
    [self.view bringSubviewToFront:stadiumListView];
    [stadiumListView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveStadiums:(NSArray *)stadiums
{
    if (stadiums.count > 0) {
        homeStadiumList = [homeStadiumList arrayByAddingObjectsFromArray:stadiums];
        [homeStadiumTableView reloadData];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [matchPlaceTextField resignFirstResponder];
}

#pragma MainPlayground Tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [homeStadiumTableView setHidden:homeStadiumList.count == 0];
    return homeStadiumList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainPlaygroundCell"];
    Stadium *stadiumData = [homeStadiumList objectAtIndex:indexPath.row];
    [cell.textLabel setText:stadiumData.stadiumName];
    if (indexOfSelectedHomeStadium == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexOfSelectedHomeStadium == indexPath.row) {
        indexOfSelectedHomeStadium = -1;
        [matchPlaceTextField setText:nil];
        matchStadium = nil;
    }
    else {
        indexOfSelectedHomeStadium = indexPath.row;
        Stadium *stadiumData = [homeStadiumList objectAtIndex:indexPath.row];
        [matchPlaceTextField setText:stadiumData.stadiumName];
        matchStadium = stadiumData;
    }
    [tableView reloadData];
    [saveButton setEnabled:[matchPlaceTextField hasText]];
//    [hintView showOrHideHint:![matchPlaceTextField hasText]];
}

-(IBAction)saveButtonOnClicked:(id)sender
{
    [delegate receiveSelectedStadium:matchStadium indexOfHomeStadium:indexOfSelectedHomeStadium];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)matchPlaceChanged:(id)sender
{
    [saveButton setEnabled:[matchPlaceTextField hasText]];
//    [hintView showOrHideHint:![matchPlaceTextField hasText]];
    indexOfSelectedHomeStadium = -1;
    matchStadium = [[Stadium alloc] init];
    [matchStadium setStadiumName:matchPlaceTextField.text];
    [homeStadiumTableView reloadData];
}

-(IBAction)selectStadiumButtonOnClicked:(id)sender
{
    [matchPlaceTextField resignFirstResponder];
    [stadiumListView setHidden:NO];
}

#pragma Select Stadium
-(void)notSelectStadium:(Captain_CreateMatch_StadiumList *)sender
{
    [sender.searchDisplayController.searchBar resignFirstResponder];
    [stadiumListView setHidden:YES];
}

-(void)stadiumSelected:(Stadium *)selectedStadium
{
    [stadiumListView setHidden:YES];
    [matchPlaceTextField setText:selectedStadium.stadiumName];
    matchStadium = selectedStadium;
    
    for (Stadium *homeStadium in homeStadiumList) {
        if (homeStadium.stadiumId == selectedStadium.stadiumId) {
            indexOfSelectedHomeStadium = [homeStadiumList indexOfObject:homeStadium];            
            break;
        }
        else {
            indexOfSelectedHomeStadium = -1;
        }
    }
    [homeStadiumTableView reloadData];
    [saveButton setEnabled:[matchPlaceTextField hasText]];
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
