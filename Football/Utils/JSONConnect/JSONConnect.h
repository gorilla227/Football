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

@protocol JSONConnectDelegate <NSObject>
@optional
#pragma new Server
-(void)loginVerificationSuccessfully:(NSInteger)userId;
-(void)loginVerificationFailed;
-(void)receiveUserInfo:(UserInfo *)userInfo;

#pragma zzOld_Server
//-(void)receiveUserInfo:(UserInfo *)userInfo;
-(void)receiveMatches:(NSArray *)matches;
-(void)receiveTeams:(NSArray *)teams;
-(void)receiveStadiums:(NSArray *)stadiums;
-(void)receivePlayers:(NSArray *)players;
@end

@interface JSONConnect : NSObject
@property id<JSONConnectDelegate>delegate;
-(id)initWithDelegate:(id)responser;
-(void)showErrorAlertView:(NSError *)error;

#pragma new Server
-(void)loginVerification:(NSString *)account password:(NSString *)password;
-(void)requestUserInfo:(NSInteger)userId;

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
