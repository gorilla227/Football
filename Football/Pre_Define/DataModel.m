//
//  DataModel.m
//  Football
//
//  Created by Andy on 14-4-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//
#import "DataModel.h"

#pragma ActivityRegion
@implementation ActivityRegion
+(NSArray *)stringWithCode:(NSArray *)code
{
    //Load ActivityRegions.json
    NSString *fileString = [[NSBundle mainBundle] pathForResource:@"ActivityRegions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fileString];
    NSArray *locationList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //Search codes in locationList
    NSMutableArray *stringArray = [[NSMutableArray alloc] initWithCapacity:code.count];
    for (NSDictionary *province in locationList) {
        if ([[province objectForKey:@"id"] isEqualToString:code[0]]) {
            [stringArray addObject:[province objectForKey:@"name"]];
            if (code.count > 1) {
                for (NSDictionary *city in [province objectForKey:@"city"]) {
                    if ([[city objectForKey:@"id"] isEqualToString:code[1]]) {
                        [stringArray addObject:[city objectForKey:@"name"]];
                        if (code.count > 2) {
                            for (NSDictionary *district in [city objectForKey:@"district"]) {
                                if ([[district objectForKey:@"id"] isEqualToString:code[2]]) {
                                    [stringArray addObject:[district objectForKey:@"name"]];
                                    break;
                                }
                            }
                        }
                        break;
                    }
                }
            }
            break;
        }
    }
    return stringArray;
}

+(NSArray *)codeWithString:(NSArray *)string
{
    //Load ActivityRegions.json
    NSString *fileString = [[NSBundle mainBundle] pathForResource:@"ActivityRegions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fileString];
    NSArray *locationList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //Search codes in locationList
    NSMutableArray *codeArray = [[NSMutableArray alloc] initWithCapacity:string.count];
    for (NSDictionary *province in locationList) {
        if ([[province objectForKey:@"name"] isEqualToString:string[0]]) {
            [codeArray addObject:[province objectForKey:@"id"]];
            if (string.count > 1) {
                for (NSDictionary *city in [province objectForKey:@"city"]) {
                    if ([[city objectForKey:@"name"] isEqualToString:string[1]]) {
                        [codeArray addObject:[city objectForKey:@"id"]];
                        if (string.count > 2) {
                            for (NSDictionary *district in [city objectForKey:@"district"]) {
                                if ([[district objectForKey:@"name"] isEqualToString:string[2]]) {
                                    [codeArray addObject:[district objectForKey:@"id"]];
                                    break;
                                }
                            }
                        }
                        break;
                    }
                }
            }
            break;
        }
    }
    return codeArray;
}
@end

#pragma Position
@implementation Position
+(NSString *)stringWithCode:(NSInteger)position
{
    NSArray *positionList = [gUIStrings objectForKey:@"UI_Positions"];
    return [positionList objectAtIndex:position];
}

+(NSArray *)positionList
{
    return [gUIStrings objectForKey:@"UI_Positions"];
}
@end

#pragma Age
@implementation Age
+(NSInteger)ageFromDate:(NSDate *)birthday
{
    NSDateComponents *ageComponenets = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:birthday toDate:[NSDate date] options:0];
    return ageComponenets.year;
}

+(NSInteger)ageFromString:(NSString *)birthdayString
{
    NSDateFormatter *birthdayDateFormatter = [[NSDateFormatter alloc] init];
    [birthdayDateFormatter setDateFormat:def_MatchDateformat];
    NSDate *birthday = [birthdayDateFormatter dateFromString:birthdayString];
    return [Age ageFromDate:birthday];
}
@end

#pragma Message
@implementation Message
@synthesize messageId, senderId, receiverId, senderName, receiverName, creationDate, messageBody, messageType, status, matchId;
-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        [self setMessageId:[[data objectForKey:kMessage_id] integerValue]];
        [self setSenderId:[[data objectForKey:kMessage_senderId] integerValue]];
        [self setReceiverId:[[data objectForKey:kMessage_receiverId] integerValue]];
        [self setSenderName:[data objectForKey:kMessage_senderName]];
        [self setReceiverName:[data objectForKey:kMessage_receiverName]];
        [self setCreationDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kMessage_createTime] integerValue]]];
        [self setMessageBody:[data objectForKey:kMessage_body]];
        [self setMessageType:[[data objectForKey:kMessage_type] integerValue]];
        [self setStatus:[[data objectForKey:kMessage_status] integerValue]];
        [self setMatchId:[[data objectForKey:kMessage_matchId] integerValue]];
    }
    return self;
}
@end

