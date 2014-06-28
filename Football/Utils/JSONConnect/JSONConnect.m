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
@synthesize delegate;

-(id)initWithDelegate:(id)responser
{
    self = [super init];
    if (self) {
        [self setDelegate:responser];
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
    [delegate unlockView];
    [errorAlertView show];
}

#pragma new Server
//LoginVerification
-(void)loginVerification:(NSString *)account password:(NSString *)password
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_Login_Suffix];
    NSDictionary *parameters = CONNECT_Login_Parameters(account, password);
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate unlockView];
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
-(void)requestUserInfo:(NSInteger)userId
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UserInfo_Suffix];
    NSDictionary *parameters = CONNECT_UserInfo_Parameters(userId);
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate unlockView];
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
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RegisterCaptain_Suffix];
    NSDictionary *parameters = CONNECT_RegisterCaptain_Parameters(mobile, email, password, nickName, teamName);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate unlockView];
        NSInteger member_id = [[responseObject objectForKey:@"member_id"] integerValue];
        NSInteger team_id = [[responseObject objectForKey:@"team_id"] integerValue];
        [delegate registerCaptainSuccessfully:member_id teamId:team_id];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

-(void)registerPlayer:(NSString *)mobile email:(NSString *)email password:(NSString *)password nickName:(NSString *)nickName
{
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RegisterPlayer_Suffix];
    NSDictionary *parameters = CONNECT_RegisterPlayer_Parameters(mobile, email, password, nickName);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate unlockView];
        NSInteger playerId = [[responseObject objectForKey:@"id"] integerValue];
        [delegate registerPlayerSuccessfully:playerId];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//UpdatePlayerProfile
-(void)updatePlayerProfile:(NSDictionary *)playerProfile
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdatePlayerProfile_Suffix];
    [manager POST:urlString parameters:playerProfile success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate unlockView];
        [delegate updatePlayerProfileSuccessfully];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//UpdatePlayerPortrait
-(void)updatePlayerPortrait:(UIImage *)portrait forPlayer:(NSInteger)playerId
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdatePlayerPortrait_Suffix];
    NSDictionary *parameters = CONNECT_UpdatePlayerPortrait_Parameters(playerId);
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(portrait, 0.5) name:@"file" fileName:@"memberPortrait.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate unlockView];
        [delegate updatePlayerPortraitSuccessfully];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//UpdateTeamProfile
-(void)updateTeamProfile:(NSDictionary *)teamProfile
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdateTeamProfile_Suffix];
    [manager POST:urlString parameters:teamProfile success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate unlockView];
        [delegate updateTeamProfileSuccessfully];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error otherInfo:operation.responseString];
    }];
}

//UpdateTeamLogo
-(void)updateTeamLogo:(UIImage *)logo forTeam:(NSInteger)teamId
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UpdateTeamLogo_Suffix];
    NSDictionary *parameters = CONNECT_UpdateTeamLogo_Parameters(teamId);
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(logo, 0.5) name:@"file" fileName:@"teamLog.jpeg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate unlockView];
        [delegate updateTeamLogoSuccessfully];
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

-(void)requestAllStadiums
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_stadiums];

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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