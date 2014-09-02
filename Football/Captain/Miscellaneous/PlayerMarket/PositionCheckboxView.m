//
//  PositionCheckboxView.m
//  Football
//
//  Created by Andy on 14-8-28.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "PositionCheckboxView.h"

@implementation PositionCheckboxView{
    NSMutableArray *positionButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initWithPositionTitles:(NSArray *)positionTitles padding:(CGPoint)padding
{
    //Calculate cellSize
    CGFloat cellWidth = (self.frame.size.width - (positionTitles.count + 1) * padding.x) / positionTitles.count;
    CGFloat cellHeight = self.frame.size.height - padding.y * 2;
    
    //Generate all cells
    positionButtons = [NSMutableArray new];
    for (int i = 0; i < positionTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake((i + 1) * padding.x + i * cellWidth, padding.y, cellWidth, cellHeight)];
        [button setTitle:[positionTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(positionSelectionButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setSelected:YES];
        [positionButtons addObject:button];
        [self addSubview:button];
    }
}

-(void)changeButtonFont:(UIFont *)buttonFont
{
    for (UIButton *button in positionButtons) {
        [button.titleLabel setFont:buttonFont];
    }
}

-(void)changeButtonTintColor:(UIColor *)tintColor
{
    for (UIButton *button in positionButtons) {
        [button setTintColor:tintColor];
    }
}

-(void)changebuttonTextColor:(UIColor *)textColor
{
    for (UIButton *button in positionButtons) {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
}

-(void)positionSelectionButtonOnClicked:(id)sender
{
    UIButton *positionSelectionButton = sender;
    BOOL haveButtonSeleced = !positionSelectionButton.isSelected;
    if (!haveButtonSeleced) {
        for (UIButton *button in positionButtons) {
            if (![button isEqual:positionSelectionButton] && button.isSelected) {
                haveButtonSeleced = YES;
                break;
            }
        }
    }
    if (haveButtonSeleced) {
        [positionSelectionButton setSelected:!positionSelectionButton.isSelected];
    }
}

-(NSArray *)selectedPositions
{
    NSMutableArray *selectedPositions = [NSMutableArray new];
    for (UIButton *positionButton in positionButtons) {
        if (positionButton.isSelected) {
            [selectedPositions addObject:[NSNumber numberWithInteger:[positionButtons indexOfObject:positionButton]]];
        }
    }
    return selectedPositions;
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
