//
//  HintTextView.m
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#import "HintTextView.h"

@implementation HintTextView
@synthesize boundedView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)settingHintWithTextKey:(NSString *)keyOfHintText underView:(UIView *)dockView wantShow:(BOOL)showNow;
{
    //Get String
    NSString *hintListFile = [[NSBundle mainBundle] pathForResource:@"Hint_List" ofType:@"plist"];
    NSDictionary *hintList = [[NSDictionary alloc] initWithContentsOfFile:hintListFile];
    NSString *textString = [hintList objectForKey:keyOfHintText];
    [self setText:textString];
    [self setTextColor:[UIColor whiteColor]];
    [self setFont:[UIFont fontWithName:self.font.fontName size:14]];
    
    //Get arrow
    UIImage *arrow = [UIImage imageNamed:@"tint_background_arrow.png"];
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrow];
    [self.layer setMasksToBounds:NO];
    CGRect arrowFrame = arrowView.frame;
    arrowFrame.origin.x = 20;
    arrowFrame.origin.y = -arrow.size.height;
    [arrowView setFrame:arrowFrame];
    
    //Get frame
    CGRect frame = dockView.frame;
    frame.origin.x += 5;
    frame.origin.y += frame.size.height + arrow.size.height;
    frame.size.width = 320 - frame.origin.x * 2;
    frame.size.height = [self sizeThatFits:CGSizeMake(frame.size.width, FLT_MAX)].height;
    [self setFrame:frame];
    [self addSubview:arrowView];
    
    //Set backgroundcolor and cornerRadius
    [self setBackgroundColor:[UIColor blackColor]];
    [self setAlpha:0.5f];
    [self.layer setCornerRadius:5.0f];
    
    //Set attributes
    [self setSelectable:NO];
    [self setEditable:NO];
    [self setScrollEnabled:NO];
    
    //Set the boundedView
    boundedView = dockView;
    
    //Show or Hide hint;
    [self showOrHideHint:showNow];
}

- (void)showOrHideHint:(BOOL)flag
{
    [self setHidden:!flag];
}
@end
