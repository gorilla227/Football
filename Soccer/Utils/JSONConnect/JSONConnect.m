//
//  JSONConnect.m
//  Soccer
//
//  Created by Andy on 14-4-30.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "JSONConnect.h"

@implementation JSONConnect{
    AFHTTPRequestOperationManager *manager;
}
@synthesize delegate, busyIndicatorDelegate;

-(id)initWithDelegate:(id)responser andBusyIndicatorDelegate:(id)indicatorDelegate
{
    self = [super init];
    if (self) {
        [self setDelegate:responser];
        [self setBusyIndicatorDelegate:indicatorDelegate];
        manager = [AFHTTPRequestOperationManager manager];
        [manager.responseSerializer setAcceptableContentTypes:[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"]];
    }
    return self;
}

-(void)showErrorAlertView:(NSError *)error otherInfo:(NSString *)otherInfo
{
    UIAlertView *errorAlertView;
    if (error.code < 0) {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"杯具了" message:error.localizedDescription delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil];
    }
    else if (otherInfo){
        if ([otherInfo isEqualToString:@"team name duplicate"]) {
            errorAlertView = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"球队名称已被注册，请重新选择一个球队名称。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        }
        else if ([otherInfo isEqualToString:@"member insert error"]) {
            errorAlertView = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"手机号码或邮箱已被注册，请检查是否输错。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        }
        else if ([otherInfo isEqualToString:@"picture is invalid"]) {
            errorAlertView = [[UIAlertView alloc] initWithTitle:@"杯具了" message:@"上传图片出错！" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil];
        }
        else {
            errorAlertView = [[UIAlertView alloc] initWithTitle:@"杯具了" message:[NSString stringWithFormat:@"未知错误:%@", otherInfo] delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil];
        }
    }
    else {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"杯具了" message:@"未知错误" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil];
    }
    [busyIndicatorDelegate unlockView];
    [errorAlertView show];
}

-(void)cancelAllOperations
{
    [manager.operationQueue cancelAllOperations];
}

#pragma new Server
//LoginVerification
-(void)loginVerification:(NSString *)account password:(NSString *)password
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_Login_Suffix];
    NSDictionary *parameters = CONNECT_Login_Parameters(account, password);
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        NSInteger userId = [[responseObject objectForKey:@"id"] integerValue];
        if (userId > 0) {
            [delegate loginVerificationSuccessfully:userId];
        }
        else {
            [delegate loginVerificationFailed];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//GetUserInfo
-(void)requestUserInfo:(NSInteger)userId withTeam:(BOOL)withTeam withReference:(id)reference
{
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UserInfo_Suffix];
    NSDictionary *parameters = CONNECT_UserInfo_Parameters(userId, withTeam?1:0);
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        if (responseObject) {
            UserInfo *userInfo = [[UserInfo alloc] initWithData:responseObject];
            [delegate receiveUserInfo:userInfo withReference:reference];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//RegisterNewUser
-(void)registerCaptain:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName teamName:(NSString *)teamName
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RegisterCaptain_Suffix];
    NSDictionary *parameters = CONNECT_RegisterCaptain_Parameters(mobile, email, password, nickName, teamName);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        NSInteger member_id = [[responseObject objectForKey:@"member_id"] integerValue];
        NSInteger team_id = [[responseObject objectForKey:@"team_id"] integerValue];
        [delegate registerCaptainSuccessfully:member_id teamId:team_id];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)registerPlayer:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RegisterPlayer_Suffix];
    NSDictionary *parameters = CONNECT_RegisterPlayer_Parameters(mobile, email, password, nickName);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        NSInteger playerId = [[responseObject objectForKey:@"id"] integerValue];
        [delegate registerPlayerSuccessfully:playerId];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//UpdatePlayerProfile
