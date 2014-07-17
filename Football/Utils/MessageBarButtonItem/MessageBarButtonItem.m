//
//  MessageBarButtonItem.m
//  Football
//
//  Created by Andy on 14-7-16.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "MessageBarButtonItem.h"

@implementation MessageBarButtonItem{
    UILabel *badgeView;
    UIButton *actionButton;
}

@synthesize delegate, badgeNumber;

-(void)initBadgeView
{
    if (!actionButton) {
        actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        badgeView = [[UILabel alloc] initWithFrame:CGRectMake(15, -5, 14, 14)];
        [badgeView.layer setCornerRadius:7.0f];
        [badgeView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [badgeView.layer setBorderWidth:1.5f];
        [badgeView.layer setMasksToBounds:YES];
        [badgeView setAdjustsFontSizeToFitWidth:YES];
        [badgeView setBackgroundColor:[UIColor redColor]];
        [badgeView setTextAlignment:NSTextAlignmentCenter];
        [badgeView setTextColor:[UIColor whiteColor]];
        [badgeView setFont:[UIFont boldSystemFontOfSize:8.0f]];
        [badgeView setHidden:YES];
        [actionButton addSubview:badgeView];
        [actionButton setImage:[UIImage imageNamed:@"messageIcon.png"] forState:UIControlStateNormal];
        [actionButton addTarget:delegate action:@selector(messageButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self setCustomView:actionButton];
    }
}

-(void)setBadgeNumber:(NSInteger)number
{
    badgeNumber = number;
    if (!actionButton) {
        [self initBadgeView];
    }
    
    if (number == 0) {
        [badgeView setHidden:YES];
    }
    else {
        [badgeView setHidden:NO];
        if (number < 20) {
            [badgeView setText:[NSString stringWithFormat:@"%li", (long)number]];
        }
        else {
            [badgeView setText:@"..."];
        }
    }
}
@end
