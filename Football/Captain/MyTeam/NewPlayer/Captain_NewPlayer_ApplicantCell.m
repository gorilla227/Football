//
//  Captain_NewPlayer_ApplicantCell.m
//  Football
//
//  Created by Andy on 14-4-5.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_NewPlayer_ApplicantCell.h"

@implementation Captain_NewPlayer_ApplicantCell
@synthesize playerID, postion, age, team, comment, status, agreementSegment;

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

-(IBAction)agreementOnClicked:(id)sender
{
    UIAlertView *confirmAgreement = [[UIAlertView alloc] init];
    [confirmAgreement setDelegate:self];
    switch (agreementSegment.selectedSegmentIndex) {
        case 0:
            [confirmAgreement setTitle:@"同意入队确认"];
            [confirmAgreement setMessage:[NSString stringWithFormat:@"确认同意%@入队？", playerID.text]];
            [confirmAgreement addButtonWithTitle:@"取消"];
            [confirmAgreement addButtonWithTitle:@"同意入队"];
            [confirmAgreement setCancelButtonIndex:0];
            break;
        case 1:
            [confirmAgreement setTitle:@"拒绝入队确认"];
            [confirmAgreement setMessage:[NSString stringWithFormat:@"确认拒绝%@入队？", playerID.text]];
            [confirmAgreement addButtonWithTitle:@"取消"];
            [confirmAgreement addButtonWithTitle:@"拒绝入队"];
            [confirmAgreement setCancelButtonIndex:0];
            break;
        default:
            break;
    }
    [confirmAgreement show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        switch (agreementSegment.selectedSegmentIndex) {
            case 0:
                NSLog(@"同意入队");
                break;
            case 1:
                NSLog(@"拒绝入队");
                break;
            default:
                break;
        }
        [agreementSegment setEnabled:NO];
    }
    else {
        [agreementSegment setSelectedSegmentIndex:-1];
    }

}
@end