#pragma Stadium
@implementation Stadium
@synthesize stadiumId, stadiumName, address, phoneNumber, price, comment, coordinate, distance, title, subtitle;

-(id)copy
{
    Stadium *staduimCopy = [[Stadium alloc] init];
    //Copy required properties
    [staduimCopy setStadiumId:stadiumId];
    [staduimCopy setStadiumName:[stadiumName copy]];
    [staduimCopy setAddress:[address copy]];
    [staduimCopy setCoordinate:coordinate];
    //Copy option properties
    if (phoneNumber) {
        [staduimCopy setPhoneNumber:[phoneNumber copy]];
    }
    [staduimCopy setPrice:price];
    [staduimCopy setComment:[comment copy]];
    [staduimCopy setDistance:distance];
    return staduimCopy;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        [self setStadiumId:[[data objectForKey:kStadium_id] integerValue]];
        [self setStadiumName:[data objectForKey:kStadium_name]];
        [self setAddress:[data objectForKey:kStadium_address]];
        [self setPhoneNumber:[data objectForKey:kStadium_phoneNumber]];
        [self setPrice:[[data objectForKey:kStadium_price] integerValue]];
        CLLocationCoordinate2D coordinateData;
        coordinateData.longitude = [[data objectForKey:kStadium_longitude] floatValue];
        coordinateData.latitude = [[data objectForKey:kStadium_latitude] floatValue];
        [self setCoordinate:coordinateData];
        [self setComment:[data objectForKey:kStadium_comment]];
    }
    return self;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}

-(NSString *)title
{
    return stadiumName;
}

-(NSString *)subtitle
{
    return address;
}
@end

#pragma Team
@implementation Team
@synthesize teamId, teamName, numOfMember, activityRegion, slogan, creationDate, teamLogo, homeStadium, recruitFlag, challengeFlag, recruitAnnouncement, challengeAnnouncement;

-(id)copy
{
    Team *teamCopy = [[Team alloc] init];
    //Copy required properties
    [teamCopy setTeamId:teamId];
    [teamCopy setTeamName:[teamName copy]];
    [teamCopy setCreationDate:[creationDate copy]];
    [teamCopy setRecruitFlag:recruitFlag];
    [teamCopy setChallengeFlag:challengeFlag];
    //Copy option properties
    [teamCopy setNumOfMember:numOfMember];
    if (activityRegion) {
        [teamCopy setActivityRegion:[activityRegion copy]];
    }
    if (slogan) {
        [teamCopy setSlogan:[slogan copy]];
    }
    if (teamLogo) {
        [teamCopy setTeamLogo:[teamLogo copy]];
    }
    if (homeStadium) {
        [teamCopy setHomeStadium:[homeStadium copy]];
    }
    if (recruitAnnouncement) {
        [teamCopy setRecruitAnnouncement:[recruitAnnouncement copy]];
    }
    if (challengeAnnouncement) {
        [teamCopy setChallengeAnnouncement:[challengeAnnouncement copy]];
    }
    
    return teamCopy;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        [self setTeamId:[[data objectForKey:kTeam_teamId] integerValue]];
        [self setTeamName:[data objectForKey:kTeam_teamName]];
        [self setNumOfMember:[[data objectForKey:kTeam_numOfTeam] integerValue]];
        [self setActivityRegion:[[data objectForKey:kTeam_activityRegion] componentsSeparatedByString:@"-"]];
        [self setSlogan:[data objectForKey:kTeam_slogan]];
        [self setCreationDate:[data objectForKey:kTeam_creationDate]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[data objectForKey:kTeam_logo]]];
        [self setTeamLogo:[UIImage imageWithData:imageData]];
        [self setRecruitFlag:[[data objectForKey:kTeam_recruitFlag] boolValue]];
        [self setChallengeFlag:[[data objectForKey:kTeam_challengeFlag] boolValue]];
        [self setRecruitAnnouncement:[data objectForKey:kTeam_recruitAnnoucement]];
        [self setChallengeAnnouncement:[data objectForKey:kTeam_challengeAnnoucement]];
        NSDictionary *homeStadiumData = [data objectForKey:kTeam_homeStadium];
        if (homeStadiumData) {
            [self setHomeStadium:[[Stadium alloc] initWithData:homeStadiumData]];
        }
    }
    return self;
}

