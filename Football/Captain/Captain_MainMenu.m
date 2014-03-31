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
}
@synthesize delegate;

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
    
    [self menuListGeneration:0];
    [self.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *menuItem = menuList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[menuItem objectForKey:@"Type"]];
    
    // Configure the cell...
    [cell.textLabel setText:[menuItem objectForKey:@"Title"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog([menuList[indexPath.row] objectForKey:@"Title"]);
    delegate = (id)self.parentViewController;
    [delegate menuSwitch:NO];
}

-(void)menuListGeneration:(NSInteger)rootMenuIndex
{
    //Get part menu list
    NSString *menuListFile = [[NSBundle mainBundle] pathForResource:@"Captain_MenuList" ofType:@"plist"];
    NSDictionary *menuListDictionary = [[NSDictionary alloc] initWithContentsOfFile:menuListFile];
    NSArray *rootMenu = [menuListDictionary objectForKey:@"RootMenu"];
    menuList = [[NSMutableArray alloc] init];
    NSDictionary *menuItem = [[NSDictionary alloc] initWithObjectsAndKeys:rootMenu[rootMenuIndex], @"Title", @"Root", @"Type", nil];
    [menuList addObject:menuItem];
    NSArray *lesserMenu = [menuListDictionary objectForKey:[NSString stringWithFormat:@"%li", (long)rootMenuIndex]];
    for (NSString *menuItemName in lesserMenu) {
        menuItem = [[NSDictionary alloc] initWithObjectsAndKeys:menuItemName, @"Title", @"Lesser", @"Type", nil];
        [menuList addObject:menuItem];
    }
    [self.tableView reloadData];
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
