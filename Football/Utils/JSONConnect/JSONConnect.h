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
-(void)loginVerificationSuccessfully:(NSInteger)userId;//登录验证成功
-(void)loginVerificationFailed;//登录验证失败
-(void)receiveUserInfo:(UserInfo *)userInfo;//返回用户信息
-(void)registerPlayerSuccessfully:(NSInteger)userId;//注册队长成功
-(void)registerCaptainSuccessfully:(NSInteger)userId teamId:(NSInteger)teamId;//注册球员成功
-(void)updatePlayerProfileSuccessfully;//更新球员资料成功
-(void)updatePlayerPortraitSuccessfully;//更新球员头像成功
-(void)updateTeamProfileSuccessfully;//更新球队资料成功
-(void)updateTeamLogoSuccessfully;//更新球队队标成功
-(void)receiveAllStadiums:(NSArray *)stadiums;//获取所有球场资料成功
-(void)receiveAllTeams:(NSArray *)teams;//获取所有球队列表成功
-(void)receiveTeam:(Team *)team;//获取指定的球队资料成功
-(void)receiveMessages:(NSArray *)messages sourceType:(enum RequestMessageSourceType)sourceType;//获取信息成功
-(void)receiveUnreadMessageAmount:(NSDictionary *)unreadMessageAmount;//获取未读消息数量成功
-(void)readMessagesSuccessfully:(NSArray *)messageIdList;//设置消息已读成功
-(void)playerApplayinSent;//球员申请加入球队发送成功

#pragma zzOld_Server
//-(void)receiveUserInfo:(UserInfo *)userInfo;
-(void)receiveMatches:(NSArray *)matches;
-(void)receiveTeams:(NSArray *)teams;
-(void)receiveStadiums:(NSArray *)stadiums;
-(void)receivePlayers:(NSArray *)players;
@end

@interface JSONConnect : NSObject
@property id<JSONConnectDelegate>delegate;
@property id<BusyIndicatorDelegate>busyIndicatorDelegate;
-(id)initWithDelegate:(id)responser andBusyIndicatorDelegate:(id)indicatorDelegate;
-(void)showErrorAlertView:(NSError *)error otherInfo:(NSString *)otherInfo;
-(void)cancelAllOperations;

#pragma new Server
-(void)loginVerification:(NSString *)account password:(NSString *)password;//登录验证
-(void)requestUserInfo:(NSInteger)userId withTeam:(BOOL)withTeam;//获取用户信息
-(void)registerCaptain:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName teamName:(NSString *)teamName;//注册队长
-(void)registerPlayer:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName;//注册球员
-(void)updatePlayerProfile:(NSDictionary *)playerProfile;//更新球员资料（除了头像），mobile, email, userType 和nickname的修改服务器暂不支持
-(void)updatePlayerPortrait:(UIImage *)portrait forPlayer:(NSInteger)playerId;//更新球员头像
-(void)updateTeamProfile:(NSDictionary *)teamProfile;//更新球队资料（除了队标），teamName的修改服务器暂不支持
-(void)updateTeamLogo:(UIImage *)logo forTeam:(NSInteger)teamId;//更新球队队标
-(void)requestAllStadiums;//获取所有球场
-(void)requestTeamsStart:(NSInteger)start count:(NSInteger)count option:(enum RequestTeamsOption)option;//获取所有球队
-(void)requestTeamById:(NSInteger)teamId isSync:(BOOL)syncOption;//获取指定的球队
//Messges
-(void)requestReceivedMessage:(NSInteger)receiverId messageTypes:(NSArray *)messageTypes status:(NSArray *)status startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption;//获取收到的信息
-(void)requestSentMessage:(NSInteger)senderId messageTypes:(NSArray *)messageTypes status:(NSArray *)status startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption;//获取发出的信息
-(void)requestUnreadMessageAmount:(NSInteger)receiverId messageTypes:(NSArray *)messageTypes;//获取未读消息数量
-(void)readMessages:(NSArray *)messageIdList;//设置消息为已读
-(void)applyinTeamFromPlayer:(NSInteger)playerId toTeam:(NSInteger)teamId withMessage:(NSString *)message;//球员申请加入球队

#pragma zzOld_Server
-(void)requestUserInfoById:(NSNumber *)userId;
-(void)requestMatchesByUserId:(NSNumber *)userId count:(NSInteger)count startIndex:(NSInteger)startIndex;
-(void)requestMatchesByTeamId:(NSNumber *)teamId count:(NSInteger)count startIndex:(NSInteger)startIndex;
-(void)requestAllTeamsWithCount:(NSInteger)count startIndex:(NSInteger)startIndex;
-(void)requestStadiumsOfTeam:(NSNumber *)teamId;
-(void)requestStadiumById:(NSNumber *)stadiumId;
-(void)requestPlayersByTeamId:(NSNumber *)teamId;
@end