-(void)updatePlayerProfile:(NSDictionary *)playerProfile
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    UIImage *portrait = [playerProfile objectForKey:kUserInfo_playerPortrait];
    if (portrait) {
        //UpdatePlayerPortrait
        if ([portrait isEqual:[NSNull null]]) {
            //Reset PlayerPortrait to Default
            NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_ResetPlayerPortrait_Suffix];
            NSDictionary *parameters = CONNECT_ResetPlayerPortrait_Parameters([playerProfile objectForKey:kUserInfo_userId]);
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (manager.operationQueue.operationCount == 0) {
                    [busyIndicatorDelegate unlockView];
                    [delegate updatePlayerProfileSuccessfully];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showErrorAlertView:error otherInfo:operation.responseString];
            }];
        }
        else {
            //Update New PlayerPortrait
            NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdatePlayerPortrait_Suffix];
            NSDictionary *parameters = CONNECT_UpdatePlayerPortrait_Parameters([playerProfile objectForKey:kUserInfo_userId]);
            [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(portrait, 0.5) name:@"file" fileName:@"memberPortrait.jpg" mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (manager.operationQueue.operationCount == 0) {
                    [busyIndicatorDelegate unlockView];
                    [delegate updatePlayerProfileSuccessfully];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showErrorAlertView:error otherInfo:operation.responseString];
            }];
        }
    }
    //Update PlayerProfile without PlayerPortrait
    NSMutableDictionary *playerProfileParameters = [[NSMutableDictionary alloc] initWithDictionary:playerProfile];
    [playerProfileParameters removeObjectForKey:kUserInfo_playerPortrait];
    if (playerProfileParameters.count > 1) {
        //UpdatePlayerProfile
        NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdatePlayerProfile_Suffix];
        [manager POST:urlString parameters:playerProfileParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (manager.operationQueue.operationCount == 0) {
                [busyIndicatorDelegate unlockView];
                [delegate updatePlayerProfileSuccessfully];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorAlertView:error otherInfo:operation.responseString];
        }];
    }
}

//UpdatePlayerPortrait
-(void)updatePlayerPortrait:(UIImage *)portrait forPlayer:(NSInteger)playerId
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdatePlayerPortrait_Suffix];
    NSDictionary *parameters = CONNECT_UpdatePlayerPortrait_Parameters([NSNumber numberWithInteger:playerId]);
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(portrait, 0.5) name:@"file" fileName:@"memberPortrait.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate updatePlayerPortraitSuccessfully];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//UpdateTeamProfile
-(void)updateTeamProfile:(NSDictionary *)teamProfile
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    UIImage *logo = [teamProfile objectForKey:kTeam_logo];
    if (logo) {
        //UpdateTeamLogo
        if ([logo isEqual:[NSNull null]]) {
            //Reset TeamLogo to Default
            NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_ResetTeamLogo_Suffix];
            NSDictionary *parameters = CONNECT_ResetTeamLogo_Parameters([teamProfile objectForKey:kTeam_teamId]);
            [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (manager.operationQueue.operationCount == 0) {
                    [busyIndicatorDelegate unlockView];
                    [delegate updateTeamProfileSuccessfully];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showErrorAlertView:error otherInfo:operation.responseString];
            }];
        }
        else {
            //Update New TeamLogo
            NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdateTeamLogo_Suffix];
            NSDictionary *parameters = CONNECT_UpdateTeamLogo_Parameters([teamProfile objectForKey:kTeam_teamId]);
            [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(logo, 0.5) name:@"file" fileName:@"teamLogo.jpg" mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (manager.operationQueue.operationCount == 0) {
                    [busyIndicatorDelegate unlockView];
                    [delegate updateTeamProfileSuccessfully];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self showErrorAlertView:error otherInfo:operation.responseString];
            }];
        }
    }
    //Update TeamProfile without TeamLogo
    NSMutableDictionary *teamProfileParameters = [[NSMutableDictionary alloc] initWithDictionary:teamProfile];
    [teamProfileParameters removeObjectForKey:kTeam_logo];
    if (teamProfileParameters.count > 2) {
        //UpdateTeamProfile
        NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdateTeamProfile_Suffix];
        [manager POST:urlString parameters:teamProfileParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (manager.operationQueue.operationCount == 0) {
                [busyIndicatorDelegate unlockView];
                [delegate updateTeamProfileSuccessfully];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorAlertView:error otherInfo:operation.responseString];
        }];
    }
}

