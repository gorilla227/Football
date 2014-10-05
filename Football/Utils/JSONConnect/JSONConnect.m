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
                NSLog(@"%@", responseObject);
                [busyIndicatorDelegate unlockView];
                [delegate updateTeamProfileSuccessfully];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@, %@",operation.request, operation.responseString);
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
-(void)requestTeamMembers:(NSInteger)teamId isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_TeamMembers_Suffix];
    NSDictionary *parameters = CONNECT_TeamMembers_Parameters([NSNumber numberWithInteger:teamId]);
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

//RequestMessages
-(void)requestReceivedMessage:(NSInteger)receiverId messageTypes:(NSArray *)messageTypes status:(NSArray *)status startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestMessages_Suffix];
    NSDictionary *parameters = CONNECT_RequestMessages_ReceivedParameters([NSNumber numberWithInteger:receiverId], [messageTypes componentsJoinedByString:@","], [status componentsJoinedByString:@","], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
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

-(void)requestSentMessage:(NSInteger)senderId messageTypes:(NSArray *)messageTypes status:(NSArray *)status startIndex:(NSInteger)startIndex count:(NSInteger)count isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_RequestMessages_Suffix];
    NSDictionary *parameters = CONNECT_RequestMessages_SentParameters([NSNumber numberWithInteger:senderId], [messageTypes componentsJoinedByString:@","], [status componentsJoinedByString:@","], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:count]);
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

//RequestUnreadMessageAmount
-(void)requestUnreadMessageAmount:(NSInteger)receiverId messageTypes:(NSArray *)messageTypes
{
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_UnreadMessageAmount_Suffix];
    NSDictionary *parameters = CONNECT_UnreadMessageAmount_Parameters([messageTypes componentsJoinedByString:@","], [NSNumber numberWithInteger:receiverId]);
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        [delegate playerApplyinSent];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate playerApplyinFailed];
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
        [delegate teamCallinSent];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate teamCallinFailed];
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

