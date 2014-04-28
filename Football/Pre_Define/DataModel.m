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
        [self setName:[data objectForKey:kTeam_name]];
        [self setDescription:[data objectForKey:kTeam_description]];
        [self setCreationDate:[data objectForKey:kTeam_creationDate]];
        NSNumber *dataId = [data objectForKey:kTeam_teamId];
        [self setTeamId:dataId.integerValue];
        NSNumber *dataBalance = [data objectForKey:kTeam_balance];
        [self setBalance:dataBalance.integerValue];
        [self setLogo:[data objectForKey:kTeam_logo]];
        NSNumber *dataCaptain = [data objectForKey:kTeam_captain];
        [self setCaptainId:dataCaptain.integerValue];
        [self setSlogan:[data objectForKey:kTeam_slogan]];
        [self setTeamName:[data objectForKey:kTeam_teamName]];
    }
    return self;
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
        NSNumber *dataAge = [data objectForKey:kUserInfo_age];
        [self setAge:dataAge.integerValue];
        NSNumber *dataGender = [data objectForKey:kUserInfo_gender];
        [self setGender:dataGender.boolValue];
        NSDictionary *dataTeam = [data objectForKey:kUserInfo_team];
        [self setTeam:[[Team alloc] initWithData:dataTeam]];
        NSNumber *dataId = [data objectForKey:kUserInfo_userId];
        [self setUserId:dataId.integerValue];
        [self setUserName:[data objectForKey:kUserInfo_userName]];
        [self setPicture:[data objectForKey:kUserInfo_picture]];
        [self setUserType:[data objectForKey:kUserInfo_userType]];
        [self setLoginType:[data objectForKey:kUserInfo_loginType]];
        [self setCity:[data objectForKey:kUserInfo_city]];
    }
    return self;
}
@end

#pragma Match
@implementation Match
@synthesize name, description, creationDate, matchId, matchPlace, matchDate, announcable, recordable, teamA, teamB, rating, contactPersonId, matchType;

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        [self setName:[data objectForKey:kMatch_name]];
        [self setDescription:[data objectForKey:kMatch_description]];
        [self setCreationDate:[data objectForKey:kMatch_creationDate]];
        NSNumber *dataId = [data objectForKey:kMatch_matchId];
        [self setMatchId:dataId.integerValue];
        [self setMatchPlace:[data objectForKey:kMatch_matchPlace]];
        [self setMatchDate:[data objectForKey:kMatch_matchDate]];
        NSNumber *dataAnnouncable = [data objectForKey:kMatch_announcable];
        [self setAnnouncable:dataAnnouncable.boolValue];
        NSNumber *dataRecordable = [data objectForKey:kMatch_recordable];
        [self setRecordable:dataRecordable.boolValue];
        NSDictionary *dataTeamA = [data objectForKey:kMatch_teamA];
        [self setTeamA:[[Team alloc] initWithData:dataTeamA]];
        NSDictionary *dataTeamB = [data objectForKey:kMatch_teamB];
        [self setTeamB:[[Team alloc] initWithData:dataTeamB]];
        NSNumber *dataRating = [data objectForKey:kMatch_rating];
        [self setRating:dataRating.integerValue];
        NSNumber *dataContactPerson = [data objectForKey:kMatch_contactPersonId];
        [self setContactPersonId:dataContactPerson.integerValue];
        NSNumber *dataType = [data objectForKey:kMatch_matchType];
        [self setMatchType:dataType.integerValue];
    }
    return self;
}
@end