//UpdateTeamLogo
-(void)updateTeamLogo:(UIImage *)logo forTeam:(NSInteger)teamId
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdateTeamLogo_Suffix];
    NSDictionary *parameters = CONNECT_UpdateTeamLogo_Parameters([NSNumber numberWithInteger:teamId]);
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(logo, 0.5) name:@"file" fileName:@"teamLogo.jpeg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate updateTeamLogoSuccessfully];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//RequestAllStadiums
-(void)requestAllStadiums
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_AllStadiums_Suffix];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        NSMutableArray *stadiumList = [[NSMutableArray alloc] init];
        for (NSDictionary *stadiumData in responseObject) {
            Stadium *stadium = [[Stadium alloc] initWithData:stadiumData];
            [stadiumList addObject:stadium];
        }
        [delegate receiveAllStadiums:stadiumList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//AddNewStadium
-(void)addStadium:(Stadium *)stadium
{
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_AddStadium_Suffix];
    NSDictionary *parameters = CONNECT_AddStadium_Parameters(stadium.stadiumName, stadium.address, [NSNumber numberWithInteger:stadium.price], stadium.phoneNumber, [NSNumber numberWithDouble:stadium.coordinate.longitude], [NSNumber numberWithDouble:stadium.coordinate.latitude], stadium.comment);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate addStadiumSuccessfully:[[responseObject objectForKey:@"id"] integerValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//RequestTeams
-(void)requestTeamsStart:(NSInteger)start count:(NSInteger)count option:(enum RequestTeamsOption)option
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_AllTeams_Suffix];
    NSMutableDictionary *parameters = CONNECT_AllTeams_Parameters([NSNumber numberWithInteger:start], [NSNumber numberWithInteger:count]);
    switch (option) {
        case RequestTeamsOption_Recruit:
            [parameters setObject:[NSNumber numberWithInteger:1] forKey:kTeam_recruitFlag];
            break;
        case RequestTeamsOption_Challenge:
            [parameters setObject:[NSNumber numberWithInteger:1] forKey:kTeam_challengeFlag];
            break;
        default:
            break;
    }
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        NSMutableArray *teamList = [[NSMutableArray alloc] init];
        for (NSDictionary *teamData in responseObject) {
            Team *team = [[Team alloc] initWithData:teamData];
            [teamList addObject:team];
        }
        [delegate receiveAllTeams:teamList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)requestTeamById:(NSInteger)teamId isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_Team_Suffix];
    NSDictionary *parameters = CONNECT_Team_Parameters([NSNumber numberWithInteger:teamId]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (syncOption) {
            [busyIndicatorDelegate unlockView];
        }
        [delegate receiveTeam:[[Team alloc] initWithData:responseObject]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//RequestTeamMembers
-(void)requestTeamMembers:(NSInteger)teamId withTeamFundHistory:(BOOL)withTeamFundHistory isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_TeamMembers_Suffix];
    NSDictionary *parameters = CONNECT_TeamMembers_Parameters([NSNumber numberWithInteger:teamId], [NSNumber numberWithBool:withTeamFundHistory]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (syncOption) {
            [busyIndicatorDelegate unlockView];
        }
        NSArray *playerList = [NSArray new];
        for (NSDictionary *playerData in responseObject) {
            UserInfo *player = [[UserInfo alloc] initWithData:playerData];
            playerList = [playerList arrayByAddingObject:player];
        }
        [delegate receiveTeamMembers:playerList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//RequestPlayersBySearchCriteria
-(void)requestPlayersBySearchCriteria:(NSDictionary *)searchCriteria startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_SearchPlayersCriteria_Suffix];
    NSMutableDictionary *parameters = CONNECT_SearchPlayersCriteria_Parameters([NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
    if ([searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_Nickname]) {
        [parameters setObject:[searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_Nickname] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_Nickname];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_HaveTeam]) {
        [parameters setObject:[[searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_HaveTeam] boolValue]?@"true":@"false" forKey:CONNECT_SearchPlayersCriteria_ParameterKey_HaveTeam];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_Position]) {
        [parameters setObject:[[searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_Position] componentsJoinedByString:@","] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_Position];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeCap]) {
        [parameters setObject:[searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeCap] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeCap];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeFloor]) {
        [parameters setObject:[searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeFloor] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_AgeFloor];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_ActivityRegion]) {
        [parameters setObject:[[searchCriteria objectForKey:CONNECT_SearchPlayersCriteria_ParameterKey_ActivityRegion] componentsJoinedByString:@"-"] forKey:CONNECT_SearchPlayersCriteria_ParameterKey_ActivityRegion];
    }
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (syncOption) {
            [busyIndicatorDelegate unlockView];
        }
        NSMutableArray *players = [NSMutableArray new];
        for (NSDictionary *playerData in responseObject) {
            UserInfo *player = [[UserInfo alloc] initWithData:playerData];
            [players addObject:player];
        }
        [delegate receivePlayers:players];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseObject);
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//RequestTeamsBySearchCriteria
-(void)requestTeamsBySearchCriteria:(NSDictionary *)searchCriteria startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_SearchTeamsCriteria_Suffix];
    NSMutableDictionary *parameters = CONNECT_SearchTeamsCriteria_Parameters([NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
    if ([searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_Teamname]) {
        [parameters setObject:[searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_Teamname] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_Teamname];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_Flag]) {
        [parameters setObject:[searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_Flag] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_Flag];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_TeamNumberCap]) {
        [parameters setObject:[searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_TeamNumberCap] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_TeamNumberCap];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_TeamNumberFloor]) {
        [parameters setObject:[searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_TeamNumberFloor] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_TeamNumberFloor];
    }
    if ([searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_ActivityRegion]) {
        [parameters setObject:[[searchCriteria objectForKey:CONNECT_SearchTeamsCriteria_ParameterKey_ActivityRegion] componentsJoinedByString:@"-"] forKey:CONNECT_SearchTeamsCriteria_ParameterKey_ActivityRegion];
    }
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (syncOption) {
            [busyIndicatorDelegate unlockView];
        }
        NSMutableArray *teams = [NSMutableArray new];
        for (NSDictionary *teamData in responseObject) {
            Team *team = [[Team alloc] initWithData:teamData];
            [teams addObject:team];
        }
        [delegate receiveTeams:teams];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseObject);
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];

}

