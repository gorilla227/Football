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
    }
    return self;
}

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
        [delegate receiveAllTemas:teams];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlertView:error];
    }];
}

-(void)showErrorAlertView:(NSError *)error
{
    UIAlertView *errorAlertViw = [[UIAlertView alloc] initWithTitle:@"杯具了" message:error.localizedDescription delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil];
    [errorAlertViw show];
}
@end