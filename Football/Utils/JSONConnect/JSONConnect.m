//
//  JSONConnect.m
//  Football
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
            errorAlertView = [[UIAlertView alloc] initWithTitle:@"杯具了" message:@"未知错误" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil];
        }
    }
    else {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"杯具了" message:@"未知错误" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil];
    }
    [busyIndicatorDelegate unlockView];
    [errorAlertView show];
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
-(void)requestUserInfo:(NSInteger)userId withTeam:(BOOL)withTeam
{
    [busyIndicatorDelegate lockView];
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UserInfo_Suffix];
    NSDictionary *parameters = CONNECT_UserInfo_Parameters(userId, withTeam?1:0);
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [busyIndicatorDelegate unlockView];
        if (responseObject) {
            UserInfo *userInfo = [[UserInfo alloc] initWithData:responseObject];
            [delegate receiveUserInfo:userInfo];
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
        [delegate receiveAllStadiums:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

#pragma zzOld_Server
-(void)requestUserInfoById:(NSNumber *)userId
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_userById];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:userId, JSON_parameter_userId, nil];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UserInfo *userInfo = [[UserInfo alloc] initWithData:responseObject];
        [delegate receiveUserInfo:userInfo];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)requestMatchesByUserId:(NSNumber *)userId count:(NSInteger)count startIndex:(NSInteger)startIndex
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString= [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_matchesByTeamIdOrUserId];
    NSArray *parameterKeys = [[NSArray alloc] initWithObjects:JSON_parameter_matches_userId, JSON_parameter_common_count, JSON_parameter_common_startIndex, nil];
    NSArray *parameterValues = [[NSArray alloc] initWithObjects:userId, [NSNumber numberWithInteger:count], [NSNumber numberWithInteger:startIndex], nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:parameterValues forKeys:parameterKeys];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *originalMatches = responseObject;
        NSMutableArray *matches = [[NSMutableArray alloc] init];
        for (NSDictionary *singleMatch in originalMatches) {
            Match *match = [[Match alloc] initWithData:singleMatch];
            [matches addObject:match];
        }
        [delegate receiveMatches:matches];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)requestMatchesByTeamId:(NSNumber *)teamId count:(NSInteger)count startIndex:(NSInteger)startIndex
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString= [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_matchesByTeamIdOrUserId];
    NSArray *parameterKeys = [[NSArray alloc] initWithObjects:JSON_parameter_matches_teamId, JSON_parameter_common_count, JSON_parameter_common_startIndex, nil];
    NSArray *parameterValues = [[NSArray alloc] initWithObjects:teamId, [NSNumber numberWithInteger:count], [NSNumber numberWithInteger:startIndex], nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:parameterValues forKeys:parameterKeys];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *originalMatches = responseObject;
        NSMutableArray *matches = [[NSMutableArray alloc] init];
        for (NSDictionary *singleMatch in originalMatches) {
            Match *match = [[Match alloc] initWithData:singleMatch];
            [matches addObject:match];
        }
        [delegate receiveMatches:matches];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)requestAllTeamsWithCount:(NSInteger)count startIndex:(NSInteger)startIndex
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_allTeams];
    NSArray *parameterKeys = [[NSArray alloc] initWithObjects:JSON_parameter_common_count, JSON_parameter_common_startIndex, nil];
    NSArray *parameterValues = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:count], [NSNumber numberWithInteger:startIndex], nil];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:parameterValues forKeys:parameterKeys];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *originalTeams = responseObject;
        NSMutableArray *teams = [[NSMutableArray alloc] init];
        for (NSDictionary *singleTeam in originalTeams) {
            Team *team = [[Team alloc] initWithData:singleTeam];
            [teams addObject:team];
        }
        [delegate receiveTeams:teams];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)requestStadiumsOfTeam:(NSNumber *)teamId
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_stadiums];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:teamId, JSON_parameter_stadiums_teamId, nil];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *originalStadiums = responseObject;
        NSMutableArray *stadiums = [[NSMutableArray alloc] init];
        for (NSDictionary *singleStadium in originalStadiums) {
            Stadium *stadium = [[Stadium alloc] initWithData:singleStadium];
            if (![stadium.stadiumName isEqual:[NSNull null]]) {
                [stadiums addObject:stadium];
            }
        }
        [delegate receiveStadiums:stadiums];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)requestStadiumById:(NSNumber *)stadiumId
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_stadiumById];
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:stadiumId, JSON_parameter_stadiumId, nil];
    
    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Stadium *stadium = [[Stadium alloc] initWithData:responseObject];
        if ([stadium.stadiumName isEqual:[NSNull null]]) {
            [delegate receiveStadiums:nil];
        }
        else {
            [delegate receiveStadiums:@[stadium]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)requestPlayersByTeamId:(NSNumber *)teamId
{
    //Fake code to request all users
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_allUsers];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *originalPlayers = responseObject;
        NSMutableArray *players = [[NSMutableArray alloc] init];
        for (NSDictionary *singlePlayer in originalPlayers) {
            UserInfo *player = [[UserInfo alloc] initWithData:singlePlayer];
            [players addObject:player];
        }
        [delegate receivePlayers:players];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

@end