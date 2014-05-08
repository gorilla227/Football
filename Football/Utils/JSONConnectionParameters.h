//
//  JSONConnectionParameters.h
//  Football
//
//  Created by Andy on 14-4-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

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
#define JSON_suffix_allStadiums @"stadiums"