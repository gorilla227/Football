//
//  Captain_NewPlayer_InviteeCell.m
//  Football
//
//  Created by Andy on 14-4-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_NewPlayer_InviteeCell.h"

@implementation Captain_NewPlayer_InviteeCell
@synthesize playerName, postion, age, team, comment, status, cancelInvitationButton;

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

-(IBAction)cancelInvitationButtonOnClicked:(id)sender
{
    UIAlertView *confirmCancel = [[UIAlertView alloc] initWithTitle:@"取消邀请" message:[NSString stringWithFormat:@"确定要取消对%@的邀请吗？", playerName.text] delegate:self cancelButtonTitle:@"撤销操作" otherButtonTitles:@"确定", nil];
    [confirmCancel show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [cancelInvitationButton setEnabled:NO];
        [cancelInvitationButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        NSLog(@"取消邀请");
    }
}
@end
