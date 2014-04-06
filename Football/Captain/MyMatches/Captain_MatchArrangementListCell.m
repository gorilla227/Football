//
//  Captain_MatchArrangementListCell.m
//  Football
//
//  Created by Andy on 14-4-6.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MatchArrangementListCell.h"

@implementation Captain_MatchArrangementListCell
@synthesize numberOfAcceptPlayers, progressOfAcceptPlayers;
@synthesize matchDate, matchTime, matchOpponent, matchPlace, matchType;
@synthesize noticePlayer;

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
