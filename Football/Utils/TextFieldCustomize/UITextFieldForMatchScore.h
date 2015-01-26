//
//  UITextFieldForMatchScore.h
//  Football
//
//  Created by Andy on 15/1/24.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextFieldForMatchScore : UITextField<UIPickerViewDataSource, UIPickerViewDelegate>
@property BOOL isRegularMatch;
-(void)initialTextFieldForMatchScore;
-(void)presetHomeScore:(NSInteger)homeScore andAwayScore:(NSInteger)awayScore;
@end
