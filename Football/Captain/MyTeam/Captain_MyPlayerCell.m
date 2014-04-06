//
//  Captain_MyPlayerCell.m
//  Football
//
//  Created by Andy on 14-4-6.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MyPlayerCell.h"

@implementation Captain_MyPlayerCell
@synthesize playerIcon, playerName, signUpStatusOfNextMatch, signUpTitleOfLeague, signUpStatusOfLeague, likeScore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
