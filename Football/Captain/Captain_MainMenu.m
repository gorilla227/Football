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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Lesser"];
    unselectedFont = cell.textLabel.font;
    NSString *fontName = cell.textLabel.font.fontName;
    CGFloat fontSize = cell.textLabel.font.pointSize + 5.0f;
    selectedFont = [UIFont fontWithName:fontName size:fontSize];

    CGRect headerFrame = self.tableView.tableHeaderView.frame;
    //    headerFrame.size.height = self.tableView.sectionHeaderHeight;
    headerFrame.size.height = self.tableView.rowHeight;
    headerFrame.size.width = self.tableView.bounds.size.width;
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:headerFrame]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self menuListGeneration:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
    NSInteger numberOfRows;
    if (section == 0) {
        numberOfRows = menuList.count;
    }
    else {
        numberOfRows = 2;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        NSDictionary *menuItem = menuList[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:[menuItem objectForKey:@"Type"]];
        
        // Configure the cell...
        [cell.textLabel setText:[menuItem objectForKey:@"Title"]];
//        if ([cell.reuseIdentifier isEqualToString: @"Lesser"]) {
            [self formatCell:cell withFont:unselectedFont];
//        }
//        if ([cell.textLabel.text isEqualToString:@"登出"]) {
//            [cell setUserInteractionEnabled:YES];
//        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Root"];
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"设置"];
        }
        else {
            [cell.textLabel setText:@"登出"];
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    delegateOfRootView = (id)self.parentViewController;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"Lesser"]) {
        //Format the cell
        [self formatCell:cell withFont:selectedFont];
        
        //Close the menu
        [delegateOfRootView menuSwitch:NO];
        
        //Call the parentcontroller to switch lesser view
        NSString *selectedView = [menuList[indexPath.row] objectForKey:@"Identifier"];
        [delegateOfRootView switchSelectMenuView:selectedView];
        NSLog([menuList[indexPath.row] objectForKey:@"Title"]);
    }
    else if ([cell.textLabel.text isEqualToString:@"登出"]) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([cell.textLabel.text isEqualToString:@"设置"]) {
        //Close the menu
        [delegateOfRootView menuSwitch:NO];
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
    [self viewWillAppear:NO];
}

-(void)menuListGeneration:(NSInteger)rootMenuIndex
{
    //Get part menu list
    NSString *menuListFile = [[NSBundle mainBundle] pathForResource:@"Captain_MenuList" ofType:@"plist"];
    NSDictionary *menuListDictionary = [[NSDictionary alloc] initWithContentsOfFile:menuListFile];
    NSArray *rootMenu = [menuListDictionary objectForKey:@"RootMenu"];
    menuList = [[NSMutableArray alloc] init];
    NSDictionary *menuItem = [[NSDictionary alloc] initWithObjectsAndKeys:rootMenu[rootMenuIndex], @"Title", @"Root", @"Type", nil];
//    [menuList addObject:menuItem];
    
    CGRect headerLabelFrame = self.tableView.tableHeaderView.bounds;
    headerLabelFrame.origin.x = 10.0f;
    UILabel *tableHeaderLabel = [[UILabel alloc] initWithFrame:headerLabelFrame];
    [tableHeaderLabel setText:[menuItem objectForKey:@"Title"]];
    [tableHeaderLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [tableHeaderLabel setTextColor:[UIColor whiteColor]];
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor lightGrayColor]];
    [self.tableView.tableHeaderView.subviews.firstObject removeFromSuperview];
    [self.tableView.tableHeaderView addSubview:tableHeaderLabel];
    
    NSArray *lesserMenu = [menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", (long)rootMenuIndex]];
    for (NSDictionary *menuItemInLesserMenu in lesserMenu) {
        menuItem = [[NSDictionary alloc] initWithObjectsAndKeys:[menuItemInLesserMenu objectForKey:@"Title"], @"Title", @"Lesser", @"Type", [menuItemInLesserMenu objectForKey:@"Identifier"], @"Identifier", nil];
        [menuList addObject:menuItem];
    }
//    menuItem = [[NSDictionary alloc] initWithObjectsAndKeys:@"登出", @"Title", @"Root", @"Type", nil];
//    [menuList addObject:menuItem];
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
