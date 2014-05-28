//
//  CallFriends.m
//  Football
//
//  Created by Andy on 14-5-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "CallFriends.h"

@implementation CallFriends{
    NSArray *callFriendsMenuList;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithDelegate:(id)delegate
{
    self = [super initWithTitle:nil delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        NSString *callFriendsMenuListFile = [[NSBundle mainBundle] pathForResource:@"ActionSheetMenu" ofType:@"plist"];
        callFriendsMenuList = [[[[NSDictionary alloc] initWithContentsOfFile:callFriendsMenuListFile] objectForKey:@"CallFriendsMenu"] objectForKey:@"MenuList"];
        
        for (NSDictionary *menuItem in callFriendsMenuList) {
            [self addButtonWithTitle:[menuItem objectForKey:@"Title"]];
            [[self.subviews lastObject] setImage:[UIImage imageNamed:[menuItem objectForKey:@"Icon"]] forState:UIControlStateNormal];
        }
        [self setCancelButtonIndex:[self addButtonWithTitle:@"取消"]];
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

@end
