//
//  UITextFieldForActivityRegion.h
//  Football
//
//  Created by Andy Xu on 14-6-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextFieldForActivityRegion : UITextField<UIPickerViewDataSource, UIPickerViewDelegate>
@property NSArray *selectedActivityRegionCode;
-(void)activityRegionTextField;
@end
