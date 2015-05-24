//
//  StadiumListView.m
//  Soccer
//
//  Created by Andy Xu on 14-7-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "StadiumListView.h"
#import "StadiumDetails.h"
#import "StadiumAdd.h"

@interface StadiumListView_Cell()
@property IBOutlet UILabel *stadiumNameLabel;
@property IBOutlet UILabel *stadiumAddressLabel;
@property IBOutlet UILabel *distanceLabel;
@end

@implementation StadiumListView_Cell
@synthesize stadiumNameLabel, stadiumAddressLabel, distanceLabel;
@end

@interface StadiumListView ()
@property IBOutlet MKMapView *grandMapView;
@property IBOutlet UITableView *stadiumListTableView;
@property IBOutlet UISearchBar *stadiumFilterBar;
@property IBOutlet UIButton *cancelAddStadiumButton;
@end

@implementation StadiumListView{
    JSONConnect *connection;
    NSArray *stadiumList;
    NSArray *filteredStadiumList;
    Stadium *newStadium;
}
@synthesize grandMapView, stadiumListTableView, stadiumFilterBar, cancelAddStadiumButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Set the tableview
    [stadiumListTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [stadiumListTableView.layer setCornerRadius:10.0f];
    [stadiumListTableView.layer setMasksToBounds:YES];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
    
    stadiumList = gStadiums;
    filteredStadiumList = gStadiums;
    [self calculateAndSortStadiumsByDistance];
    [grandMapView addAnnotations:filteredStadiumList];
    [grandMapView showAnnotations:@[filteredStadiumList.firstObject, grandMapView.userLocation] animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    
    if (newStadium && newStadium.stadiumId) {
        stadiumList = [stadiumList arrayByAddingObject:newStadium];
        if ([stadiumFilterBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
            NSPredicate *searchCondition = [NSPredicate predicateWithFormat:@"self.stadiumName contains[c] %@ || self.address contains[c] %@", stadiumFilterBar.text, stadiumFilterBar.text];
            filteredStadiumList = [stadiumList filteredArrayUsingPredicate:searchCondition];
        }
        else {
            filteredStadiumList = stadiumList;
        }
        [self calculateAndSortStadiumsByDistance];
        [grandMapView removeAnnotation:newStadium];
        Stadium *savedStadium = newStadium;
        newStadium = nil;
        [grandMapView addAnnotation:savedStadium];
        [grandMapView selectAnnotation:savedStadium animated:YES];
    }
    [cancelAddStadiumButton setEnabled:newStadium];
    
    CGRect tableFrame = stadiumListTableView.frame;
    tableFrame.size.height = MIN(filteredStadiumList.count, 4) * stadiumListTableView.rowHeight;
    [stadiumListTableView setFrame:tableFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelSearch:(id)sender {
    [stadiumFilterBar resignFirstResponder];
}

- (IBAction)cancelNewStadiumAnnotation:(id)sender {
    if (newStadium) {
        [grandMapView removeAnnotation:newStadium];
        newStadium = nil;
        [cancelAddStadiumButton setEnabled:NO];
    }
    [self returnToUserLocation:nil];
}

- (void)calculateAndSortStadiumsByDistance {
    for (Stadium *stadium in filteredStadiumList) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:stadium.coordinate.latitude longitude:stadium.coordinate.longitude];
        CLLocationDistance distance = [location distanceFromLocation:grandMapView.userLocation.location];
        [stadium setDistance:distance/1000];
    }
    NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    filteredStadiumList = [filteredStadiumList sortedArrayUsingDescriptors:@[sortByDistance]];
    [stadiumListTableView reloadData];
}

- (IBAction)returnToUserLocation:(id)sender {
    if (filteredStadiumList.count) {
        [grandMapView showAnnotations:@[filteredStadiumList.firstObject, grandMapView.userLocation] animated:YES];
    }
    else {
        [grandMapView showAnnotations:@[grandMapView.userLocation] animated:YES];
    }
}

#pragma UITableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    CGRect tableFrame = stadiumListTableView.frame;
    tableFrame.size.height = MIN(filteredStadiumList.count, 4) * stadiumListTableView.rowHeight;
    [stadiumListTableView setFrame:tableFrame];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredStadiumList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StadiumListViewCell";
    StadiumListView_Cell *cell = [stadiumListTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Stadium *stadium;
    stadium = [filteredStadiumList objectAtIndex:indexPath.row];

    [cell.stadiumNameLabel setText:stadium.stadiumName];
    [cell.stadiumAddressLabel setText:stadium.address];
    [cell.distanceLabel setText:[NSString stringWithFormat:@"%.1f %@", stadium.distance, [gUIStrings objectForKey:@"UI_StadiumDistanceUnit"]]];
    return cell;
}

#pragma Search Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
        NSPredicate *searchCondition = [NSPredicate predicateWithFormat:@"self.stadiumName contains[c] %@ || self.address contains[c] %@", searchText, searchText];
        filteredStadiumList = [stadiumList filteredArrayUsingPredicate:searchCondition];
    }
    else {
        filteredStadiumList = stadiumList;
    }
    [stadiumListTableView reloadData];
    
    [grandMapView removeAnnotations:grandMapView.annotations];
    [grandMapView addAnnotations:filteredStadiumList];
    if (filteredStadiumList.count) {
        [grandMapView showAnnotations:@[filteredStadiumList.firstObject, grandMapView.userLocation] animated:YES];
    }
    else {
        [grandMapView showAnnotations:@[grandMapView.userLocation] animated:YES];
    }
}

