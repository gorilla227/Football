//
//  TableViewController_More.h
//  Football
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
@property enum LoadMoreStatus loadMoreStatus;

//Configuraion
- (void)initialWithLabelTexts:(NSString *)labelTextsKey;

//Actions
- (BOOL)startLoadingMore;
- (void)finishedLoadingWithNewStatus:(enum LoadMoreStatus)newStatus;
@end
