//
//  UITextFieldForMatchScore.h
//  Football
//
//  Created by Andy on 15/1/24.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScoreChanged <NSObject>
- (void)didScoreChangedWithHomeScore:(NSInteger)homeScore andAwayScore:(NSInteger)awayScore;
@end

@interface UITextFieldForMatchScore : UITextField<UIPickerViewDataSource, UIPickerViewDelegate>
@property IBOutlet id<ScoreChanged>delegateForScore;
-(void)initialTextFieldForMatchScore:(BOOL)regularMatchFlag;
-(void)presetHomeScore:(NSInteger)homeScore andAwayScore:(NSInteger)awayScore;
-(NSInteger)homeScore;
-(NSInteger)awayScore;
@end
