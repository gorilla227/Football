//
//  StadiumListView.m
//  Football
//
//  Created by Andy Xu on 14-7-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "StadiumListView.h"

@interface StadiumListView_Cell()
@property IBOutlet UILabel *stadiumNameLabel;
@property IBOutlet UILabel *stadiumAddressLabel;
@property IBOutlet UILabel *distanceLabel;
@end

@implementation StadiumListView_Cell
@synthesize stadiumNameLabel, stadiumAddressLabel, distanceLabel;
@end

@interface StadiumListView ()
@property IBOutlet UIToolbar *addStadiumToolBar;
@property IBOutlet MKMapView *grandMapView;
@property IBOutlet UITableView *stadiumListTableView;
@end

@implementation StadiumListView{
    JSONConnect *connection;
    NSArray *stadiumList;
    NSArray *filteredStadiumList;
}
@synthesize addStadiumToolBar, grandMapView, stadiumListTableView;

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
    [self setToolbarItems:addStadiumToolBar.items];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
    
    //Set the tableview
    [stadiumListTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    [connection requestAllStadiums];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveAllStadiums:(NSArray *)stadiums
{
    stadiumList = stadiums;
    [self calculateAndSortStadiumsByDistance];
    [grandMapView addAnnotations:stadiumList];
    [grandMapView showAnnotations:@[stadiumList.firstObject, grandMapView.userLocation] animated:YES];
}

-(void)calculateAndSortStadiumsByDistance
{
    for (Stadium *stadium in stadiumList) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:stadium.coordinate.latitude longitude:stadium.coordinate.longitude];
        CLLocationDistance distance = [location distanceFromLocation:grandMapView.userLocation.location];
        [stadium setDistance:distance/1000];
    }
    NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    stadiumList = [stadiumList sortedArrayUsingDescriptors:@[sortByDistance]];
    [stadiumListTableView reloadData];
}

#pragma UITableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:stadiumListTableView]) {
        return stadiumList.count;
    }
    else {
        return filteredStadiumList.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StadiumListViewCell";
    StadiumListView_Cell *cell = [stadiumListTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Stadium *stadium;
    if ([tableView isEqual:stadiumListTableView]) {
        stadium = [stadiumList objectAtIndex:indexPath.row];
    }
    else {
        stadium = [filteredStadiumList objectAtIndex:indexPath.row];
    }

    [cell.stadiumNameLabel setText:stadium.stadiumName];
    [cell.stadiumAddressLabel setText:stadium.address];
    [cell.distanceLabel setText:[NSString stringWithFormat:@"%.1f %@", stadium.distance, [gUIStrings objectForKey:@"UI_StadiumDistanceUnit"]]];
    return cell;
}

#pragma Search Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *searchCondition = [NSPredicate predicateWithFormat:@"self.stadiumName contains[c] %@ || self.address contains[c] %@", searchString, searchString];
    filteredStadiumList = [stadiumList filteredArrayUsingPredicate:searchCondition];
    return YES;
}

#pragma MapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self calculateAndSortStadiumsByDistance];
    if (stadiumList.count > 0) {
        [grandMapView showAnnotations:@[stadiumList.firstObject, grandMapView.userLocation] animated:YES];
    }
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    Stadium *stadium = view.annotation;
    CLLocationCoordinate2D centerCoordinate = stadium.coordinate;
    centerCoordinate.latitude = centerCoordinate.latitude + 0.005;
    [mapView setCenterCoordinate:centerCoordinate animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [annotationView setRightCalloutAccessoryView:rightButton];
        [annotationView setCanShowCallout:YES];
    }
    else {
        [annotationView setAnnotation:annotation];
    }
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Stadium *selectedStadium = view.annotation;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[stadiumList indexOfObject:selectedStadium] inSection:0];
    [stadiumListTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self performSegueWithIdentifier:@"StadiumDetails" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"StadiumDetails"]) {
        StadiumDetails *stadiumDetailsViewController = segue.destinationViewController;
        [stadiumDetailsViewController setStadium:[stadiumList objectAtIndex:[stadiumListTableView indexPathForSelectedRow].row]];
    }
}

@end
