//
//  DataModel.h
//  Football
//
//  Created by Andy on 14-4-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma Stadium
#define kStadium_id @"field_id"
#define kStadium_name @"name"
#define kStadium_address @"location"
#define kStadium_phoneNumber @"phone_umber"
#define kStadium_price @"price"
#define kStadium_longitude @"longitude"
#define kStadium_latitude @"latitude"
#define kStadium_comment @"comment"
@interface Stadium : NSObject<MKAnnotation>
@property NSInteger stadiumId;
@property NSString *stadiumName;
@property NSString *address;
@property NSString *phoneNumber;
@property NSInteger price;
@property NSString *comment;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
-(id)initWithData:(NSDictionary *)data;
@end

#pragma Team
#define kTeam_playerId @"member_id"
#define kTeam_teamId @"team_id"
#define kTeam_teamName @"name"
#define kTeam_numOfTeam @"member_num"
#define kTeam_activityRegion @"location"
#define kTeam_creationDate @"create_time"
#define kTeam_logo @"logo"
#define kTeam_slogan @"slogan"
#define kTeam_homeStadium @"home_field"
#define kTeam_homeStadiumId @"home_field_id"
@interface Team : NSObject
@property NSInteger teamId;
@property NSString *teamName;
@property NSInteger numOfMember;
@property NSArray *activityRegion;
@property NSString *creationDate;
@property UIImage *teamLogo;
@property NSString *slogan;
@property Stadium *homeStadium;
-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)dictionaryForUpdate:(Team *)originalTeam withPlayer:(NSInteger)playerId;
@end

#pragma UserInfo
#define kUserInfo_userId @"id"
#define kUserInfo_mobile @"mobile"
#define kUserInfo_password @"password"
#define kUserInfo_userType @"is_captain"
#define kUserInfo_nickName @"nick_name"
#define kUserInfo_email @"email"
#define kUserInfo_qq @"qq"
#define kUserInfo_birthday @"birthday"
#define kUserInfo_activityRegion @"location"
#define kUserInfo_playerPortrait @"logo"
#define kUserInfo_position @"position"
#define kUserInfo_style @"style"
#define kUserInfo_legalname @"real_name"
#define kUserInfo_gender @"gender"
#define kUserInfo_team @"team"
@interface UserInfo : NSObject
@property NSInteger userId;
@property NSString *mobile;
@property NSInteger userType;
@property NSString *nickName;
@property NSString *legalName;
@property NSInteger gender;
@property NSString *email;
@property NSString *qq;
@property NSString *birthday;
@property NSArray *activityRegion;
@property NSInteger position;
@property NSString *style;
@property UIImage *playerPortrait;
@property Team *team;
-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)dictionaryForUpdate:(UserInfo *)originalUserInfo;
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


//Team

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