#pragma MapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self calculateAndSortStadiumsByDistance];
    if (filteredStadiumList.count > 0) {
        [grandMapView showAnnotations:@[filteredStadiumList.firstObject, grandMapView.userLocation] animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    Stadium *stadium = view.annotation;
    [mapView showAnnotations:@[stadium] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isEqual:newStadium]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"NewStadium"];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"NewStadium"];
            [annotationView setPinColor:MKPinAnnotationColorPurple];
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [annotationView setRightCalloutAccessoryView:rightButton];
            [annotationView setCanShowCallout:YES];
            [annotationView setAnimatesDrop:YES];
        }
        else {
            [annotationView setAnnotation:annotation];
        }

        return annotationView;
    }
    else {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ExistedStadium"];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ExistedStadium"];
            [annotationView setPinColor:MKPinAnnotationColorRed];
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [annotationView setRightCalloutAccessoryView:rightButton];
            [annotationView setCanShowCallout:YES];
        }
        else {
            [annotationView setAnnotation:annotation];
        }
        return annotationView;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    Stadium *selectedStadium = view.annotation;
    if ([selectedStadium isEqual:newStadium]) {
        [self performSegueWithIdentifier:@"AddStadium" sender:self];
    }
    else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[filteredStadiumList indexOfObject:selectedStadium] inSection:0];
        [stadiumListTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self performSegueWithIdentifier:@"StadiumDetails" sender:self];
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [stadiumListTableView setAlpha:0.5];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [stadiumListTableView setAlpha:1.0];
}

- (IBAction)longPressToAddNewStadium:(UILongPressGestureRecognizer *)longPressGestureRecognizer; {
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint clickPoint = [longPressGestureRecognizer locationOfTouch:0 inView:grandMapView];
        CLLocationCoordinate2D newStadiumCoordinate = [grandMapView convertPoint:clickPoint toCoordinateFromView:grandMapView];
        if (newStadium) {
            [grandMapView removeAnnotation:newStadium];
        }
        newStadium = [Stadium new];
        [newStadium setCoordinate:newStadiumCoordinate];
        CLGeocoder *geocoder = [CLGeocoder new];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:newStadium.coordinate.latitude longitude:newStadium.coordinate.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = placemarks.firstObject;
            [newStadium setAddress:[[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]];
            [newStadium setStadiumName:[placemark.addressDictionary objectForKey:@"Name"]];
            [grandMapView addAnnotation:newStadium];
            [grandMapView selectAnnotation:newStadium animated:YES];
        }];
        
        [cancelAddStadiumButton setEnabled:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"StadiumDetails"]) {
        StadiumDetails *stadiumDetailsViewController = segue.destinationViewController;
        [stadiumDetailsViewController setStadium:[filteredStadiumList objectAtIndex:[stadiumListTableView indexPathForSelectedRow].row]];
    }
    else if ([segue.identifier isEqualToString:@"AddStadium"]) {
        StadiumAdd *stadiumAddViewController = segue.destinationViewController;
        [stadiumAddViewController setPotentousStadium:newStadium];
    }
}

@end
