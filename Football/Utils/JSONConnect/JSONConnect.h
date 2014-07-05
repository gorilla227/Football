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

#pragma new Server
-(void)loginVerification:(NSString *)account password:(NSString *)password;//登录验证
-(void)requestUserInfo:(NSInteger)userId;//获取用户信息
-(void)registerCaptain:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName teamName:(NSString *)teamName;//注册队长
-(void)registerPlayer:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName;//注册球员
-(void)updatePlayerProfile:(NSDictionary *)playerProfile;//更新球员资料（除了头像），mobile, email, userType 和nickname的修改服务器暂不支持
-(void)updatePlayerPortrait:(UIImage *)portrait forPlayer:(NSInteger)playerId;//更新球员头像
-(void)updateTeamProfile:(NSDictionary *)teamProfile;//更新球队资料（除了队标），teamName的修改服务器暂不支持
-(void)updateTeamLogo:(UIImage *)logo forTeam:(NSInteger)teamId;//更新球队队标

#pragma zzOld_Server
-(void)requestUserInfoById:(NSNumber *)userId;
-(void)requestMatchesByUserId:(NSNumber *)userId count:(NSInteger)count startIndex:(NSInteger)startIndex;
-(void)requestMatchesByTeamId:(NSNumber *)teamId count:(NSInteger)count startIndex:(NSInteger)startIndex;
-(void)requestAllTeamsWithCount:(NSInteger)count startIndex:(NSInteger)startIndex;
-(void)requestAllStadiums;
-(void)requestStadiumsOfTeam:(NSNumber *)teamId;
-(void)requestStadiumById:(NSNumber *)stadiumId;
-(void)requestPlayersByTeamId:(NSNumber *)teamId;
@end
