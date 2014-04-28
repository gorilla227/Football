//
//  DataModel.h
//  Football
//
//  Created by Andy on 14-4-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma Team
@interface Team : NSObject
@property NSString *name;
@property NSString *description;
@property NSDate *creationDate;
@property NSInteger teamId;
@property NSInteger balance;
@property NSData *logo;
@property NSInteger captainId;
@property NSString *slogan;
@property NSString *teamName;
-(id)initWithData:(NSDictionary *)data;
@end

#pragma UserInfo
@interface UserInfo : NSObject
@property NSInteger userId;
@property NSString *userName;
@property NSData *picture;
@property NSString *userType;
@property NSString *loginType;
@property NSString *city;
@property NSString *name;
@property NSInteger age;
@property BOOL gender;//YES-Male NO-Female
@property Team *team;
-(id)initWithData:(NSDictionary *)data;
@end

#pragma Match
@interface Match: NSObject
@property NSString *name;
@property NSString *description;
@property NSDate *creationDate;
@property NSInteger matchId;
@property NSString *matchPlace;
@property NSDate *matchDate;
@property BOOL announcable;
@property BOOL recordable;
@property Team *teamA;
@property Team *teamB;
@property NSInteger rating;
@property NSInteger contactPersonId;
@property NSInteger matchType;
-(id)initWithData:(NSDictionary *)data;
@end


#pragma data keys
//UserInfo
#define kUserInfo_name @"name"
#define kUserInfo_age @"age"
#define kUserInfo_team @"team"
#define kUserInfo_userId @"id"
#define kUserInfo_userName @"username"
#define kUserInfo_picture @"picture"
#define kUserInfo_userType @"userType"
#define kUserInfo_loginType @"loginType"
#define kUserInfo_city @"city"
#define kUserInfo_gender @"gender"
//Team
#define kTeam_name @"name"
#define kTeam_description @"description"
#define kTeam_creationDate @"creationDate"
#define kTeam_teamId @"id"
#define kTeam_balance @"balance"
#define kTeam_logo @"logo"
#define kTeam_captain @"captain"
#define kTeam_slogan @"slogan"
#define kTeam_teamName @"teamName"
//Match
#define kMatch_name @"name"
#define kMatch_description @"description"
#define kMatch_creationDate @"creationDate"
#define kMatch_matchId @"id"
#define kMatch_matchPlace @"place"
#define kMatch_matchDate @"date"
#define kMatch_announcable @"announcable"
#define kMatch_recordable @"recordable"
#define kMatch_teamA @"teamA"
#define kMatch_teamB @"teamB"
#define kMatch_rating @"rating"
#define kMatch_contactPersonId @"contactPerson"
#define kMatch_matchType @"type"