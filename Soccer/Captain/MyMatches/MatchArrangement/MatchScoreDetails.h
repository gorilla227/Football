//
//  MatchScoreDetails.h
//  Soccer
//
//  Created by Andy Xu on 15/3/12.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveScoreForNewMatchDelegate <NSObject>
- (void)saveScoreDetails:(NSArray *)scoreDetails homeScore:(NSInteger)homeScore awayScore:(NSInteger)awayScore;
@end

@interface MatchScoreCell : UITableViewCell
@property IBOutlet UITextFieldForMatchScore *scoreTextField;
@end

@interface MatchScoreDetailCell : UITableViewCell
@property IBOutlet UITextFieldForMatchDetailScore *scoreDetailTextField;
@end

@interface MatchScoreDetails : UITableViewController<JSONConnectDelegate, ScoreDetailChanged, ScoreChanged, UITextFieldDelegate>
@property Match *matchData;
@property BOOL editable;
@property id<SaveScoreForNewMatchDelegate>delegate;
@property NSArray *originalMatchScoreList;
@property NSInteger myScore;
@property NSInteger opponentScore;
- (void)presetData;
@end
