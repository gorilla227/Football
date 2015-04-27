//
//  MatchArrangementTableView.h
//  Football
//
//  Created by Andy on 14/11/17.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
enum MatchResponseTypes {
    MatchResponseType_Default,
    MatchResponseType_MatchInvitation,
    MatchResponseType_MatchNotice
};

@protocol ReplyMatchInvitationAndNoticeDelegate <NSObject>
-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer;
-(void)replyMatchInvitation:(Message *)message withAnswer:(BOOL)answer;
@end

@protocol MatchArrangementActionDelegate <NSObject>
-(void)noticeTeamMembers:(Match *)matchData;
-(void)noticeTempFavor:(Match *)matchData;
-(void)viewMatchDetails:(Match *)matchData forResponseType:(enum MatchResponseTypes)responseType;
-(void)viewScore:(Match *)matchData editable:(BOOL)editable;
@end

@interface MatchArrangementTableView_Cell : UITableViewCell<UIActionSheetDelegate>
@property enum MatchResponseTypes responseType;
@property Match *matchData;
@property id<MatchArrangementActionDelegate>delegate;
@property id<ReplyMatchInvitationAndNoticeDelegate>replyMatchInvitationAndNoticeDelegate;
-(void)pushMatchDetails;
@end

@interface MatchArrangementTableView : TableViewController_More<UIAlertViewDelegate, JSONConnectDelegate, ReplyMatchInvitationAndNoticeDelegate>

@end
