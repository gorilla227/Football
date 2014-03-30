//
//  UITextField_WithoutContextMenu.m
//  Football
//
//  Created by Andy on 14-3-28.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "UITextField_WithoutContextMenu.h"

@implementation UITextField_WithoutContextMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [menuController setMenuVisible:NO];
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
