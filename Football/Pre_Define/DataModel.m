//
//  DataModel.m
//  Football
//
//  Created by Andy on 14-4-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#import "DataModel.h"

#pragma Stadium
@implementation Stadium
@synthesize stadiumId, stadiumName, address, phoneNumber, contactPerson;

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        [self setStadiumId:[data objectForKey:kStadium_id]];
        [self setStadiumName:[data objectForKey:kStadium_name]];
        [self setAddress:[data objectForKey:kStadium_address]];
        [self setPhoneNumber:[data objectForKey:kStadium_phoneNumber]];
        [self setContactPerson:[data objectForKey:contactPerson]];
    }
    return self;
}

-(NSDictionary *)exportToDictionary
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setObject:stadiumId forKey:kStadium_id];
    [output setObject:stadiumName forKey:kStadium_name];
    [output setObject:address forKey:kStadium_address];
    [output setObject:phoneNumber forKey:kStadium_phoneNumber];
    [output setObject:contactPerson forKey:kStadium_contactPerson];
    return output;
}
@end

#pragma Team
@implementation Team
@synthesize name, description, creationDate, teamId, balance, logo, captainId, slogan, teamName;

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:def_JSONDateformat];
        
        [self setName:[data objectForKey:kTeam_name]];
        [self setDescription:[data objectForKey:kTeam_description]];
        [self setCreationDate:[dateFormatter dateFromString:[data objectForKey:kTeam_creationDate]]];
        [self setTeamId:[data objectForKey:kTeam_teamId]];
        [self setBalance:[data objectForKey:kTeam_balance]];
        [self setLogo:[data objectForKey:kTeam_logo]];
        [self setCaptainId:[data objectForKey:kTeam_captain]];
        [self setSlogan:[data objectForKey:kTeam_slogan]];
        [self setTeamName:[data objectForKey:kTeam_teamName]];
    }
    return self;
}

-(NSDictionary *)exportToDictionary
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_JSONDateformat];
    
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setObject:name forKey:kTeam_teamName];
    [output setObject:description forKey:kTeam_description];
    [output setObject:[dateFormatter stringFromDate:creationDate] forKey:kTeam_creationDate];
    [output setObject:teamId forKey:kTeam_teamId];
    [output setObject:balance forKey:kTeam_balance];
    if ([logo isEqual:[NSNull null]]) {
        [output setObject:[NSNull null] forKey:kTeam_logo];
    }
    else {
        [output setObject:[logo base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] forKey:kTeam_logo];
    }
    [output setObject:captainId forKey:kTeam_captain];
    [output setObject:slogan forKey:kTeam_slogan];
    [output setObject:teamName forKey:kTeam_teamName];
    return output;
}
@end

#pragma UserInfo
@implementation UserInfo{
    NSDateFormatter *dateFormatter;
}
@synthesize userId, mobile, userType, nickName, legalName, gender, email, qq, birthday, activityRegion, position, style, playerPortrait;

