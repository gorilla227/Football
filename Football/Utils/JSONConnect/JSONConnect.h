//
//  JSONConnect.h
//  Football
//
//  Created by Andy on 14-4-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONConnectionParameters.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"

enum RequestTeamsOption
{
    RequestTeamsOption_All,
    RequestTeamsOption_Recruit,
    RequestTeamsOption_Challenge
};

enum RequestMessageSourceType
{
    RequestMessageSourceType_Receiver,
    RequestMessageSourceType_Sender
};

@protocol BusyIndicatorDelegate <NSObject>
-(void)lockView;
-(void)unlockView;
@end

@protocol JSONConnectDelegate <NSObject>
@optional
#pragma new Server
//Login & Register & Update Profile
-(void)loginVerificationSuccessfully:(NSInteger)userId;//登录验证成功
-(void)loginVerificationFailed;//登录验证失败
-(void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference;//返回用户信息
-(void)registerPlayerSuccessfully:(NSInteger)userId;//注册队长成功
-(void)registerCaptainSuccessfully:(NSInteger)userId teamId:(NSInteger)teamId;//注册球员成功
-(void)updatePlayerProfileSuccessfully;//更新球员资料成功
-(void)updatePlayerPortraitSuccessfully;//更新球员头像成功
-(void)updateTeamProfileSuccessfully;//更新球队资料成功
-(void)updateTeamLogoSuccessfully;//更新球队队标成功

//Team Management
-(void)receiveAllTeams:(NSArray *)teams;//获取所有球队列表成功
-(void)receiveTeam:(Team *)team;//获取指定的球队资料成功
-(void)receiveTeamMembers:(NSArray *)players;//获取球队队员清单成功
-(void)receivePlayers:(NSArray *)players;//获取符合条件的球员列表成功
-(void)receiveTeams:(NSArray *)teams;//获取符合条件的球队列表成功

//Stadium
-(void)receiveAllStadiums:(NSArray *)stadiums;//获取所有球场资料成功
-(void)addStadiumSuccessfully:(NSInteger)stadiumId;//添加球场成功

//Message
-(void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType;//获取信息成功
-(void)receiveUnreadMessageAmount:(NSDictionary *)unreadMessageAmount;//获取未读消息数量成功
-(void)readMessagesSuccessfully:(NSArray *)messageIdList;//设置消息已读成功
-(void)playerApplyinSent:(BOOL)result;//球员申请加入球队发送返回结果
-(void)replyApplyinMessageSuccessfully:(NSInteger)responseCode;//队长回复球员的入队申请成功
-(void)teamCallinSent:(BOOL)result;//队长邀请球员加入球队发送返回结果
-(void)replyCallinMessageSuccessfully:(NSInteger)responseCode;//球员回复队长的入队邀请成功
-(void)matchNoticeSent:(BOOL)result;//队长发送比赛通知返回结果
-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer isSent:(BOOL)result;//球员回应参赛邀请返回结果

//Match Management
-(void)receiveMatchesSuccessfully:(NSArray *)matches;//获取比赛列表成功
-(void)updateMatchStatus:(BOOL)result;//修改比赛状态成功与否
-(void)receiveMatch:(Match *)match;//获取指定id的Match成功
-(void)createMatchWithRealTeam:(NSInteger)matchId;//创建与实体球队的比赛
-(void)replyMatchInvitation:(Message *)message withAnswer:(BOOL)answer isSent:(BOOL)result;//队长回应约赛邀请返回结果
-(void)receiveMatchScoreDetails:(NSArray *)matchScoreDetails;//获取比赛详细记录成功
-(void)addedMatchScoreDetail:(BOOL)result;//添加比赛详细记录成功与否
-(void)updatedMatchScoreDetail:(BOOL)result;//更新比赛详细记录成功与否
-(void)receiveMatchAttendence:(NSArray *)matchAttendence;//获取参赛者成功

//Balance Management
-(void)receiveTeamBalance:(NSNumber *)teamBalance;//获取球队经费余额成功
-(void)receiveTeamBalanceTransactions:(NSArray *)transactions;//获取球队收支明细成功
-(void)transactionAdded:(BOOL)result;//添加收支记录成功与否
-(void)receiveTeamFunds:(NSArray *)teamFunds;//获取队费记录成功
@end



#pragma new Server
@interface JSONConnect : NSObject
@property id<JSONConnectDelegate>delegate;
@property id<BusyIndicatorDelegate>busyIndicatorDelegate;
-(id)initWithDelegate:(id)responser andBusyIndicatorDelegate:(id)indicatorDelegate;
-(void)showErrorAlertView:(NSError *)error otherInfo:(NSString *)otherInfo;
-(void)cancelAllOperations;


//Login & Register & Update Profile
-(void)loginVerification:(NSString *)account password:(NSString *)password;//登录验证
-(void)requestUserInfo:(NSInteger)userId withTeam:(BOOL)withTeam withReference:(id)reference;//获取用户信息
-(void)registerCaptain:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName teamName:(NSString *)teamName;//注册队长
-(void)registerPlayer:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName;//注册球员
-(void)updatePlayerProfile:(NSDictionary *)playerProfile;//更新球员资料（除了头像），mobile, email, userType 和nickname的修改服务器暂不支持
-(void)updatePlayerPortrait:(UIImage *)portrait forPlayer:(NSInteger)playerId;//更新球员头像
-(void)updateTeamProfile:(NSDictionary *)teamProfile;//更新球队资料（除了队标），teamName的修改服务器暂不支持
-(void)updateTeamLogo:(UIImage *)logo forTeam:(NSInteger)teamId;//更新球队队标

//Team Management
-(void)requestTeamsStart:(NSInteger)start count:(NSInteger)count option:(enum RequestTeamsOption)option;//获取所有球队
-(void)requestTeamById:(NSInteger)teamId isSync:(BOOL)syncOption;//获取指定的球队
-(void)requestTeamMembers:(NSInteger)teamId withTeamFundHistory:(BOOL)withTeamFundHistory isSync:(BOOL)syncOption;//获取球队的队员清单
-(void)requestPlayersBySearchCriteria:(NSDictionary *)searchCriteria startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption;//获取符合条件的球员列表
-(void)requestTeamsBySearchCriteria:(NSDictionary *)searchCriteria startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption;//获取符合条件的球队列表
-(void)createTeamByCaptainId:(NSInteger)captainId teamProfile:(Team *)teamProfile;//无球队球员创建球队

//Stadium
-(void)requestAllStadiums;//获取所有球场
-(void)addStadium:(Stadium *)stadium;//添加球场

//Messges
-(void)requestReceivedMessage:(UserInfo *)receiver messageType:(NSString *)messageTypeId status:(NSArray *)status startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption;//获取收到的信息
-(void)requestSentMessage:(UserInfo *)sender messageType:(NSString *)messageTypeId status:(NSArray *)status startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption;//获取发出的信息
-(void)requestUnreadMessageAmount:(UserInfo *)receiver messageTypes:(NSArray *)messageTypes;//获取未读消息数量
-(void)readMessages:(NSArray *)messageIdList;//设置消息为已读
-(void)applyinFromPlayer:(NSInteger)playerId toTeam:(NSInteger)teamId withMessage:(NSString *)message;//球员申请加入球队
-(void)replyApplyinMessage:(NSInteger)messageId response:(NSInteger)responseCode;//队长回复球员的入队申请，2-同意，3-拒绝
-(void)callinFromTeam:(NSInteger)teamId toPlayer:(NSInteger)playerId withMessage:(NSString *)message;//队长邀请球员加入球队
-(void)replyCallinMessage:(NSInteger)messageId response:(NSInteger)responseCode;//球员回复队长的入队邀请，2-同意，3-拒绝
-(void)sendMatchNotice:(NSInteger)matchId fromTeam:(NSInteger)teamId toPlayer:(NSInteger)playerId withMessage:(NSString *)message;//队长发送比赛通知（包括临时帮忙邀请）
-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer;//球员回应参赛邀请

//Match Management
-(void)requestMatchesByPlayer:(NSInteger)playerId forTeam:(NSInteger)teamId inStatus:(NSArray *)status sort:(NSInteger)sort count:(NSInteger)count startIndex:(NSInteger)startIndex isSync:(BOOL)syncOption;//获取球队的比赛列表
-(void)updateMatchStatus:(NSInteger)statusId organizer:(NSInteger)organizerId match:(NSInteger)matchId;//修改比赛状态
-(void)requestMatchesByMatchId:(NSInteger)matchId;//通过比赛id获取比赛详情
-(void)createMatchWithRealTeam:(NSDictionary *)newMatch;//创建与实体队的比赛
-(void)replyMatchInvitation:(Message *)message withAnswer:(BOOL)answer;//队长回应约战邀请
-(void)requestMatchScoreDetails:(NSInteger)matchId forTeam:(NSInteger)teamId;//获取比赛详细记录
-(void)addMatchScoreDetail:(NSDictionary *)parameters;//添加新比赛详细记录
-(void)updateMatchScoreDetail:(NSDictionary *)parameters;//更新比赛详细记录
-(void)requestMatchAttendence:(NSInteger)matchId forTeam:(NSInteger)teamId;//获取参赛者列表

//Balance Management
-(void)requestTeamBalance:(NSInteger)teamId forPlayer:(NSInteger)playerId;//获取球队经费余额
-(void)requestTeamBalanceTransactions:(NSInteger)teamId forPlayer:(NSInteger)playerId startIndex:(NSInteger)startIndex count:(NSInteger)count;//获取球队经费收支明细
-(void)addTransaction:(NSDictionary *)parameters;//添加收支记录
-(void)requestTeamFunds:(NSInteger)teamId forCaptain:(NSInteger)captainId startDate:(NSDate *)startDate endDate:(NSDate *)endDate;//获取指定时间段的队费记录
@end
