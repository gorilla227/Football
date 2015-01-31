//
//  MatchDetails.h
//  Football
//
//  Created by Andy on 14/12/7.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamDetails.h"

enum MatchDetailsCreationProgress {
    MatchDetailsCreationProgress_Initial,//1-1
    MatchDetailsCreationProgress_Passed,//A-A
    MatchDetailsCreationProgress_Future_WithoutOppo,//1-2
    MatchDetailsCreationProgress_Future_WithOppo//2-A
};

enum MatchDetailsViewType {
    MatchDetailsViewType_CreateMatch,
    MatchDetailsViewType_ViewDetails
};

@interface MatchDetails_MatchScoreDetails_Cell : UITableViewCell

@end

@interface MatchDetails : UITableViewController<UITextFieldDelegate, TeamMarketSelectionDelegate>
@property enum MatchDetailsViewType viewType;
@property Match *matchData;
-(void)presetMatchData;
-(void)formatMatchOpponent:(BOOL)isRealTeam;
@end
