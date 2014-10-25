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

//Add New Stadium
#define CONNECT_AddStadium_Suffix @"field/create"
#define CONNECT_AddStadium_Parameters(name, address, price, phone, long, lat, comment) @{@"name":name, @"location":address, @"price":price, @"phone_number":phone, @"longitude":long, @"latitude":lat, @"comment":comment}

//Get Team
#define CONNECT_AllTeams_Suffix @"team/list"
#define CONNECT_AllTeams_Parameters(start, count) [NSMutableDictionary dictionaryWithDictionary:@{@"start":start, @"count":count}]
#define CONNECT_Team_Suffix @"team/listone"
#define CONNECT_Team_Parameters(teamId) @{@"team_id":teamId}

//Get Team Members
#define CONNECT_TeamMembers_Suffix @"teammember/list"
#define CONNECT_TeamMembers_Parameters(teamId) @{@"team_id":teamId}

//Request PlayerBySearchCriteria
#define CONNECT_SearchPlayersCriteria_Suffix @"store/querymember"
#define CONNECT_SearchPlayersCriteria_Parameters(start, count) [NSMutableDictionary dictionaryWithDictionary:@{@"start":start, @"count":count}]
#define CONNECT_SearchPlayersCriteria_ParameterKey_Nickname @"nickname"
#define CONNECT_SearchPlayersCriteria_ParameterKey_HaveTeam @"haveTeam"
#define CONNECT_SearchPlayersCriteria_ParameterKey_Position @"position"
#define CONNECT_SearchPlayersCriteria_ParameterKey_AgeCap @"ageCap"
#define CONNECT_SearchPlayersCriteria_ParameterKey_AgeFloor @"ageFloor"
#define CONNECT_SearchPlayersCriteria_ParameterKey_ActivityRegion @"location"

//Create Team
#define CONNECT_CreateTeam_Suffix @"team/create"
#define CONNECT_CreateTeam_Parameter(captainId, teamName, activityRegion, homeStadiumId, slogan, recruitFlag, recruitSlogan, challengeFlag, challengeSlogan) @{@"member_id": captainId, @"name":teamName, @"location":activityRegion, @"home_field_id":homeStadiumId, @"slogan":slogan, @"call_for_new":recruitFlag, @"call_for_new_board":recruitSlogan, @"call_for_game":challengeFlag, @"call_for_game_board":challengeSlogan}


//Applyin a Team
#define CONNECT_Applyin_Suffix @"message/applyin"
#define CONNECT_Applyin_Parameters(from, to, message) @{@"from":from, @"to_team":to, @"message":message}
#define CONNECT_ReplyApplyin_Suffix @"message/replyapplyin"
#define CONNECT_ReplyApplyin_Parameters(messageId, response) @{@"message_id":messageId, @"response":response}

//Callin a Player
#define CONNECT_Callin_Suffix @"message/callin"
#define CONNECT_Callin_Parameters(from, to, message) @{@"from_team":from, @"to":to, @"message":message}
#define CONNECT_ReplyCallin_Suffix @"message/replycallin"
#define CONNECT_ReplyCallin_Parameters(messageId, response) @{@"message_id":messageId, @"response":response}


//Get Messages
#define CONNECT_RequestMessages_Suffix @"message/receive"
#define CONNECT_RequestMessages_ReceivedParameters(receiver, type, status, start, count) @{@"to":receiver, @"type":type, @"status":status, @"start":start, @"count":count}
#define CONNECT_RequestMessages_SentParameters(sender, type, status, start, count) @{@"from":sender, @"type":type, @"status":status, @"start":start, @"count":count}
#define CONNECT_RequestMessages_Parameters_DefaultStatus @[[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], [NSNumber numberWithInteger:3], [NSNumber numberWithInteger:4]]

//Get Unread Message Amount
#define CONNECT_UnreadMessageAmount_Suffix @"message/unreadcount"
#define CONNECT_UnreadMessageAmount_Parameters(type, receiver) @{@"type":type, @"to":receiver}

//Set Messages as Read
#define CONNECT_ReadMessages_Suffix @"message/update"
#define CONNECT_ReadMessages_Parameters(messageIdList) @{@"id_list":messageIdList}


//Get Matchlist
#define CONNECT_MatchList_Suffix @"match/list"
#define CONNECT_MatchList_Parameters(teamId) @{@"team_id":teamId}



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