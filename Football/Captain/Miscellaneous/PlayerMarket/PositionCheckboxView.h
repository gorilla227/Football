//
//  PositionCheckboxView.h
//  Football
//
//  Created by Andy on 14-8-28.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionCheckboxView : UIView
-(void)initWithPositionTitles:(NSArray *)positionTitles padding:(CGPoint)padding;
-(void)changeButtonFont:(UIFont *)buttonFont;
-(void)changeButtonTintColor:(UIColor *)tintColor;
-(void)changeButtonTextColor:(UIColor *)textColor;
-(void)adjustButtonPosition;

-(void)positionSelectionButtonOnClicked:(id)sender;
-(NSArray *)selectedPositions;
@end