-(NSDictionary *)dictionaryForUpdate:(Team *)originalTeam withPlayer:(NSInteger)playerId
{
    NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
    [output setObject:[NSNumber numberWithInteger:teamId] forKey:kTeam_teamId];
    [output setObject:[NSNumber numberWithInteger:playerId] forKey:kTeam_playerId];
    //Compare required properties
    if (![teamName isEqualToString:originalTeam.teamName]) {
        [output setObject:teamName forKey:kTeam_teamName];
    }
    if (recruitFlag != originalTeam.recruitFlag) {
        [output setObject:[NSNumber numberWithBool:recruitFlag] forKey:kTeam_recruitFlag];
    }
    if (challengeFlag != originalTeam.challengeFlag) {
        [output setObject:[NSNumber numberWithBool:challengeFlag] forKey:kTeam_challengeFlag];
    }
    //Compare optional properties
    if (![activityRegion isEqual:originalTeam.activityRegion]) {
        [output setObject:[activityRegion componentsJoinedByString:@"-"] forKey:kTeam_activityRegion];
    }
    if (![slogan isEqualToString:originalTeam.slogan]) {
        [output setObject:slogan forKey:kTeam_slogan];
    }
    if (homeStadium.stadiumId != originalTeam.homeStadium.stadiumId) {
        [output setObject:[NSNumber numberWithInteger:homeStadium.stadiumId] forKey:kTeam_homeStadiumId];
    }
    if (originalTeam.teamLogo && !teamLogo) {
        [output setObject:[NSNull null] forKey:kTeam_logo];
    }
    else if (teamLogo && ![UIImagePNGRepresentation(teamLogo) isEqual:UIImagePNGRepresentation(originalTeam.teamLogo)]){
        [output setObject:teamLogo forKey:kTeam_logo];
    }
    if (![recruitAnnouncement isEqualToString:originalTeam.recruitAnnouncement]) {
        [output setObject:recruitAnnouncement forKey:kTeam_recruitAnnoucement];
    }
    if (![challengeAnnouncement isEqualToString:originalTeam.challengeAnnouncement]) {
        [output setObject:challengeAnnouncement forKey:kTeam_challengeAnnoucement];
    }
    return output;
}
@end

#pragma UserInfo
@implementation UserInfo
@synthesize userId, mobile, userType, nickName, legalName, gender, email, qq, birthday, activityRegion, position, style, playerPortrait, team;

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
    if (team) {
        [userInfoCopy setTeam:[team copy]];
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
        [self setActivityRegion:[[data objectForKey:kUserInfo_activityRegion] componentsSeparatedByString:@"-"]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[data objectForKey:kUserInfo_playerPortrait]]];
        [self setPlayerPortrait:[UIImage imageWithData:imageData]];
        NSDictionary *teamData = [data objectForKey:kUserInfo_team];
        if ([teamData isKindOfClass:[NSDictionary class]]) {
            [self setTeam:[[Team alloc] initWithData:teamData]];
        }
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
    if (originalUserInfo.playerPortrait && !playerPortrait) {
        [output setObject:[NSNull null] forKey:kUserInfo_playerPortrait];
    }
    else if (playerPortrait && ![UIImagePNGRepresentation(playerPortrait) isEqual:UIImagePNGRepresentation(originalUserInfo.playerPortrait)]){
        [output setObject:playerPortrait forKey:kUserInfo_playerPortrait];
    }
    return output;
}
@end