-(id)copy
{
    UserInfo *userInfoCopy = [[UserInfo alloc] init];
    //Copy required properties
    [userInfoCopy setUserId:userId];
    [userInfoCopy setMobile:[mobile copy]];
    [userInfoCopy setUserType:userType];
    [userInfoCopy setNickName:[nickName copy]];
    [userInfoCopy setEmail:email];
    //Copy option properties
    if (legalName) {
        [userInfoCopy setLegalName:[legalName copy]];
    }
    [userInfoCopy setGender:gender];
    if (qq) {
        [userInfoCopy setQq:[qq copy]];
    }
    if (birthday) {
        [userInfoCopy setBirthday:[birthday copy]];
    }
    if (activityRegion) {
        [userInfoCopy setActivityRegion:[activityRegion copy]];
    }
    [userInfoCopy setPosition:position];
    if (style) {
        [userInfoCopy setStyle:[style copy]];
    }
    if (playerPortrait) {
        [userInfoCopy setPlayerPortrait:[playerPortrait copy]];
    }
    return userInfoCopy;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:def_MatchDateformat];
        [dateFormatter setLocale:[NSLocale currentLocale]];

        [self setUserId:[[data objectForKey:kUserInfo_userId] integerValue]];
        [self setMobile:[data objectForKey:kUserInfo_mobile]];
        [self setUserType:[[data objectForKey:kUserInfo_userType] integerValue]];
        [self setNickName:[data objectForKey:kUserInfo_nickName]];
        [self setLegalName:[data objectForKey:kUserInfo_legalname]];
        [self setGender:[[data objectForKey:kUserInfo_gender] integerValue]];
        [self setPosition:[[data objectForKey:kUserInfo_position] integerValue]];
        [self setStyle:[data objectForKey:kUserInfo_style]];
        [self setEmail:[data objectForKey:kUserInfo_email]];
        [self setQq:[data objectForKey:kUserInfo_qq]];
        [self setBirthday:[data objectForKey:kUserInfo_birthday]];
        NSString *locationCode = [data objectForKey:kUserInfo_activityRegion];
        [self setActivityRegion:[locationCode componentsSeparatedByString:@"-"]];
        NSString *portraitFileString = [data objectForKey:kUserInfo_playerPortrait];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitFileString]];
        playerPortrait = [UIImage imageWithData:imageData];
    }
    return self;
}

-(NSDictionary *)dictionaryForUpdate:(UserInfo *)originalUserInfo
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setObject:[NSNumber numberWithInteger:userId] forKey:kUserInfo_userId];
    //Compare required properties
    if (![mobile isEqualToString:originalUserInfo.mobile]) {
        [output setObject:mobile forKey:kUserInfo_mobile];
    }
    if (![email isEqualToString:originalUserInfo.email]) {
        [output setObject:email forKey:kUserInfo_email];
    }
    if (userType != originalUserInfo.userType) {
        [output setObject:[NSNumber numberWithInteger:userType] forKey:kUserInfo_userType];
    }
    if (![nickName isEqualToString:originalUserInfo.nickName]) {
        [output setObject:nickName forKey:kUserInfo_nickName];
    }
    //Compare optional properties
    if (gender != originalUserInfo.gender) {
        [output setObject:[NSNumber numberWithInteger:gender] forKey:kUserInfo_gender];
    }
    if (![qq isEqualToString:originalUserInfo.qq]) {
        [output setObject:qq forKey:kUserInfo_qq];
    }
    if (position != originalUserInfo.position) {
        [output setObject:[NSNumber numberWithInteger:position] forKey:kUserInfo_position];
    }
    if (![activityRegion isEqual:originalUserInfo.activityRegion]) {
        [output setObject:[activityRegion componentsJoinedByString:@"-"] forKey:kUserInfo_activityRegion];
    }
    if (![legalName isEqualToString:originalUserInfo.legalName]) {
        [output setObject:legalName forKey:kUserInfo_legalname];
    }
    if (![birthday isEqualToString:originalUserInfo.birthday]) {
        [output setObject:birthday forKey:kUserInfo_birthday];
    }
    if (![style isEqualToString:originalUserInfo.style]) {
        [output setObject:style forKey:kUserInfo_style];
    }
    return output;
}
@end

#pragma Match
@implementation Match
@synthesize name, description, creationDate, matchId, matchPlace, matchDate, announcable, recordable, teamA, teamB, rating, contactPersonId, matchType;

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:def_JSONDateformat];
        
        [self setName:[data objectForKey:kMatch_name]];
        [self setDescription:[data objectForKey:kMatch_description]];
        NSString *dataCreationDate = [data objectForKey:kMatch_creationDate];
        [self setCreationDate:[dateFormatter dateFromString:dataCreationDate]];
        [self setMatchId:[data objectForKey:kMatch_matchId]];
