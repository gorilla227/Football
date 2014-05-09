//
//  Captain_CreateMatch_SelectMatchStadium.h
//  Football
//
//  Created by Andy on 14-4-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HintTextView.h"
#import "Captain_CreateMatch_StadiumList.h"

@protocol SelectMatchPlace <NSObject>
-(void)receiveSelectedStadium:(Stadium *)selectedStadium indexOfHomeStadium:(NSInteger)index;
@end

@interface Captain_CreateMatch_SelectMatchStadium : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, JSONConnectDelegate, SelectStadium>
@property id<SelectMatchPlace>delegate;
@property NSInteger indexOfSelectedHomeStadium;
@property Stadium *matchStadium;
@property IBOutlet UITableView *homeStadiumTableView;
@property IBOutlet UITextField *matchPlaceTextField;
@property IBOutlet UIBarButtonItem *saveButton;
@property IBOutlet UIView *stadiumListView;
@end
