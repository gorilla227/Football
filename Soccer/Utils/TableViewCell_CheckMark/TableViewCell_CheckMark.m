//
//  TableViewCell_CheckMark.m
//  Soccer
//
//  Created by Andy on 15/5/28.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "TableViewCell_CheckMark.h"

@implementation TableViewCell_CheckMark {
    UIButton *checkMarkButton;
    UIView *checkMarkBackgroundView;
    UIColor *checkedTintColor;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    if (!checkMarkButton) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                checkMarkButton = (UIButton *)view;
                CGRect frame = checkMarkButton.frame;
                CGPoint center = checkMarkButton.center;
                CGFloat extentBackgroundSideLength = fmaxf(frame.size.width, frame.size.height) * 2;
                frame.size.width = extentBackgroundSideLength;
                frame.size.height = extentBackgroundSideLength;
                checkMarkBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, extentBackgroundSideLength, extentBackgroundSideLength)];
                [self addSubview:checkMarkBackgroundView];
                [checkMarkBackgroundView setCenter:center];
                [checkMarkBackgroundView.layer setCornerRadius:extentBackgroundSideLength/2];
                [checkMarkBackgroundView.layer setMasksToBounds:YES];
                [checkMarkBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
                checkedTintColor = checkMarkButton.tintColor;
                [checkMarkButton setTintColor:[UIColor clearColor]];
                [self bringSubviewToFront:checkMarkButton];
                break;
            }
        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!CGPointEqualToPoint(checkMarkButton.center, checkMarkBackgroundView.center)) {
        [checkMarkBackgroundView setCenter:checkMarkButton.center];
    }
}

- (void)changeCheckMarkStatus:(BOOL)status {
    [checkMarkButton setTintColor:status?checkedTintColor:[UIColor clearColor]];
}

- (void)shouldHiddenCheckMarkBackground:(BOOL)shouldHidden {
    [checkMarkBackgroundView setHidden:shouldHidden];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
