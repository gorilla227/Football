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

@protocol JSONConnectDelegate <NSObject>
@optional
-(void)receiveUserInfo:(UserInfo *)userInfo;
-(void)receiveMatches:(NSArray *)matches;
-(void)receiveAllTemas:(NSArray *)teams;
@end

@interface JSONConnect : NSObject
@property id<JSONConnectDelegate>delegate;
-(id)initWithDelegate:(id)responser;
-(void)requestUserInfoById:(NSNumber *)userId;
-(void)requestMatchesByUserId:(NSNumber *)userId count:(NSInteger)count startIndex:(NSInteger)startIndex;
-(void)requestAllTeamsWithCount:(NSInteger)count startIndex:(NSInteger)startIndex;
@end
