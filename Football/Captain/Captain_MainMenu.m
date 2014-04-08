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
    NSMutableArray *menuList;
    UIFont *selectedFont;
    UIFont *unselectedFont;
    id<MenuSelected>delegateOfRootView;
    NSArray *fixedMenuList;
    NSString *lesserMenuCellIdentifier;
    NSString *optionMenuCellIdentifier;
    NSInteger lastMenuIndex;
}

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
    
    //Set the static string for cell identifiers
    lesserMenuCellIdentifier = @"LesserMenu";
    optionMenuCellIdentifier = @"Option";
    
    //Set the font for selected/unselected menu cell.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:lesserMenuCellIdentifier];
    unselectedFont = cell.textLabel.font;
    NSString *fontName = cell.textLabel.font.fontName;
    CGFloat fontSize = cell.textLabel.font.pointSize + 5.0f;
    selectedFont = [UIFont fontWithName:fontName size:fontSize];

    //Set the tableheaderview and tablefooterview
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    headerFrame.size.height = self.tableView.rowHeight;
    headerFrame.size.width = self.tableView.bounds.size.width;
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:headerFrame]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Generate the initial menulist
    [self menuListGeneration:0];
    
    //Generate the menulist for options
    fixedMenuList = [NSArray arrayWithObjects:@"设置", @"登出", nil];

    //Set the initial selected menu index
    lastMenuIndex = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:lastMenuIndex inSection:0];
    [self.tableView selectRowAtIndexPath:firstIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:firstIndexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = menuList.count;
            break;
        case 1:
            numberOfRows = fixedMenuList.count;
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *menuItem;
    switch (indexPath.section) {
        case 0:
            menuItem = menuList[indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:lesserMenuCellIdentifier];
            [cell.textLabel setText:[menuItem objectForKey:@"Title"]];
            [self formatCell:cell withFont:unselectedFont];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:optionMenuCellIdentifier];
            [cell.textLabel setText:[fixedMenuList objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    delegateOfRootView = (id)self.parentViewController;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //Close the menu
    [delegateOfRootView menuSwitch:NO];
    
    if ([cell.reuseIdentifier isEqualToString:lesserMenuCellIdentifier]) {
        //Format the cell
        [self formatCell:cell withFont:selectedFont];
        
        //Call the parentcontroller to switch lesser view
        NSString *selectedView = [menuList[indexPath.row] objectForKey:@"Identifier"];
        [delegateOfRootView switchSelectMenuView:selectedView];
        NSLog([menuList[indexPath.row] objectForKey:@"Title"]);
        lastMenuIndex = indexPath.row;
    }
    else if ([cell.textLabel.text isEqualToString:@"登出"]) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([cell.textLabel.text isEqualToString:@"设置"]) {
        NSLog(@"设置");
        [self viewWillAppear:NO];
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self formatCell:cell withFont:unselectedFont];
}

-(void)changeRootMenuToIndex:(NSInteger)rootMenuIndex
{
    [self menuListGeneration:rootMenuIndex];
    lastMenuIndex = 0;
    [self viewWillAppear:NO];
}

-(void)menuListGeneration:(NSInteger)rootMenuIndex
{
    //Get data from plist file
    NSString *menuListFile = [[NSBundle mainBundle] pathForResource:@"Captain_MenuList" ofType:@"plist"];
    NSDictionary *menuListDictionary = [[NSDictionary alloc] initWithContentsOfFile:menuListFile];
    NSArray *rootMenu = [menuListDictionary objectForKey:@"RootMenu"];

    //Set the title for tableHeaderView
    CGRect headerLabelFrame = self.tableView.tableHeaderView.bounds;
    headerLabelFrame.origin.x = 10.0f;
    UILabel *tableHeaderLabel = [[UILabel alloc] initWithFrame:headerLabelFrame];
    [tableHeaderLabel setText:[rootMenu objectAtIndex:rootMenuIndex]];
    [tableHeaderLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [tableHeaderLabel setTextColor:[UIColor whiteColor]];
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor lightGrayColor]];
    [self.tableView.tableHeaderView.subviews.firstObject removeFromSuperview];
    [self.tableView.tableHeaderView addSubview:tableHeaderLabel];
    
    //Generate the menuList
    menuList = [menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", (long)rootMenuIndex]];
    
    //Reload the table view
    [self.tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] init];
    [sectionHeader setBackgroundColor:[UIColor grayColor]];
    return sectionHeader;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooter = [[UIView alloc] init];
    [sectionFooter setBackgroundColor:[UIColor grayColor]];
    return sectionFooter;
}
-(void)formatCell:(UITableViewCell *)cell withFont:(UIFont *)font
{
    [cell.textLabel setFont:font];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
