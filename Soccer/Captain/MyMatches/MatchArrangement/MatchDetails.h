//
//  MatchDetails.h
//  Soccer
//
//  Created by Andy on 14/12/7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamDetails.h"
#import "MatchScoreDetails.h"

enum MatchDetailsCreationProgress {
    MatchDetailsCreationProgress_Initial,//1-1
    MatchDetailsCreationProgress_Passed,//A-A
    MatchDetailsCreationProgress_Future_WithoutOppo,//1-2
    MatchDetailsCreationProgress_Future_WithOppo//2-A
};

enum MatchDetailsViewType {
    MatchDetailsViewType_CreateMatch,
    MatchDetailsViewType_ViewDetails,
    MatchDetailsViewType_MatchInvitation,
    MatchDetailsViewType_MatchNotice
};

@interface MatchDetails : UITableViewController<UITextFieldDelegate, TeamMarketSelectionDelegate, JSONConnectDelegate, UIAlertViewDelegate, SaveScoreForNewMatchDelegate>
@property enum MatchDetailsViewType viewType;
@property Match *matchData;
@property Message *message;
-(void)presetMatchData;
-(void)formatMatchOpponent:(BOOL)isRealTeam;
@end