//PlayerCreateTeam
-(void)createTeamByCaptainId:(NSInteger)captainId teamProfile:(Team *)teamProfile
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_CreateTeam_Suffix];
    NSDictionary *parameters = CONNECT_CreateTeam_Parameter([NSNumber numberWithInteger:captainId], teamProfile.teamName);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        NSMutableDictionary *teamProfileForUpdate = [NSMutableDictionary dictionaryWithDictionary:[[teamProfile copy] dictionaryForUpdate:nil withPlayer:captainId]];
        [teamProfileForUpdate removeObjectForKey:kTeam_teamName];
        [teamProfileForUpdate addEntriesFromDictionary:responseObject];
        [self updateTeamProfile:teamProfileForUpdate];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
    
}

//RequestMessages
-(void)requestReceivedMessage:(UserInfo *)receiver messageType:(NSString *)messageTypeId status:(NSArray *)status startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestMessages_Suffix];
    NSDictionary *parameters = [NSDictionary new];
    switch (messageTypeId.integerValue) {
        case 1:
        case 3:
        case 4:
        case 6:
            parameters = CONNECT_RequestMessages_ReceivedParameters([NSNumber numberWithInteger:receiver.userId], messageTypeId, [status componentsJoinedByString:@","], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
            break;
        case 2:
        case 5:
            parameters = CONNECT_RequestMessages_ReceivedParameters([NSNumber numberWithInteger:receiver.team.teamId], messageTypeId, [status componentsJoinedByString:@","], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
            break;
        default:
            break;
    }
    if (parameters.count) {
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (syncOption) {
                [busyIndicatorDelegate unlockView];
            }
            NSMutableArray *messageArray = [[NSMutableArray alloc] init];
            for (NSDictionary *messageData in responseObject) {
                Message *message = [[Message alloc] initWithData:messageData];
                [messageArray addObject:message];
            }
            [delegate receiveMessages:messageArray sourceType:RequestMessageSourceType_Receiver];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *request = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
            NSLog(@"%@", request);
            [self showErrorAlertView:error otherInfo:operation.responseString];
        }];
    }
}

