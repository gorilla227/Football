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
    NSString *menuCellIdentifier;
    NSInteger lastRootMenuIndex;
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
    menuCellIdentifier = @"Menu";
    
    //Set the font for selected/unselected menu cell.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    unselectedFont = cell.detailTextLabel.font;
    CGFloat fontSize = cell.detailTextLabel.font.pointSize + 3.0f;
    selectedFont = [UIFont boldSystemFontOfSize:fontSize];

    //Set the tableheaderview and tablefooterview
    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    headerFrame.size.height = self.tableView.sectionFooterHeight;
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:headerFrame]];

    //Generate the initial menulist
    [self menuListGeneration:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:lastRootMenuIndex + 1 inSection:0];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *menuItem;

    //Menu List
    menuItem = menuList[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
    if ([[menuItem objectForKey:@"Level"] isEqualToString:@"Root"]) {
        //Root Menu Item
        [cell.textLabel setText:[menuItem objectForKey:@"Title"]];
        [cell.detailTextLabel setText:nil];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([[menuItem objectForKey:@"Level"] isEqualToString:@"Lesser"]) {
        //Lesser Menu Item
        [cell.textLabel setText:nil];
        [cell.detailTextLabel setText:[menuItem objectForKey:@"Title"]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self formatCell:cell withFont:unselectedFont];
    }
    [cell setUserInteractionEnabled:(indexPath.row != lastRootMenuIndex)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    delegateOfRootView = (id)self.parentViewController;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *menuItem = [menuList objectAtIndex:indexPath.row];
    
    if ([[menuItem objectForKey:@"Level"] isEqualToString:@"Root"]) {
        if (indexPath.row != lastRootMenuIndex) {
            [self menuListGeneration:[[menuItem objectForKey:@"RootMenuIndex"] integerValue]];
            [self viewWillAppear:NO];
        }
    }
    else if ([[menuItem objectForKey:@"Level"] isEqualToString:@"Lesser"]) {
        //Format the cell
        [self formatCell:cell withFont:selectedFont];
        
        //Call the parentcontroller to switch lesser view
        NSString *selectedView = [menuList[indexPath.row] objectForKey:@"Identifier"];
        [delegateOfRootView switchSelectMenuView:selectedView];
        NSLog([menuList[indexPath.row] objectForKey:@"Title"]);

        //Close the menu
        [delegateOfRootView menuSwitch:NO];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self formatCell:cell withFont:unselectedFont];
}

//-(void)changeRootMenuToIndex:(NSInteger)rootMenuIndex
//{
//    [self menuListGeneration:rootMenuIndex];
//    [self viewWillAppear:NO];
//}

-(void)menuListGeneration:(NSInteger)rootMenuIndex
{
    lastRootMenuIndex = rootMenuIndex;

    //Get data from plist file
    NSString *menuListFile = [[NSBundle mainBundle] pathForResource:@"Captain_MenuList" ofType:@"plist"];
    NSDictionary *menuListDictionary = [[NSDictionary alloc] initWithContentsOfFile:menuListFile];

    //Generate the menuList
    menuList = [[NSMutableArray alloc] init];
    NSArray *rootMenu = [menuListDictionary objectForKey:@"RootMenu"];
    for (NSString *rootMenuItem in rootMenu) {
        //Add the rootMenuItem
        NSMutableDictionary *menuItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:rootMenuItem, @"Title", @"Root", @"Level", [NSNumber numberWithInteger:[rootMenu indexOfObject:rootMenuItem]], @"RootMenuIndex", nil];
        [menuList addObject:menuItem];
        if ([rootMenu indexOfObject:rootMenuItem] == rootMenuIndex) {
            //Add the lesserMenuItem
            for (NSDictionary *lesserMenuItem in [menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", (long)rootMenuIndex]]) {
                menuItem = [[NSMutableDictionary alloc] initWithDictionary:lesserMenuItem];
                [menuItem setObject:@"Lesser" forKey:@"Level"];
                [menuList addObject:menuItem];
            }
        }
    }
    
    //Reload the table view
    [self.tableView reloadData];
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
    delegateOfRootView = (id)self.parentViewController;
    NSLog(@"设置");
    [delegateOfRootView menuSwitch:NO];
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