//        [self setMatchPlace:[data objectForKey:kMatch_matchPlace]];
        NSString *dataMatchDate = [data objectForKey:kMatch_matchDate];
        [self setMatchDate:[dateFormatter dateFromString:dataMatchDate]];
        NSNumber *dataAnnouncable = [data objectForKey:kMatch_announcable];
        [self setAnnouncable:dataAnnouncable.boolValue];
        NSNumber *dataRecordable = [data objectForKey:kMatch_recordable];
        [self setRecordable:dataRecordable.boolValue];
        NSDictionary *dataTeamA = [data objectForKey:kMatch_teamA];
        [self setTeamA:[[Team alloc] initWithData:dataTeamA]];
        NSDictionary *dataTeamB = [data objectForKey:kMatch_teamB];
        [self setTeamB:[[Team alloc] initWithData:dataTeamB]];
        [self setRating:[data objectForKey:kMatch_rating]];
        [self setContactPersonId:[data objectForKey:kMatch_contactPersonId]];
        [self setMatchType:[data objectForKey:kMatch_matchType]];
    }
    return self;
}

-(NSDictionary *)exportToDictionary
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:def_JSONDateformat];
    
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setObject:name forKey:kMatch_name];
    [output setObject:description forKey:kMatch_description];
    [output setObject:[dateFormatter stringFromDate:creationDate] forKey:kMatch_creationDate];
    [output setObject:[NSNumber numberWithInteger:matchId.integerValue] forKey:kMatch_matchId];
//    [output setObject:matchPlace forKey:kMatch_matchPlace];
    [output setObject:[dateFormatter stringFromDate:matchDate] forKey:kMatch_matchDate];
    [output setObject:[NSNumber numberWithBool:announcable] forKey:kMatch_announcable];
    [output setObject:[NSNumber numberWithBool:recordable] forKey:kMatch_recordable];
    [output setObject:[teamA exportToDictionary] forKey:kMatch_teamA];
    [output setObject:[teamB exportToDictionary] forKey:kMatch_teamB];
    [output setObject:rating forKey:kMatch_rating];
    [output setObject:matchType forKey:kMatch_matchType];
    return output;
}
@end

@implementation MatchScore
@synthesize home, awayTeamName, homeScore, awayScore, goalPlayers, assistPlayers;

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        [self setHome:[[Team alloc] initWithData:[data objectForKey:kMatchScore_homeTeam]]];
        [self setAwayTeamName:[data objectForKey:kMatchScore_awayTeam]];
        [self setHomeScore:[data objectForKey:kMatchScore_homeScore]];
        [self setAwayScore:[data objectForKey:kMatchScore_awayScore]];
        NSMutableArray *goalPlayersArray = [[NSMutableArray alloc] init];
        for (NSDictionary *player in [data objectForKey:kMatchScore_goalPlayers]) {
            [goalPlayersArray addObject:[[UserInfo alloc] initWithData:player]];
        }
        [self setGoalPlayers:goalPlayersArray];
        NSMutableArray *assistPlayersArray = [[NSMutableArray alloc] init];
        for (NSDictionary *player in [data objectForKey:kMatchScore_assistPlayers]) {
            [assistPlayersArray addObject:[[UserInfo alloc] initWithData:player]];
        }
        [self setAssistPlayers:assistPlayersArray];
    }
    return self;
}

-(NSDictionary *)exportToDictionary
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setObject:[home exportToDictionary] forKey:kMatchScore_homeTeam];
    [output setObject:awayTeamName forKey:kMatchScore_awayTeam];
    [output setObject:homeScore forKey:kMatchScore_homeScore];
    [output setObject:awayScore forKey:kMatchScore_awayScore];
    NSMutableArray *goalPlayersArray = [[NSMutableArray alloc] init];
    for (UserInfo *player in goalPlayers) {
//        [goalPlayersArray addObject:[player exportToDictionary]];
    }
    [output setObject:goalPlayersArray forKey:kMatchScore_goalPlayers];
    NSMutableArray *assistPlayersArray = [[NSMutableArray alloc] init];
    for (UserInfo *player in assistPlayers) {
//        [assistPlayersArray addObject:[player exportToDictionary]];
    }
    [output setObject:assistPlayersArray forKey:kMatchScore_assistPlayers];
    return output;
}

@end