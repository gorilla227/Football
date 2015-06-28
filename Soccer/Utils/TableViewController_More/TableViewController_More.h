//
//  TableViewController_More.h
//  Soccer
//
//  Created by Andy on 15/3/8.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
enum LoadMoreStatus {
    LoadMoreStatus_Loading,
    LoadMoreStatus_LoadMore,
    LoadMoreStatus_NoData,
    LoadMoreStatus_NoMoreData
};

@interface TableViewController_More : UITableViewController
@property UIView *moreFooterView;
@property UILabel *moreLabel;
@property UIActivityIndicatorView *moreActivityIndicator;
@property (nonatomic)enum LoadMoreStatus loadMoreStatus;
@property BOOL allowAutoRefreshing;
@property UIColor *topBounceBackgroundColor;

//Configuraion
- (void)initialWithLabelTexts:(NSString *)labelTextsKey;

//Actions
- (BOOL)startLoadingMore:(BOOL)isReload;
- (void)finishedLoadingWithNewStatus:(enum LoadMoreStatus)newStatus;
- (void)forceLoadTableView;
@end
