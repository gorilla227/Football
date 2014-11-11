//
//  DataModel.h
//  Football
//
//  Created by Andy on 14-4-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma ActivityRegion
@interface ActivityRegion : NSObject
+(NSArray *)stringWithCode:(NSArray *)code;
+(NSArray *)codeWithString:(NSArray *)string;
@end

#pragma Position
@interface Position : NSObject
+(NSString *)stringWithCode:(NSInteger)position;
+(NSArray *)positionList;
@end

#pragma Age
@interface Age : NSObject
+(NSInteger)ageFromDate:(NSDate *)birthday;
+(NSInteger)ageFromString:(NSString *)birthdayString;
@end

#pragma Message
#define kMessage_id @"id"
#define kMessage_senderId @"from"
#define kMessage_senderName @"from_nick_name"
#define kMessage_receiverId @"to"
#define kMessage_receiverName @"to_nick_name"
#define kMessage_createTime @"create_time"
#define kMessage_body @"message"
#define kMessage_type @"type"
#define kMessage_status @"status"
@interface Message : NSObject
@property NSInteger messageId;
@property NSInteger senderId;
@property NSInteger receiverId;
@property NSString *senderName;
@property NSString *receiverName;
@property NSDate *creationDate;
@property NSString *messageBody;
@property NSInteger messageType;
@property NSInteger status;
-(id)initWithData:(NSDictionary *)data;
@end

#pragma Stadium
#define kStadium_id @"field_id"
#define kStadium_name @"name"
#define kStadium_address @"location"
#define kStadium_phoneNumber @"phone_number"
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
@property CLLocationDistance distance;
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
#define kTeam_recruitFlag @"call_for_new"
#define kTeam_challengeFlag @"call_for_game"
#define kTeam_recruitAnnoucement @"call_for_new_board"
#define kTeam_challengeAnnoucement @"call_for_game_board"
@interface Team : NSObject
@property NSInteger teamId;
@property NSString *teamName;
@property NSInteger numOfMember;
@property NSArray *activityRegion;
@property NSString *creationDate;
@property UIImage *teamLogo;
@property NSString *slogan;
@property BOOL recruitFlag;
@property NSString *recruitAnnouncement;
@property BOOL challengeFlag;
@property NSString *challengeAnnouncement;
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
#define kMatch_matchId @"id"
#define kMatch_matchTitle @"title"
#define kMatch_beginTime @"begin_time"
#define kMatch_beginTimeLocal @"begin_time_local"
#define kMatch_matchField @"field"
#define kMatch_homeTeam @"host_team"
#define kMatch_awayTeam @"guest_team"
#define kMatch_homeTeamGoal @"host_team_goal"
#define kMatch_awayTeamGoal @"guest_team_goal"
#define kMatch_matchStandard @"standard"
#define kMatch_withReferee @"with_referee"
#define kMatch_organizerId @"organiser"
#define kMatch_status @"status"
#define kMatch_createTime @"create_time"
#define kMatch_createTimeLocal @"create_time_local"
@interface Match: NSObject
@property NSInteger matchId;
@property NSString *matchTitle;
@property NSDate *beginTime;
@property NSString *beginTimeLocal;
@property Stadium *matchField;
@property Team *homeTeam;
@property Team *awayTeam;
@property NSInteger homeTeamGoal;
@property NSInteger awayTeamGoal;
@property NSInteger matchStandard;
@property BOOL withReferee;
@property NSInteger organizerId;
@property NSInteger status;
@property NSDate *createTime;
@property NSString *createTimeLocal;
-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)dictionaryForUpdate:(Match *)originalMatch;
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

//MatchScore
#define kMatchScore_homeTeam @"homeTeam"
#define kMatchScore_awayTeam @"awayTeam"
#define kMatchScore_homeScore @"homeScore"
#define kMatchScore_awayScore @"awayScore"
#define kMatchScore_goalPlayers @"goalPlayers"
#define kMatchScore_assistPlayers @"assistPlayers"