//
//  TableViewController_More.m
//  Soccer
//
//  Created by Andy on 15/3/8.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "TableViewController_More.h"

@implementation TableViewController_More {
    NSDictionary *labelTextsDictionary;
    NSDate *lastRefreshingDate;
}
@synthesize moreFooterView, moreLabel, moreActivityIndicator, loadMoreStatus, allowAutoRefreshing;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set More View
    moreFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width * 0.4, 30)];
    [moreLabel setCenter:moreFooterView.center];
    [moreLabel setTextColor:[UIColor whiteColor]];
    [moreLabel setTextAlignment:NSTextAlignmentCenter];
    [moreLabel setFont:[UIFont systemFontOfSize:15.0f]];
    moreActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [moreActivityIndicator setCenter:CGPointMake(moreLabel.frame.origin.x - 5 - moreActivityIndicator.bounds.size.width / 2, moreFooterView.center.y)];
    [moreActivityIndicator setHidesWhenStopped:YES];
    [moreFooterView addSubview:moreLabel];
    [moreFooterView addSubview:moreActivityIndicator];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewWillAppear:(BOOL)animated {
    if (allowAutoRefreshing) {
        if (!lastRefreshingDate || [[NSDate date] timeIntervalSinceDate:lastRefreshingDate] > [[gSettings objectForKey:@"autoRefreshPeriod"] integerValue]) {
            [self setLoadMoreStatus:LoadMoreStatus_LoadMore];
            [self startLoadingMore:YES];
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > MAX(scrollView.contentSize.height - scrollView.frame.size.height, 0) + 20 && !moreActivityIndicator.isAnimating) {
        [self startLoadingMore:NO];
    }
}

- (void)initialWithLabelTexts:(NSString *)labelTextsKey {
    if (!labelTextsKey) {
        labelTextsKey = @"Default";
    }
    labelTextsDictionary = [[gUIStrings objectForKey:@"UI_TableViewMore"] objectForKey:labelTextsKey];
    if (!labelTextsDictionary) {
        labelTextsDictionary = [[gUIStrings objectForKey:@"UI_TableViewMore"] objectForKey:@"Default"];
    }
    loadMoreStatus = LoadMoreStatus_NoData;
    [moreLabel setText:[labelTextsDictionary objectForKey:@"NoData"]];
    [moreActivityIndicator stopAnimating];
}

- (void)finishedLoadingWithNewStatus:(enum LoadMoreStatus)newStatus {
    switch (newStatus) {
        case LoadMoreStatus_LoadMore:
            [moreLabel setText:[labelTextsDictionary objectForKey:@"LoadMore"]];
            break;
        case LoadMoreStatus_NoData:
            [moreLabel setText:[labelTextsDictionary objectForKey:@"NoData"]];
            break;
        case LoadMoreStatus_NoMoreData:
            [moreLabel setText:[labelTextsDictionary objectForKey:@"NoMoreData"]];
            break;
        default:
            break;
    }
    loadMoreStatus = newStatus;
    [moreActivityIndicator stopAnimating];
    lastRefreshingDate = [NSDate date];
}

- (BOOL)startLoadingMore:(BOOL)isReload {
    if (isReload || loadMoreStatus == LoadMoreStatus_LoadMore || ![self.tableView.tableFooterView isEqual:moreFooterView]) {
        if (![self.tableView.tableFooterView isEqual:moreFooterView]) {
            [self.tableView setTableFooterView:moreFooterView];
        }
        [moreActivityIndicator startAnimating];
        [moreLabel setText:[labelTextsDictionary objectForKey:@"Loading"]];
        loadMoreStatus = LoadMoreStatus_Loading;
        return YES;
    }
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        [scrollView setContentOffset:CGPointZero];
    }
}

@end
