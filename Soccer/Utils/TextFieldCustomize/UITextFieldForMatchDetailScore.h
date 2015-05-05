//
//  UITextFieldForMatchDetailScore.h
//  Soccer
//
//  Created by Andy on 15/3/21.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScoreDetailChanged <NSObject>
- (void)didScoreDetailChanged:(MatchScore *)updatedScore forIndex:(NSInteger)index;
@end

@interface UITextFieldForMatchDetailScore : UITextField<UIPickerViewDataSource, UIPickerViewDelegate>
@property IBOutlet id<ScoreDetailChanged>delegateForScoreDetail;
- (void)initialTextFieldForMatchDetailScore:(MatchScore *)score withMatchAttendance:(NSArray *)matchAttendance forMatch:(Match *)match;
@end

@interface MatchAttendancePickerView : UIPickerView
@property NSInteger goalPlayerIndex;
@property NSInteger assistPlayerIndex;
@end
