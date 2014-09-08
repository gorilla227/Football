//
//  PlayerDetails.h
//  Football
//
//  Created by Andy Xu on 14-9-7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
//PlayerDetails_ViewTypes
enum PlayerDetails_ViewTypes
{
    PlayerDetails_MyPlayer,
    PlayerDetails_Applicant,
    PlayerDetails_FromPlayerMarket
};

#import <UIKit/UIKit.h>

@interface PlayerDetails : UITableViewController
@property UserInfo *playerData;
@property enum PlayerDetails_ViewTypes viewType;
@end
