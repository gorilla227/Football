//
//  UITextFieldForStadiumSelection.h
//  SandBox_Map2
//
//  Created by Andy on 14-7-12.
//  Copyright (c) 2014年 Axu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextFieldForStadiumSelection : UITextField<UIPickerViewDataSource, UIPickerViewDelegate>
@property UIButton *selectHomeStadiumButton;
-(void)textFieldInitialization:(NSArray *)stadiums homeStadium:(Stadium *)homeStadium showSelectHomeStadium:(BOOL)shouldShowHomeStadium;
-(void)presetStadium:(Stadium *)stadium;
-(Stadium *)selectedStadium;
-(void)selectHomeStadium;
@end