#pragma Match
@implementation Match
@synthesize matchId, matchTitle, beginTime, beginTimeLocal, matchField, homeTeam, awayTeam, homeTeamGoal, awayTeamGoal, matchStandard, cost, withReferee, withWater, organizerId, status, createTime, createTimeLocal, sentMatchNotices, confirmedMember, confirmedTemp, matchNotice;
-(id)copy
{
    Match *matchCopy = [[Match alloc] init];
    [matchCopy setMatchId:matchId];
    [matchCopy setMatchTitle:[matchTitle copy]];
    [matchCopy setBeginTime:[beginTime copy]];
    [matchCopy setBeginTimeLocal:[beginTimeLocal copy]];
    [matchCopy setMatchField:[matchField copy]];
    [matchCopy setHomeTeam:[homeTeam copy]];
    [matchCopy setAwayTeam:[awayTeam copy]];
    [matchCopy setHomeTeamGoal:homeTeamGoal];
    [matchCopy setAwayTeamGoal:awayTeamGoal];
    [matchCopy setMatchStandard:matchStandard];
    [matchCopy setCost:[cost copy]];
    [matchCopy setWithReferee:withReferee];
    [matchCopy setWithWater:withWater];
    [matchCopy setOrganizerId:organizerId];
    [matchCopy setStatus:status];
    [matchCopy setCreateTime:[createTime copy]];
    [matchCopy setCreateTimeLocal:[createTimeLocal copy]];
    [matchCopy setSentMatchNotices:[sentMatchNotices copy]];
    [matchCopy setConfirmedMember:[confirmedMember copy]];
    [matchCopy setConfirmedTemp:[confirmedTemp copy]];
    [matchCopy setMatchNotice:[matchNotice copy]];
    return matchCopy;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:def_MatchDateAndTimeformat];
        
        [self setMatchId:[[data objectForKey:kMatch_matchId] integerValue]];
        [self setMatchTitle:[data objectForKey:kMatch_matchTitle]];
        [self setBeginTime:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kMatch_beginTime] integerValue]]];
        [self setBeginTimeLocal:[dateFormatter stringFromDate:self.beginTime]];
        [self setMatchField:[[Stadium alloc] initWithData:[data objectForKey:kMatch_matchField]]];
        [self setHomeTeam:[[Team alloc] initWithData:[data objectForKey:kMatch_homeTeam]]];
        [self setAwayTeam:[[Team alloc] initWithData:[data objectForKey:kMatch_awayTeam]]];
        [self setHomeTeamGoal:[[data objectForKey:kMatch_homeTeamGoal] integerValue]];
        [self setAwayTeamGoal:[[data objectForKey:kMatch_awayTeamGoal] integerValue]];
        [self setMatchStandard:[[data objectForKey:kMatch_matchStandard] integerValue]];
        [self setCost:[data objectForKey:kMatch_cost]];
        [self setWithReferee:[[data objectForKey:kMatch_withReferee] boolValue]];
        [self setWithWater:[[data objectForKey:kMatch_withWater] boolValue]];
        [self setOrganizerId:[[data objectForKey:kMatch_organizerId] integerValue]];
        [self setStatus:[[data objectForKey:kMatch_status] integerValue]];
        [self setCreateTime:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:kMatch_createTime] integerValue]]];
        [self setCreateTimeLocal:[dateFormatter stringFromDate:createTime]];
        [self setSentMatchNotices:[data objectForKey:kMatch_sentMatchNotices]];
        [self setConfirmedMember:[data objectForKey:kMatch_confirmedMember]];
        [self setConfirmedTemp:[data objectForKey:kMatch_confirmedTemp]];
        if ([[data objectForKey:kMatch_matchNotice] isKindOfClass:[NSDictionary class]]) {
            [self setMatchNotice:[[Message alloc] initWithData:[data objectForKey:kMatch_matchNotice]]];
        }
    }
    return self;
}

