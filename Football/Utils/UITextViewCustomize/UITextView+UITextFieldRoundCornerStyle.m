//
//  UITextView+UITextFieldRoundCornerStyle.m
//  Football
//
//  Created by Andy on 14-8-2.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "UITextView+UITextFieldRoundCornerStyle.h"

@implementation UITextView (UITextFieldRoundCornerStyle)
-(void)initializeUITextFieldRoundCornerStyle
{
    [self.layer setBorderColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1].CGColor];
    [self.layer setBorderWidth:0.6f];
    [self.layer setCornerRadius:6.0f];
}
@end
