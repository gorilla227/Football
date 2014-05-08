//
//  Captain_CreateMatch_SelectPlayground.h
//  Football
//
//  Created by Andy on 14-4-26.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HintTextView.h"

@protocol SelectPlayground <NSObject>
-(void)receiveSelectedPlayground:(NSString *)playgroundName indexOfMainPlayground:(NSInteger)index;
@end

@interface Captain_CreateMatch_SelectPlayground : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property id<SelectPlayground>delegate;
@property NSInteger indexOfSelectedMainPlayground;
@property NSString *selectedPlace;
@property IBOutlet UITableView *mainPlayground;
@property IBOutlet UITextField *matchPlaceTextField;
@property IBOutlet UIBarButtonItem *saveButton;
@property IBOutlet UIView *stadiumListView;
@end
