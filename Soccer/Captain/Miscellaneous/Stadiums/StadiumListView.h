//
//  StadiumListView.h
//  Soccer
//
//  Created by Andy Xu on 14-7-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StadiumListView_Cell : UITableViewCell

@end

@interface StadiumListView : UIViewController<UITableViewDataSource, UITableViewDelegate, JSONConnectDelegate, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>
-(void)calculateAndSortStadiumsByDistance;
@end
