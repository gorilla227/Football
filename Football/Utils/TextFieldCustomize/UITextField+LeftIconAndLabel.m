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
    UIImageView *leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leftViewFrame.size.height, leftViewFrame.size.height)];
    [leftIcon setImage:[UIImage imageNamed:imageFileName]];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftIcon.frame.size.width, 0, labelWidth, leftViewFrame.size.height)];
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
@end
