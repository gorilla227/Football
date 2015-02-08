//
//  MatchArrangementTableView.h
//  Football
//
//  Created by Andy on 14/11/17.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MatchArrangementActionDelegate <NSObject>
-(void)noticeTeamMembers:(Match *)matchData;
-(void)noticeTempFavor:(Match *)matchData;
-(void)viewMatchDetails:(Match *)matchData;
-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer;
//-(void)enterScore:(Match *)matchData;
//-(void)viewScore:(Match *)matchData;
@end

@interface MatchArrangementTableView_Cell : UITableViewCell<UIActionSheetDelegate>
@property Match *matchData;
@property id<MatchArrangementActionDelegate>delegate;
-(void)pushMatchDetails;
@end

@interface MatchArrangementTableView : UITableViewController<UIAlertViewDelegate, JSONConnectDelegate>

@end
