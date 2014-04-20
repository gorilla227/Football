//
//  TintTextView.m
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#define def_TintTextViewWidth 280
#import "TintTextView.h"

@implementation TintTextView

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
- (id)initWithTextKey:(NSString *)keyOfTintText underView:(UIView *)dockView;
{
    self = [super init];
    if(self) {
        //Get String
        NSString *tintListFile = [[NSBundle mainBundle] pathForResource:@"Tint_List" ofType:@"plist"];
        NSDictionary *tintList = [[NSDictionary alloc] initWithContentsOfFile:tintListFile];
        NSString *textString = [tintList objectForKey:keyOfTintText];
        [self setText:textString];
        
        //Get arrow
        UIImage *arrow = [UIImage imageNamed:@"tint_background_arrow.png"];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrow];
        [self.layer setMasksToBounds:NO];
        CGRect arrowFrame = arrowView.frame;
        arrowFrame.origin.x = 10;
        arrowFrame.origin.y = -arrow.size.height;
        [arrowView setFrame:arrowFrame];
        
        //Get frame
        CGRect frame = dockView.frame;
        frame.origin.x += 10;
        frame.origin.y += frame.size.height + arrow.size.height;
        frame.size.width = def_TintTextViewWidth;
        frame.size.height = [self sizeThatFits:CGSizeMake(def_TintTextViewWidth, FLT_MAX)].height;
        [self setFrame:frame];
        [self addSubview:arrowView];
        
        //Set backgroundcolor and cornerRadius
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.5f];
        [self.layer setCornerRadius:5.0f];
    }
    return self;
}
@end