//Request Matches
-(void)requestMatchesByTeamId:(NSInteger)teamId count:(NSInteger)count startIndex:(NSInteger)startIndex isSync:(BOOL)syncOption
{
    if (syncOption) {
        [busyIndicatorDelegate lockView];
    }
    NSString *urlString = [CONNECT_ServerURL stringByAppendingPathComponent:CONNECT_MatchList_Suffix];
    NSDictionary *paramters = CONNECT_MatchList_Parameters([NSNumber numberWithInteger:teamId]);
    [manager POST:urlString parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (syncOption) {
            [busyIndicatorDelegate unlockView];
        }
        NSLog(@"%@", responseObject);
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

#pragma zzOld_Server
//-(void)requestUserInfoById:(NSNumber *)userId
//{
//    [manager.operationQueue cancelAllOperations];
//    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_userById];
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:userId, JSON_parameter_userId, nil];
//    
//    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        UserInfo *userInfo = [[UserInfo alloc] initWithData:responseObject];
//        [delegate receiveUserInfo:userInfo withReference:nil];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
//    }];
//}
//
//-(void)requestMatchesByUserId:(NSNumber *)userId count:(NSInteger)count startIndex:(NSInteger)startIndex
//{
//    [manager.operationQueue cancelAllOperations];
//    NSString *urlString= [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_matchesByTeamIdOrUserId];
//    NSArray *parameterKeys = [[NSArray alloc] initWithObjects:JSON_parameter_matches_userId, JSON_parameter_common_count, JSON_parameter_common_startIndex, nil];
//    NSArray *parameterValues = [[NSArray alloc] initWithObjects:userId, [NSNumber numberWithInteger:count], [NSNumber numberWithInteger:startIndex], nil];
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:parameterValues forKeys:parameterKeys];
//    
//    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *originalMatches = responseObject;
//        NSMutableArray *matches = [[NSMutableArray alloc] init];
//        for (NSDictionary *singleMatch in originalMatches) {
//            Match *match = [[Match alloc] initWithData:singleMatch];
//            [matches addObject:match];
//        }
//        [delegate receiveMatches:matches];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
//    }];
//}
//
//-(void)requestMatchesByTeamId:(NSNumber *)teamId count:(NSInteger)count startIndex:(NSInteger)startIndex
//{
//    [manager.operationQueue cancelAllOperations];
//    NSString *urlString= [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_matchesByTeamIdOrUserId];
//    NSArray *parameterKeys = [[NSArray alloc] initWithObjects:JSON_parameter_matches_teamId, JSON_parameter_common_count, JSON_parameter_common_startIndex, nil];
//    NSArray *parameterValues = [[NSArray alloc] initWithObjects:teamId, [NSNumber numberWithInteger:count], [NSNumber numberWithInteger:startIndex], nil];
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:parameterValues forKeys:parameterKeys];
//    
//    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *originalMatches = responseObject;
//        NSMutableArray *matches = [[NSMutableArray alloc] init];
//        for (NSDictionary *singleMatch in originalMatches) {
//            Match *match = [[Match alloc] initWithData:singleMatch];
//            [matches addObject:match];
//        }
//        [delegate receiveMatches:matches];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
//    }];
//}
//
//-(void)requestAllTeamsWithCount:(NSInteger)count startIndex:(NSInteger)startIndex
//{
//    [manager.operationQueue cancelAllOperations];
//    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_allTeams];
//    NSArray *parameterKeys = [[NSArray alloc] initWithObjects:JSON_parameter_common_count, JSON_parameter_common_startIndex, nil];
//    NSArray *parameterValues = [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:count], [NSNumber numberWithInteger:startIndex], nil];
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:parameterValues forKeys:parameterKeys];
//    
//    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *originalTeams = responseObject;
//        NSMutableArray *teams = [[NSMutableArray alloc] init];
//        for (NSDictionary *singleTeam in originalTeams) {
//            Team *team = [[Team alloc] initWithData:singleTeam];
//            [teams addObject:team];
//        }
//        [delegate receiveTeams:teams];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
//    }];
//}
//
//-(void)requestStadiumsOfTeam:(NSNumber *)teamId
//{
//    [manager.operationQueue cancelAllOperations];
//    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_stadiums];
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:teamId, JSON_parameter_stadiums_teamId, nil];
//    
//    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *originalStadiums = responseObject;
//        NSMutableArray *stadiums = [[NSMutableArray alloc] init];
//        for (NSDictionary *singleStadium in originalStadiums) {
//            Stadium *stadium = [[Stadium alloc] initWithData:singleStadium];
//            if (![stadium.stadiumName isEqual:[NSNull null]]) {
//                [stadiums addObject:stadium];
//            }
//        }
//        [delegate receiveStadiums:stadiums];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
//    }];
//}
//
//-(void)requestStadiumById:(NSNumber *)stadiumId
//{
//    [manager.operationQueue cancelAllOperations];
//    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_stadiumById];
//    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:stadiumId, JSON_parameter_stadiumId, nil];
//    
//    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        Stadium *stadium = [[Stadium alloc] initWithData:responseObject];
//        if ([stadium.stadiumName isEqual:[NSNull null]]) {
//            [delegate receiveStadiums:nil];
//        }
//        else {
//            [delegate receiveStadiums:@[stadium]];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
//    }];
//}
//
//-(void)requestPlayersByTeamId:(NSNumber *)teamId
//{
//    //Fake code to request all users
//    [manager.operationQueue cancelAllOperations];
//    NSString *urlString = [JSON_serverURL stringByAppendingPathComponent:JSON_suffix_allUsers];
//    
//    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *originalPlayers = responseObject;
//        NSMutableArray *players = [[NSMutableArray alloc] init];
//        for (NSDictionary *singlePlayer in originalPlayers) {
//            UserInfo *player = [[UserInfo alloc] initWithData:singlePlayer];
//            [players addObject:player];
//        }
//        [delegate receivePlayers:players];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self showErrorAlertView:error otherInfo:operation.responseString];
//    }];
//}

@end