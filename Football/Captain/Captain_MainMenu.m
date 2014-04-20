//
//  Captain_MainMenu.m
//  Football
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MainMenu.h"

@interface Captain_MainMenu ()

@end

@implementation Captain_MainMenu{
    NSDictionary *menuListDictionary;
    UIFont *selectedFont;
    UIFont *unselectedFont;
    NSString *menuCellIdentifier;
    NSInteger lastRootMenuIndex;
}
@synthesize delegateOfMenuAppearance, delegateOfViewSwitch;

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
    [self.view setFrame:CGRectMake(-124, 0, 124, 568)];
//    [self setDelegateOfViewSwitch:(id)self.navigationController];
//    [self setDelegateOfMenuAppearance:(id)self.navigationController];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Set the static string for cell identifiers
    menuCellIdentifier = @"Menu";
    
    //Set the font for selected/unselected menu cell.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    unselectedFont = cell.detailTextLabel.font;
    CGFloat fontSize = cell.detailTextLabel.font.pointSize + 3.0f;
    selectedFont = [UIFont boldSystemFontOfSize:fontSize];

//    //Set the tableheaderview and tablefooterview
//    CGRect headerFrame = self.tableView.tableHeaderView.frame;
//    headerFrame.size.height = self.tableView.sectionFooterHeight;
//    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:headerFrame]];

    //Generate the initial menulist
    [self menuListGeneration];
    lastRootMenuIndex = 0;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:lastRootMenuIndex + 1 inSection:0];
//    [self.tableView selectRowAtIndexPath:firstIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    [self tableView:self.tableView didSelectRowAtIndexPath:firstIndexPath];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[menuListDictionary objectForKey:@"RootMenu"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", section]] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];

    if (indexPath.row == 0) {
        //Root Menu Item
        [cell.textLabel setText:[[menuListDictionary objectForKey:@"RootMenu"] objectAtIndex:indexPath.section]];
        [cell.detailTextLabel setText:nil];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        NSDictionary *menuItem = [[menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", indexPath.section]] objectAtIndex:indexPath.row - 1];
        
        //Lesser Menu Item
        [cell.textLabel setText:nil];
        [cell.detailTextLabel setText:[menuItem objectForKey:@"Title"]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self formatCell:cell withFont:unselectedFont];
    }

    [cell setUserInteractionEnabled:(indexPath.row != 0)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    id<MainMenuAppearenceDelegate>delegateMenuAppearance = (id)self.parentViewController;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        lastRootMenuIndex = indexPath.section;
        [self.tableView reloadData];
    }
    else {
        //Format the cell
        [self formatCell:cell withFont:selectedFont];
        
        //Call the parentcontroller to switch lesser view
        NSDictionary *menuItem = [[menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", indexPath.section]] objectAtIndex:indexPath.row - 1];
        NSString *selectedView = [menuItem objectForKey:@"Identifier"];
        [delegateOfViewSwitch switchSelectMenuView:selectedView];
        NSLog([menuItem objectForKey:@"Title"]);

        //Close the menu
        [delegateOfMenuAppearance menuSwitch];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self formatCell:cell withFont:unselectedFont];
}

-(void)menuListGeneration
{
    //Get data from plist file
    NSString *menuListFile = [[NSBundle mainBundle] pathForResource:@"Captain_MenuList" ofType:@"plist"];
    menuListDictionary = [[NSDictionary alloc] initWithContentsOfFile:menuListFile];
}

-(void)formatCell:(UITableViewCell *)cell withFont:(UIFont *)font
{
    [cell.detailTextLabel setFont:font];
}

-(IBAction)logoutButtonOnClicked:(id)sender
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)optionButtonOnClicked:(id)sender
{
//    delegateOfMenuAppearance = (id)self.parentViewController;
    NSLog(@"设置");
    [delegateOfMenuAppearance menuSwitch];
}

@end