-(void)requestSentMessage:(UserInfo *)sender messageType:(NSString *)messageTypeId status:(NSArray *)status startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestMessages_Suffix];
    NSDictionary *parameters = [NSDictionary new];
    switch (messageTypeId.integerValue) {
        case 1:
        case 3:
        case 4:
        case 5:
        case 6:
            parameters = CONNECT_RequestMessages_SentParameters([NSNumber numberWithInteger:sender.team.teamId], messageTypeId, [status componentsJoinedByString:@","], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
            break;
        case 2:
            parameters = CONNECT_RequestMessages_SentParameters([NSNumber numberWithInteger:sender.userId], messageTypeId, [status componentsJoinedByString:@","], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
            break;
        default:
            break;
    }
    if (parameters.count) {
        [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (syncOption) {
                [busyIndicatorDelegate unlockView];
            }
            NSMutableArray *messageArray = [[NSMutableArray alloc] init];
            for (NSDictionary *messageData in responseObject) {
                Message *message = [[Message alloc] initWithData:messageData];
                [messageArray addObject:message];
            }
            [delegate receiveMessages:messageArray sourceType:RequestMessageSourceType_Sender];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSString *request = [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding];
            NSLog(@"%@", request);
            [self showErrorAlertView:error otherInfo:operation.responseString];
        }];
    }
}

