//
//  JSONConnectionParameters.h
//  Football
//
//  Created by Andy on 14-4-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#pragma new Server
#define CONNECT_ServerURL @"http://soccer.ckxgroup.cn"

//Login
#define CONNECT_Login_Suffix @"member/verify"
#define CONNECT_Login_Parameters(account, password) @{@"user":account, @"password":password}

//Get userInfo
#define CONNECT_UserInfo_Suffix @"member/profile"
#define CONNECT_UserInfo_Parameters(userId, with_team_info) @{@"id":[NSNumber numberWithInteger:userId], @"with_team_info":[NSNumber numberWithInteger:with_team_info]}

//Register Player
#define CONNECT_RegisterPlayer_Suffix @"member/memberregister"
#define CONNECT_RegisterPlayer_Parameters(mobile, email, password, nickname) @{@"mobile":mobile, @"email":email, @"password":password, @"nick_name":nickname}

//Register Captain
#define CONNECT_RegisterCaptain_Suffix @"member/captainregister"
#define CONNECT_RegisterCaptain_Parameters(mobile, email, password, nickname, teamname) @{@"mobile":mobile, @"email":email, @"password":password, @"nick_name":nickname, @"team_name":teamname}

//Update Player Profile
#define CONNECT_UpdatePlayerProfile_Suffix @"member/update"

//Update PlayerPortrait
#define CONNECT_UpdatePlayerPortrait_Suffix @"upload/memberlogo"
#define CONNECT_UpdatePlayerPortrait_Parameters(playerId) @{@"member_id":playerId}

//Reset PlayerPortrait
#define CONNECT_ResetPlayerPortrait_Suffix @"upload/memberlogoreset"
#define CONNECT_ResetPlayerPortrait_Parameters(playerId) @{@"member_id":playerId}

//Update Team Profile
#define CONNECT_UpdateTeamProfile_Suffix @"team/update"

//Update TeamLogo
#define CONNECT_UpdateTeamLogo_Suffix @"upload/teamlogo"
#define CONNECT_UpdateTeamLogo_Parameters(teamId) @{@"team_id":teamId}

//Reset TeamLogo
#define CONNECT_ResetTeamLogo_Suffix @"upload/teamlogoreset"
#define CONNECT_ResetTeamLogo_Parameters(teamId) @{@"team_id":teamId}

//Get AllStadiums
#define CONNECT_AllStadiums_Suffix @"field/list"

//Get AllTeams
#define CONNECT_AllTeams_Suffix @"team/list"
#define CONNECT_AllTeams_Parameters(start, count) [NSMutableDictionary dictionaryWithDictionary:@{@"start":start, @"count":count}]

//Applyin a Team
#define CONNECT_ApplyinTeam_Suffix @"message/applyin"
#define CONNECT_ApplyinTeam_Parameters(from, to, message) @{@"from":from, @"to":to, @"message":message}


//Get Messages
#define CONNECT_RequestMessages_Suffix @"message/receive"
#define CONNECT_RequestMessages_Parameters(receiver, type, start, count) @{@"to":receiver, @"type":type, @"start":start, @"count":count}




#pragma zzOld_Server
//JSON variables
#define JSON_serverURL @"http://inomind.de:8080/SoccerServer"
#define JSON_suffix_allMatches @"matches.json"
#define JSON_suffix_allTeams @"teams.json"
#define JSON_suffix_allUsers @"users.json"

#pragma Parameters
//count - how many matches should be shown. by default 10 matches will be displayed(count=10)
#define JSON_parameter_common_count @"count"
#define JSON_parameter_common_count_default 10
//startIndex - starting from which match should be returned. by default startIndex = 0.
#define JSON_parameter_common_startIndex @"startIndex"
#define JSON_parameter_common_startIndex_default 0

//Get Match by MatchId
#define JSON_suffix_matchByMatchId @"match"
#define JSON_parameter_matchId @"id"
//Get Matches by TeamId or UserId
#define JSON_suffix_matchesByTeamIdOrUserId @"matches"
#define JSON_parameter_matches_teamId @"teamId"
#define JSON_parameter_matches_userId @"userId"

//Get Team by TeamId
#define JSON_suffix_teamByTeamId @"team"
#define JSON_parameter_teamId @"id"
//Post a team
#define JSON_suffix_postTeam @"addTeam"

//Get User by UserId
#define JSON_suffix_userById @"user"
#define JSON_parameter_userId @"id"
//Get Players by TeamId
#define JSON_suffix_playersByTeamId @"players"
#define JSON_parameter_players_teamId @"teamId"
//Post a user
#define JSON_suffix_postUser @"addUser"

//Get Stadiums
#define JSON_suffix_stadiums @"stadiums"
#define JSON_suffix_stadiumById @"stadium"
#define JSON_parameter_stadiumId @"id"
#define JSON_parameter_stadiums_teamId @"team_id"