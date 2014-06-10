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
    NSString *menuCellIdentifier_root;
    NSString *menuCellIdentifier_lesser;
    NSInteger lastRootMenuIndex;
    NSIndexPath *visibleViewIndexPath;
}
@synthesize delegateOfMenuAppearance, delegateOfViewSwitch, toolBar;

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
    
    //Set the original frame
    [self.view setFrame:def_mainMenuFrame];
    
    //Set the static string for cell identifiers
    menuCellIdentifier_root = @"RootMenu";
    menuCellIdentifier_lesser = @"LesserMenu";
    
    //Set the font for selected/unselected menu cell.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:menuCellIdentifier_lesser];
    unselectedFont = cell.textLabel.font;
    CGFloat fontSize = cell.textLabel.font.pointSize + 3.0f;
    selectedFont = [UIFont boldSystemFontOfSize:fontSize];

    //Set the tableheaderview and tablefooterview
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
//    headerFrame.size.height = self.tableView.sectionFooterHeight;
    headerFrame.size.height = 0.1;
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:headerFrame]];

    //Generate the menulist
    [self menuListGeneration];
    lastRootMenuIndex = 0;//Unfolder root menu index
    visibleViewIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];//Select lessor menu item index
    
    //Set background
    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg@2x.png"];
    [self.view.layer setContents:(id)backgroundImage.CGImage];
    
    [toolBar setBarTintColor:[UIColor grayColor]];
    [toolBar setTintColor:[UIColor whiteColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != lastRootMenuIndex && indexPath.row != 0) {
        return 0;
    }
    return tableView.rowHeight;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView selectRowAtIndexPath:visibleViewIndexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:visibleViewIndexPath];
    [self formatCell:cell withFont:selectedFont];
}

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
    UITableViewCell *cell;

    if (indexPath.row == 0) {
        //Root Menu Item
        cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier_root];
        [cell.textLabel setText:[[[menuListDictionary objectForKey:@"RootMenu"] objectAtIndex:indexPath.section] objectForKey:@"Title"]];
        [cell.imageView setImage:[UIImage imageNamed:[[[menuListDictionary objectForKey:@"RootMenu"] objectAtIndex:indexPath.section] objectForKey:@"Icon"]]];
        [cell.imageView setContentMode:UIViewContentModeScaleToFill];
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        [cell setBackgroundColor:[UIColor grayColor]];
    }
    else {
        NSDictionary *menuItem = [[menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", indexPath.section]] objectAtIndex:indexPath.row - 1];
        
        //Lesser Menu Item
        cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier_lesser];
        [cell.textLabel setText:[menuItem objectForKey:@"Title"]];
//        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self formatCell:cell withFont:unselectedFont];
        [cell.imageView setAlpha:0];
    }
//    [cell setUserInteractionEnabled:(indexPath.row != 0)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        lastRootMenuIndex = indexPath.section;
        [self.tableView reloadData];
        [self viewWillAppear:NO];
    }
    else {
        //Format the cell
        [self formatCell:cell withFont:selectedFont];
        
        //Call the parentcontroller to switch lesser view
        NSDictionary *menuItem = [[menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", indexPath.section]] objectAtIndex:indexPath.row - 1];
        NSString *selectedView = [menuItem objectForKey:@"Identifier"];
        if (selectedView.length != 0) {
            [delegateOfViewSwitch switchSelectMenuView:selectedView];
        }
        NSLog(@"%@", [menuItem objectForKey:@"Title"]);

        //Close the menu
        [delegateOfMenuAppearance menuSwitch];
        
        visibleViewIndexPath = indexPath;
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
    [cell.textLabel setFont:font];
}

-(IBAction)logoutButtonOnClicked:(id)sender
{
    [delegateOfViewSwitch logout];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)optionButtonOnClicked:(id)sender
{
//    delegateOfMenuAppearance = (id)self.parentViewController;
    NSLog(@"设置");
    [delegateOfMenuAppearance menuSwitch];
}

-(void)resetMenuFolder
{
    lastRootMenuIndex = visibleViewIndexPath.section;
    [self.tableView reloadData];
    [self viewWillAppear:NO];
}
@end
