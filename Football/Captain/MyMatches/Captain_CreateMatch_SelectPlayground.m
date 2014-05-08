//
//  Captain_CreateMatch_SelectPlayground.m
//  Football
//
//  Created by Andy on 14-4-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch_SelectPlayground.h"

@interface Captain_CreateMatch_SelectPlayground ()

@end

@implementation Captain_CreateMatch_SelectPlayground{
    NSArray *mainPlaygroundList;
    HintTextView *hintView;
}
@synthesize mainPlayground, matchPlaceTextField, saveButton, stadiumListView;
@synthesize delegate, selectedPlace, indexOfSelectedMainPlayground;

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
    [mainPlayground setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    mainPlaygroundList = [[NSArray alloc] initWithObjects:@"北京邮电大学操场", @"北京大学一体", nil];
    [mainPlayground setHidden:mainPlaygroundList.count == 0];
    [matchPlaceTextField setText:selectedPlace];
    
    //Initial HintView;
    hintView = [[HintTextView alloc] init];
    [self.view addSubview:hintView];
    [hintView settingHintWithTextKey:@"SelectPlayground" underView:matchPlaceTextField wantShow:![matchPlaceTextField hasText]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return mainPlaygroundList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainPlaygroundCell"];
    [cell.textLabel setText:[mainPlaygroundList objectAtIndex:indexPath.row]];
    if (indexOfSelectedMainPlayground == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexOfSelectedMainPlayground == indexPath.row) {
        indexOfSelectedMainPlayground = -1;
        [matchPlaceTextField setText:nil];
    }
    else {
        indexOfSelectedMainPlayground = indexPath.row;
        [matchPlaceTextField setText:[mainPlaygroundList objectAtIndex:indexPath.row]];
    }
    [tableView reloadData];
    [saveButton setEnabled:[matchPlaceTextField hasText]];
    [hintView showOrHideHint:![matchPlaceTextField hasText]];
}

-(IBAction)saveButtonOnClicked:(id)sender
{
    [delegate receiveSelectedPlayground:matchPlaceTextField.text indexOfMainPlayground:indexOfSelectedMainPlayground];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)matchPlaceChanged:(id)sender
{
    [saveButton setEnabled:[matchPlaceTextField hasText]];
    [hintView showOrHideHint:![matchPlaceTextField hasText]];
    indexOfSelectedMainPlayground = -1;
    [mainPlayground reloadData];
}

-(IBAction)selectStadiumButtonOnClicked:(id)sender
{
    [self.view bringSubviewToFront:stadiumListView];
    [stadiumListView setHidden:NO];
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