//RequestUnreadMessageAmount
-(void)requestUnreadMessageAmount:(UserInfo *)receiver messageTypes:(NSArray *)messageTypes
{
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UnreadMessageAmount_Suffix];
    NSMutableArray *messageTypesForTeamReceiver = [NSMutableArray new];
    NSMutableArray *messageTypesForPlayerReceiver = [NSMutableArray new];
    for (NSString *messageTypeId in messageTypes) {
        switch (messageTypeId.integerValue) {
            case 1:
            case 3:
            case 4:
            case 6:
                [messageTypesForPlayerReceiver addObject:messageTypeId];
                break;
            case 2:
            case 5:
                [messageTypesForTeamReceiver addObject:messageTypeId];
                break;
            default:
                break;
        }
    }
    NSDictionary *parametersForTeamReceiver = CONNECT_UnreadMessageAmount_Parameters([messageTypesForTeamReceiver componentsJoinedByString:@","], [NSNumber numberWithInteger:gMyUserInfo.team.teamId]);
    NSDictionary *parametersForPlayerReceiver = CONNECT_UnreadMessageAmount_Parameters([messageTypesForPlayerReceiver componentsJoinedByString:@","], [NSNumber numberWithInteger:gMyUserInfo.userId]);
    [manager POST:urlString parameters:parametersForPlayerReceiver success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate receiveUnreadMessageAmount:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
    [manager POST:urlString parameters:parametersForTeamReceiver success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate receiveUnreadMessageAmount:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//ReadMessages
-(void)readMessages:(NSArray *)messageIdList
{
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_ReadMessages_Suffix];
    NSDictionary *parameters = CONNECT_ReadMessages_Parameters([messageIdList componentsJoinedByString:@","]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate readMessagesSuccessfully:messageIdList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//ApplyinTeam
-(void)applyinFromPlayer:(NSInteger)playerId toTeam:(NSInteger)teamId withMessage:(NSString *)message
{
    if (!message) {
        NSString *messageTemplateFile = [[NSBundle mainBundle] pathForResource:@"MessageTemplate" ofType:@"plist"];
        NSDictionary *messageTemplate = [NSDictionary dictionaryWithContentsOfFile:messageTemplateFile];
        message = [messageTemplate objectForKey:@"Applyin_Default"];
    }
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_Applyin_Suffix];
    NSDictionary *parameters = CONNECT_Applyin_Parameters([NSNumber numberWithInteger:playerId], [NSNumber numberWithInteger:teamId], message);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
//        [delegate playerApplyinSent];
        [delegate playerApplyinSent:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [delegate playerApplyinFailed];
        [delegate playerApplyinSent:NO];
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)replyApplyinMessage:(NSInteger)messageId response:(NSInteger)responseCode
{
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_ReplyApplyin_Suffix];
    NSDictionary *parameters = CONNECT_ReplyApplyin_Parameters([NSNumber numberWithInteger:messageId], [NSNumber numberWithInteger:responseCode]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate replyApplyinMessageSuccessfully:responseCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//CallinPlayer
-(void)callinFromTeam:(NSInteger)teamId toPlayer:(NSInteger)playerId withMessage:(NSString *)message
{
    if (!message) {
        NSString *messageTemplateFile = [[NSBundle mainBundle] pathForResource:@"MessageTemplate" ofType:@"plist"];
        NSDictionary *messageTemplate = [NSDictionary dictionaryWithContentsOfFile:messageTemplateFile];
        message = [messageTemplate objectForKey:@"Recruit_Default"];
    }
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_Callin_Suffix];
    NSDictionary *parameters = CONNECT_Callin_Parameters([NSNumber numberWithInteger:teamId], [NSNumber numberWithInteger:playerId], message);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
//        [delegate teamCallinSent];
        [delegate teamCallinSent:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [delegate teamCallinFailed];
        [delegate teamCallinSent:NO];
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)replyCallinMessage:(NSInteger)messageId response:(NSInteger)responseCode
{
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_ReplyCallin_Suffix];
    NSDictionary *parameters = CONNECT_ReplyCallin_Parameters([NSNumber numberWithInteger:messageId], [NSNumber numberWithInteger:responseCode]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate replyCallinMessageSuccessfully:responseCode];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Send MatchNotice
-(void)sendMatchNotice:(NSInteger)matchId fromTeam:(NSInteger)teamId toPlayer:(NSInteger)playerId withMessage:(NSString *)message
{
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_SendMatchNotice_Suffix];
    NSDictionary *parameters = CONNECT_SendMatchNotice_Parameters([NSNumber numberWithInteger:matchId], [NSNumber numberWithInteger:teamId], [NSNumber numberWithInteger:playerId], message);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate matchNoticeSent:![[responseObject objectForKey:@"error"] boolValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate matchNoticeSent:NO];
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Response MatchNotice
-(void)replyMatchNotice:(NSInteger)messageId withAnswer:(BOOL)answer {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_ReplyMatchNotice_Suffix];
    NSDictionary *parameters = CONNECT_ReplyMatchNotice_Parameters([NSNumber numberWithInteger:messageId], [NSNumber numberWithInteger:answer?2:3]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate replyMatchNotice:messageId withAnswer:answer isSent:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate replyMatchNotice:messageId withAnswer:answer isSent:NO];
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Send TeamFundNotice
-(void)sendTeamFundNotice:(NSString *)message fromTeam:(NSInteger)teamId toPlayer:(NSInteger)playerId {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_SendTeamFundNotice_Suffix];
    NSDictionary *parameters = CONNECT_SendTeamFundNotice_Parameters([NSNumber numberWithInteger:teamId], [NSNumber numberWithInteger:playerId], message);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate teamFundNoticeSent:![[responseObject objectForKey:@"error"] boolValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate teamFundNoticeSent:NO];
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Request MatchList
-(void)requestMatchesByPlayer:(NSInteger)playerId forTeam:(NSInteger)teamId inStatus:(NSArray *)status sort:(NSInteger)sort count:(NSInteger)count startIndex:(NSInteger)startIndex isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_MatchList_Suffix];
    NSDictionary *parameters = CONNECT_MatchList_Parameters([NSNumber numberWithInteger:playerId], [NSNumber numberWithInteger:teamId], [status componentsJoinedByString:@","], [NSNumber numberWithInteger:sort], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (syncOption) {
            [busyIndicatorDelegate unlockView];
        }
//        NSLog(@"%@", responseObject);
        NSMutableArray *matches = [NSMutableArray new];
        for (NSDictionary *matchData in responseObject) {
            Match *match = [[Match alloc] initWithData:matchData];
            [matches addObject:match];
        }
        [delegate receiveMatchesSuccessfully:matches];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Request Match by matchId
-(void)requestMatchesByMatchId:(NSInteger)matchId {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestMatchByMatchID_Suffix];
    NSDictionary *parameters = CONNECT_RequestMatchByMatchID_Parameter([NSNumber numberWithInteger:matchId]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate receiveMatch:[[Match alloc] initWithData:responseObject]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Update Match Status
-(void)updateMatchStatus:(NSInteger)statusId organizer:(NSInteger)organizerId match:(NSInteger)matchId {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdateMatchStatus_Suffix];
    NSDictionary *parameters = CONNECT_UpdateMatchStatus_Parameters(matchId, organizerId, statusId);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate updatedMatchStatus:![[responseObject objectForKey:@"error"] boolValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Update Match Score
-(void)updateMatchScore:(NSInteger)matchId captainId:(NSInteger)captainId homeScore:(NSInteger)homeScore awayScore:(NSInteger)awayScore {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdateMatchScore_Suffix];
    NSDictionary *parameters = CONNECT_UpdateMatchScore_Parameters([NSNumber numberWithInteger:matchId], [NSNumber numberWithInteger:captainId], [NSNumber numberWithInteger:homeScore], [NSNumber numberWithInteger:awayScore]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate updatedMatchScore:![[responseObject objectForKey:@"error"] boolValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Create Match With Real Team
-(void)createMatchWithRealTeam:(NSDictionary *)newMatch {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_CreateMatchWithRealTeam_Suffix];
    NSDictionary *parameters = CONNECT_CreateMatchWithRealTeam_Parameters(newMatch);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate createMatchWithRealTeam:[[responseObject objectForKey:@"id"] integerValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Reply Match Invitation
-(void)replyMatchInvitation:(Message *)message withAnswer:(BOOL)answer {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_ReplyMatchInvitation_Suffix];
    NSDictionary *parameters = CONNECT_ReplyMatchInvitation_Parameters([NSNumber numberWithInteger:message.messageId], [NSNumber numberWithInteger:message.matchId], [NSNumber numberWithInteger:answer?2:3]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate replyMatchInvitation:message withAnswer:answer isSent:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Request MatchScoreDetails
- (void)requestMatchScoreDetails:(NSInteger)matchId forTeam:(NSInteger)teamId {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestMatchScoreDetails_Suffix];
    NSDictionary *parameters = CONNECT_RequestMatchScoreDetails_Parameters([NSNumber numberWithInteger:matchId], [NSNumber numberWithInteger:teamId]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *scoreDetails = [NSMutableArray new];
        for (NSDictionary *scoreDetail in responseObject) {
            MatchScore *matchScore = [[MatchScore alloc] initWithData:scoreDetail];
            [scoreDetails addObject:matchScore];
        }
        [busyIndicatorDelegate unlockView];
        [delegate receiveMatchScoreDetails:scoreDetails];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Add MatchScore Detail
- (void)addMatchScoreDetail:(NSDictionary *)parameters {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_AddMatchScoreDetail_Suffix];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate addedMatchScoreDetail:![[responseObject objectForKey:@"error"] boolValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Update MatchScore Detail
- (void)updateMatchScoreDetail:(NSDictionary *)parameters {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdateMatchScoreDetail_Suffix];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate updatedMatchScoreDetail:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
        [delegate updatedMatchScoreDetail:NO];
    }];
}

//Request Match Attendence
- (void)requestMatchAttendence:(NSInteger)matchId forTeam:(NSInteger)teamId {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestMatchAttendence_Suffix];
    NSDictionary *parameters = CONNECT_RequestMatchAttendence_Parameters([NSNumber numberWithInteger:matchId], [NSNumber numberWithInteger:teamId]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *attendenceList = [NSMutableArray new];
        for (NSDictionary *attendenceData in responseObject) {
            UserInfo *attendence = [[UserInfo alloc] initWithData:attendenceData];
            [attendenceList addObject:attendence];
        }
        [busyIndicatorDelegate unlockView];
        [delegate receiveMatchAttendence:attendenceList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Request Team Balance
- (void)requestTeamBalance:(NSInteger)teamId forPlayer:(NSInteger)playerId {
//    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestTeamBalance_Suffix];
    NSDictionary *parameters = CONNECT_RequestTeamBalance_Parameters([NSNumber numberWithInteger:teamId], [NSNumber numberWithInteger:playerId]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [busyIndicatorDelegate unlockView];
        [delegate receiveTeamBalance:[responseObject objectForKey:@"left"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
    
}

//Request Balance Transactions
- (void)requestTeamBalanceTransactions:(NSInteger)teamId forPlayer:(NSInteger)playerId startIndex:(NSInteger)startIndex count:(NSInteger)count {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestTeamBalanceTransactions_Suffix];
    NSDictionary *parameters = CONNECT_RequestTeamBalanceTransactions_Parameters([NSNumber numberWithInteger:teamId], [NSNumber numberWithInteger:playerId], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        NSMutableArray *transactionList = [NSMutableArray new];
        for (NSDictionary *transactionData in responseObject) {
            BalanceTransaction *transaction = [[BalanceTransaction alloc] initWithData:transactionData];
            [transactionList addObject:transaction];
        }
        [delegate receiveTeamBalanceTransactions:transactionList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Add Balance Transaction
- (void)addTransaction:(NSDictionary *)parameters {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_AddTransaction_Suffix];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        [delegate transactionAdded:![[responseObject objectForKey:@"error"] boolValue]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//Request TeamFunds
- (void)requestTeamFunds:(NSInteger)teamId forCaptain:(NSInteger)captainId startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    [busyIndicatorDelegate lockView];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestTeamFunds_Suffix];
    NSDictionary *parameters = CONNECT_RequestTeamFunds_Parameters([NSNumber numberWithInteger:teamId], [NSNumber numberWithInteger:captainId], [NSNumber numberWithInteger:startDate.timeIntervalSince1970], [NSNumber numberWithInteger:endDate.timeIntervalSince1970]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        NSMutableArray *teamFunds = [NSMutableArray new];
        for (NSDictionary *teamFundData in responseObject) {
            TeamFund *teamFund = [[TeamFund alloc] initWithData:teamFundData];
            [teamFunds addObject:teamFund];
        }
        [delegate receiveTeamFunds:teamFunds];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}
@end