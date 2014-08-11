//
//  AddStadium_SelectAddress.m
//  Football
//
//  Created by Andy on 14-7-28.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "AddStadium_SelectAddress.h"

@interface AddStadium_SelectAddress ()
@property IBOutlet UITableView *portentousTableView;
@property IBOutlet MKMapView *portentousMapView;
@property IBOutlet UISearchBar *searchBar;
@end

@implementation AddStadium_SelectAddress{
    CGRect portentousTableViewFrame;
    CGRect hidePortentousTableViewFrame;
    NSArray *portentousList;
}
@synthesize portentousTableView, portentousMapView, searchBar;

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
    [self.navigationController setToolbarHidden:YES];
    
    portentousTableViewFrame = portentousMapView.frame;
    hidePortentousTableViewFrame = portentousMapView.frame;
    hidePortentousTableViewFrame.origin.y = portentousMapView.frame.size.height - portentousTableView.tableHeaderView.frame.size.height;
    hidePortentousTableViewFrame.size.height = portentousTableView.tableHeaderView.frame.size.height;
    

    [portentousMapView showAnnotations:@[portentousMapView.userLocation] animated:YES];
        [portentousMapView setRegion:MKCoordinateRegionMakeWithDistance(portentousMapView.centerCoordinate, 1500, 1500)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [portentousTableView setFrame:hidePortentousTableViewFrame];
    [super viewWillAppear:animated];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchBar resignFirstResponder];
}

-(IBAction)showPortentousTableView:(id)sender
{
    [UIView beginAnimations:@"Show/HidePortentousTableView" context:nil];
    [UIView setAnimationDuration:0.5f];
    if (CGRectEqualToRect(portentousTableView.frame, portentousTableViewFrame)) {
        [portentousTableView setFrame:hidePortentousTableViewFrame];
    }
    else {
        [portentousTableView setFrame:portentousTableViewFrame];
    }
    [UIView commitAnimations];
}

-(void)resetTableViewFrame
{
    portentousTableViewFrame.size.height = MIN(portentousList.count, 5) * portentousTableView.rowHeight + portentousTableView.tableHeaderView.frame.size.height;
    portentousTableViewFrame.origin.y = portentousMapView.frame.size.height - portentousTableViewFrame.size.height;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self resetTableViewFrame];
    return portentousList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PortentousCell";
    UITableViewCell *cell = [portentousTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [portentousTableView setFrame:hidePortentousTableViewFrame];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    [request setNaturalLanguageQuery:searchText];
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSMutableArray *placemarks = [NSMutableArray array];
        for (MKMapItem *mapItem in response.mapItems) {
            [placemarks addObject:mapItem.placemark];
            NSLog(@"mapItem.name: %@\nlocality: %@\ncountry: %@\ncountryCode: %@\nplacemark.name: %@\ntitle: %@\nthoroughfare: %@", mapItem.name, mapItem.placemark.locality, mapItem.placemark.country, mapItem.placemark.countryCode, mapItem.placemark.name, mapItem.placemark.title, mapItem.placemark.thoroughfare);
        }
        [portentousMapView removeAnnotations:portentousMapView.annotations];
        [portentousMapView showAnnotations:placemarks animated:YES];
        portentousList = placemarks;
    }];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [portentousTableView setFrame:portentousTableViewFrame];
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
