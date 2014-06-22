//
//  UITextField+LeftIconAndLabel.h
//  Football
//
//  Created by Andy Xu on 14-6-4.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LeftIconAndLabel)
-(void)initialLeftViewWithLabelName:(NSString *)labelName labelWidth:(CGFloat)labelWidth iconImage:(NSString *)imageFileName;
-(void)initialLeftViewWithIconImage:(NSString *)imageFileName;
@end
