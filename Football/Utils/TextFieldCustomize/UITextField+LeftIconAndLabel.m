//
//  UITextField+LeftIconAndLabel.m
//  Football
//
//  Created by Andy Xu on 14-6-4.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "UITextField+LeftIconAndLabel.h"

@implementation UITextField (LeftIconAndLabel)

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [menuController setMenuVisible:NO];
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)initialLeftViewWithLabelName:(NSString *)labelName labelWidth:(CGFloat)labelWidth iconImage:(NSString *)imageFileName
{
    CGRect leftViewFrame = self.bounds;
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFileName]];
    CGFloat scaleValue = self.frame.size.height / leftIcon.frame.size.height;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleValue, scaleValue);
    [leftIcon setTransform:scaleTransform];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftIcon.frame.size.width + 10, 0, labelWidth, leftViewFrame.size.height)];
    [leftLabel setText:labelName];
    [leftLabel setTextAlignment:NSTextAlignmentLeft];
    [leftLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [leftLabel setFont:self.font];
    leftViewFrame.size.width = leftIcon.frame.size.width + leftLabel.frame.size.width;
    UIView *leftView = [[UIView alloc] initWithFrame:leftViewFrame];
    [leftView addSubview:leftIcon];
    [leftView addSubview:leftLabel];
    [self setLeftView:leftView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

-(void)initialLeftViewWithIconImage:(NSString *)imageFileName
{
    CGRect leftViewFrame = self.bounds;
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFileName]];
    [leftIcon setContentMode:UIViewContentModeScaleAspectFit];
    [leftIcon setFrame:CGRectMake(0, 0, leftViewFrame.size.height * 1.2, leftViewFrame.size.height)];
    [leftIcon setBackgroundColor:def_textFieldLeftIconBackground];
    [self.layer setCornerRadius:6.0f];
    [self.layer setBorderColor:def_textFieldBorderColor.CGColor];
    [self.layer setBorderWidth:0.6f];
    [self.layer setMasksToBounds:YES];
    [self setLeftView:leftIcon];
    [self setLeftViewMode:UITextFieldViewModeAlways];    
}

-(void)initialLeftViewWithIconImageClearStyle:(NSString *)imageFileName
{
    CGRect leftViewFrame = self.bounds;
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageFileName]];
    [leftIcon setContentMode:UIViewContentModeScaleAspectFit];
    [leftIcon setFrame:CGRectMake(0, 0, leftViewFrame.size.height * 1.2, leftViewFrame.size.height)];
    [self setLeftView:leftIcon];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}
@end
