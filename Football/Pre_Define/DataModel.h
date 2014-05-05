//
//  DataModel.h
//  Football
//
//  Created by Andy on 14-4-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma Stadium
@interface Stadium : NSObject
@property NSNumber *stadiumId;
@property NSString *stadiumName;
@property NSString *address;
@property NSString *phoneNumber;
@property NSString *contactPerson;
-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)exportToDictionary;
@end

#pragma Team
@interface Team : NSObject
@property NSString *name;
@property NSString *description;
@property NSDate *creationDate;
@property NSNumber *teamId;
@property NSNumber *balance;
@property NSData *logo;
@property NSNumber *captainId;
@property NSString *slogan;
@property NSString *teamName;
-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)exportToDictionary;
@end

#pragma UserInfo
@interface UserInfo : NSObject
@property NSNumber *userId;
@property NSString *userName;
@property NSData *picture;
@property NSString *userType;
@property NSString *loginType;
@property NSString *city;
@property NSString *name;
@property NSNumber *age;
@property NSString *gender;
@property Team *team;
-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)exportToDictionary;
@end

#pragma Match
@interface Match: NSObject
@property NSString *name;
@property NSString *description;
@property NSDate *creationDate;
@property NSNumber *matchId;
@property NSString *matchPlace;
@property NSDate *matchDate;
@property BOOL announcable;
@property BOOL recordable;
@property Team *teamA;
@property Team *teamB;
@property NSString *rating;
@property NSString *contactPersonId;
@property NSString *matchType;
-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)exportToDictionary;
@end

@interface MatchScore : NSObject
@property Team *home;
@property NSString *awayTeamName;
@property NSNumber *homeScore;
@property NSNumber *awayScore;
@property NSArray *goalPlayers;
@property NSArray *assistPlayers;
-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)exportToDictionary;
@end
#pragma data keys
//Stadium
#define kStadium_id @"id"
#define kStadium_name @"name"
#define kStadium_address @"address"
#define kStadium_phoneNumber @"phoneNumber"
#define kStadium_contactPerson @"contactPerson"
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
//MatchScore
#define kMatchScore_homeTeam @"homeTeam"
#define kMatchScore_awayTeam @"awayTeam"
#define kMatchScore_homeScore @"homeScore"
#define kMatchScore_awayScore @"awayScore"
#define kMatchScore_goalPlayers @"goalPlayers"
#define kMatchScore_assistPlayers @"assistPlayers"