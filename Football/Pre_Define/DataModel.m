//
//  DataModel.m
//  Football
//
//  Created by Andy on 14-4-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#import "DataModel.h"

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
@implementation UserInfo
@synthesize name, userId, gender, age, team, userName, userType, picture, loginType, city;

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        [self setName:[data objectForKey:kUserInfo_name]];
        [self setAge:[data objectForKey:kUserInfo_age]];
        [self setGender:[data objectForKey:kUserInfo_gender]];
        NSDictionary *dataTeam = [data objectForKey:kUserInfo_team];
        [self setTeam:[[Team alloc] initWithData:dataTeam]];
        [self setUserId:[data objectForKey:kUserInfo_userId]];
        [self setUserName:[data objectForKey:kUserInfo_userName]];
        [self setPicture:[data objectForKey:kUserInfo_picture]];
        [self setUserType:[data objectForKey:kUserInfo_userType]];
        [self setLoginType:[data objectForKey:kUserInfo_loginType]];
        [self setCity:[data objectForKey:kUserInfo_city]];
    }
    return self;
}

-(NSDictionary *)exportToDictionary
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setObject:name forKey:kUserInfo_name];
    [output setObject:age forKey:kUserInfo_age];
    [output setObject:gender forKey:kUserInfo_gender];
    [output setObject:[team exportToDictionary] forKey:kUserInfo_team];
    [output setObject:userId forKey:kUserInfo_userId];
    [output setObject:userName forKey:kUserInfo_userName];
    if ([picture isEqual:[NSNull null]]) {
        [output setObject:[NSNull null] forKey:kUserInfo_picture];
    }
    else {
        [output setObject:[picture base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] forKey:kUserInfo_picture];
    }
    [output setObject:userType forKey:kUserInfo_userType];
    [output setObject:loginType forKey:kUserInfo_loginType];
    [output setObject:city forKey:kUserInfo_city];
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
        [self setMatchPlace:[data objectForKey:kMatch_matchPlace]];
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
    [output setObject:matchPlace forKey:kMatch_matchPlace];
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
        [goalPlayersArray addObject:[player exportToDictionary]];
    }
    [output setObject:goalPlayersArray forKey:kMatchScore_goalPlayers];
    NSMutableArray *assistPlayersArray = [[NSMutableArray alloc] init];
    for (UserInfo *player in assistPlayers) {
        [assistPlayersArray addObject:[player exportToDictionary]];
    }
    [output setObject:assistPlayersArray forKey:kMatchScore_assistPlayers];
    return output;
}

@end