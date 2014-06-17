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
        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [manager.responseSerializer setAcceptableContentTypes:[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"]];
    }
    return self;
}

-(void)showErrorAlertView:(NSError *)error
{
    UIAlertView *errorAlertViw = [[UIAlertView alloc] initWithTitle:@"杯具了" message:error.localizedDescription delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil];
    [errorAlertViw show];
}

#pragma new Server
//LoginVerification
-(void)loginVerification:(NSString *)account password:(NSString *)password
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_Login_Suffix];
    NSDictionary *parameters = CONNECT_Login_Parameters(account, password.MD5);
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger userId = [[responseObject objectForKey:@"id"] integerValue];
        if (userId > 0) {
            [delegate loginVerificationSuccessfully:userId];
        }
        else {
            [delegate loginVerificationFailed];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error];
    }];
}

//GetUserInfo
-(void)requestUserInfo:(NSInteger)userId
{
    [manager.operationQueue cancelAllOperations];
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UserInfo_Suffix];
    NSDictionary *parameters = CONNECT_UserInfo_Parameters(1);
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            UserInfo *userInfo = [[UserInfo alloc] initWithData:responseObject];
            [delegate receiveUserInfo:userInfo];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error];
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
        [self showErrorAlertView:error];
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
        [self showErrorAlertView:error];
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
        [self showErrorAlertView:error];
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
        [self showErrorAlertView:error];
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
        [self showErrorAlertView:error];
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
        [self showErrorAlertView:error];
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
        [self showErrorAlertView:error];
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
        [self showErrorAlertView:error];
    }];
}

@end