-(NSDictionary *)dictionaryForUpdate:(Match *)originalMatch
{
    NSMutableDictionary *ouput = [[NSMutableDictionary alloc] init];
    [ouput setObject:[NSNumber numberWithInteger:matchId] forKey:kMatch_matchId];
    if (![matchTitle isEqualToString:originalMatch.matchTitle]) {
        [ouput setObject:matchTitle forKey:kMatch_matchTitle];
    }
    if (![beginTime isEqualToDate:originalMatch.beginTime]) {
        [ouput setObject:beginTime forKey:kMatch_beginTime];
    }
    if (![beginTimeLocal isEqualToString:originalMatch.beginTimeLocal]) {
        [ouput setObject:beginTimeLocal forKey:kMatch_beginTimeLocal];
    }
    if (matchField.stadiumId != originalMatch.matchField.stadiumId) {
        [ouput setObject:matchField forKey:kMatch_matchField];
    }
    if (homeTeam.teamId != originalMatch.homeTeam.teamId) {
        [ouput setObject:homeTeam forKey:kMatch_homeTeam];
    }
    if (awayTeam.teamId != originalMatch.awayTeam.teamId) {
        [ouput setObject:awayTeam forKey:kMatch_awayTeam];
    }
    if (homeTeamGoal != originalMatch.homeTeamGoal) {
        [ouput setObject:[NSNumber numberWithInteger:homeTeamGoal] forKey:kMatch_homeTeamGoal];
    }
    if (awayTeamGoal != originalMatch.awayTeamGoal) {
        [ouput setObject:[NSNumber numberWithInteger:awayTeamGoal] forKey:kMatch_awayTeamGoal];
    }
    if (matchStandard != originalMatch.matchStandard) {
        [ouput setObject:[NSNumber numberWithInteger:matchStandard] forKey:kMatch_matchStandard];
    }
    if (![cost isEqualToNumber:originalMatch.cost]) {
        [ouput setObject:cost forKey:kMatch_cost];
    }
    if (withReferee != originalMatch.withReferee) {
        [ouput setObject:[NSNumber numberWithBool:withReferee] forKey:kMatch_withReferee];
    }
    if (withWater != originalMatch.withWater) {
        [ouput setObject:[NSNumber numberWithBool:withWater] forKey:kMatch_withWater];
    }
    if (organizerId != originalMatch.organizerId) {
        [ouput setObject:[NSNumber numberWithInteger:organizerId] forKey:kMatch_organizerId];
    }
    if (status != originalMatch.status) {
        [ouput setObject:[NSNumber numberWithInteger:status] forKey:kMatch_status];
    }
    if (![createTime isEqualToDate:originalMatch.createTime]) {
        [ouput setObject:createTime forKey:kMatch_createTime];
    }
    if (![createTimeLocal isEqualToString:originalMatch.createTimeLocal]) {
        [ouput setObject:createTimeLocal forKey:kMatch_createTimeLocal];
    }
    if (![sentMatchNotices isEqualToNumber:originalMatch.sentMatchNotices]) {
        [ouput setObject:sentMatchNotices forKey:kMatch_sentMatchNotices];
    }
    if (![confirmedMember isEqualToNumber:originalMatch.confirmedMember]) {
        [ouput setObject:confirmedMember forKey:kMatch_confirmedMember];
    }
    if (![confirmedTemp isEqualToNumber:originalMatch.confirmedTemp]) {
        [ouput setObject:confirmedTemp forKey:kMatch_confirmedTemp];
    }
    if (matchNotice.messageId != originalMatch.matchNotice.messageId) {
        [ouput setObject:matchNotice forKey:kMatch_matchNotice];
    }
    return ouput;
}

-(NSDictionary *)dictionaryForCreateMatchWithRealTeam {
    NSMutableDictionary *output = [NSMutableDictionary new];
    [output setObject:matchTitle forKey:kMatch_matchTitle];
    [output setObject:[NSNumber numberWithInteger:[beginTime timeIntervalSince1970]] forKey:kMatch_beginTime];
    [output setObject:[NSNumber numberWithInteger:12] forKey:kMatch_homeTeamCaptainId];
    [output setObject:[NSNumber numberWithInteger:6] forKey:kMatch_awayTeamCaptainId];
    [output setObject:[NSNumber numberWithInteger:matchStandard] forKey:kMatch_matchStandard];
    [output setObject:cost forKey:kMatch_cost];
    [output setObject:[NSNumber numberWithBool:withReferee] forKey:kMatch_withReferee];
    [output setObject:[NSNumber numberWithBool:withWater] forKey:kMatch_withWater];
    [output setObject:[NSNumber numberWithInteger:organizerId] forKey:kMatch_organizerId];
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
//    [output setObject:[home exportToDictionary] forKey:kMatchScore_homeTeam];
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