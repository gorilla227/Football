//
//  Pre_Define.h
//  Football
//
//  Created by Andy on 14-4-15.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

//Main Menu Frame
#define def_mainMenuFrame CGRectMake(-150, 64, 150, 504)

//Flexiblespace UIBarButtonItem
#define def_flexibleSpace [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

//UI Strings
#define def_typeOfPlayerNumber_SignUp @"报名人数"
#define def_typeOfPlayerNumber_ShowUp @"出场人数"
#define def_createMatch_time @"时间"
#define def_createMatch_opponent @"对手"
#define def_createMatch_place @"场地"
#define def_createMatch_numOfPlayers @"人数"
#define def_createMatch_cost @"费用"
#define def_createMatch_costOption1 @"裁判"
#define def_createMatch_costOption2 @"水"
#define def_createMatch_score @"比分"
#define def_createMatch_cost_ph_self @"输入该场比赛我队承担的费用"
#define def_createMatch_cost_ph_opponent @"输入该场比赛对手承担的费用"
#define def_createMatch_actionButton_started @"保存比赛数据"
#define def_createMatch_actionButton_new @"确定建立"
#define def_createMatch_actionButton_existed @"发送约赛请求"
#define def_MA_actionButton_announce @"通知队员"
#define def_MA_actionButton_record @"数据记录"
#define def_MA_actionButton_detail @"详细"
#define def_WM_statusText_beInvited(teamName) [NSString stringWithFormat:@"%@邀请我队比赛", teamName]
#define def_WM_statusText_beInvited_cancelled(teamName) [NSString stringWithFormat:@"%@已经和其他球队约赛", teamName]
#define def_WM_statusText_myInvitationAccepted(teamName) [NSString stringWithFormat:@"%@已同意约球，请通知小伙伴", teamName]
#define def_WM_statusText_myInvitationRejected(teamName) [NSString stringWithFormat:@"%@已拒绝约球", teamName]
#define def_WM_acceptInvitationText(teamName) [NSString stringWithFormat:@"已同意%@队约赛请求，请在“比赛安排”中查看具体信息和通知队员，比赛开始前48小时之内不得取消比赛", teamName]
#define def_WM_rejectInvitationText(teamName) [NSString stringWithFormat:@"已拒绝%@队约赛请求", teamName]
#define def_WM_myInvitationAcceptedText(teamName) [NSString stringWithFormat:@"%@已同意约球，请通知小伙伴", teamName]
#define def_PlayerDetails @[@[@"出生年月", @"所在城市", @"活动区域", @"个人风格关键字"], @[@"入队时间", @"比赛出场", @"进球", @"助攻"]]
#define def_Message_Trail(nickName, myTeamName, matchDate, matchPlace, matchType) [NSString stringWithFormat:@"%@, %@通知您于%@，在%@，进行%@比赛试训。请准时到场，留下美好印象。", nickName, myTeamName, matchDate, matchPlace, matchType] 
#define def_EnterBalance_Placeholder_TeamFund @"请输入单人金额，总金额自动计算"
#define def_EnterBalance_Placeholder_Other @"请输入金额"
#define def_EnterBalance_Title_Date @"日期"
#define def_EnterBalance_Title_Name @"项目"
#define def_EnterBalance_Title_Amount @"金额"

//Color
#define def_navigationBar_background [UIColor colorWithRed: 59/255.0 green: 175/255.0 blue:218/255.0 alpha:1]
#define def_toolBar_background [UIColor colorWithRed: 226/255.0 green: 230/255.0 blue:232/255.0 alpha:1]
#define def_backgroundColor_BeforeMatch [UIColor colorWithRed:78/255.0 green:191/255.0 blue:231/255.0 alpha:1]
#define def_backgroundColor_AfterMatch [UIColor colorWithRed:57/255.0 green:174/255.0 blue:218/255.0 alpha:1]
#define def_backgroundColor_FilledDetail [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1]
#define def_actionButtonColor_BeforeMatch [UIColor colorWithRed:57/255.0 green:174/255.0 blue:218/255.0 alpha:1]
#define def_actionButtonColor_AfterMatch [UIColor colorWithRed:78/255.0 green:191/255.0 blue:231/255.0 alpha:1]
#define def_actionButtonColor_FilledDetail [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1]
#define def_warmUpMatch_statusBarBG_Enable [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1]
#define def_warmUpMatch_statusBarBG_Disable [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1]
#define def_warmUpMatch_announcementBarBG [UIColor colorWithRed:79/255.0 green:192/255.0 blue:232/255.0 alpha:1]
#define def_warmUpMatch_actionButtonBG_Enable [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1]
#define def_warmUpMatch_actionButtonBG_Disable [UIColor colorWithRed:189/255.0 green:192/255.0 blue:197/255.0 alpha:1]

//PlayerDetails_ViewTypes
enum PlayerDetails_ViewTypes
{
    PlayerDetails_MyPlayer,
    PlayerDetails_Applicant,
    PlayerDetails_FromPlayerMarket
};

//NotifyPlayers_ViewTypes
enum NotifyPlayers_ViewTypes
{
    NotifyPlayers_MyTeamPlayers,
    NotifyPlayers_Trial,
    NotifyPlayers_Recruit,
    NotifyPlayers_TemporaryFavor
};

//EnterBalance_ViewTypes
enum EnterBalance_ViewTypes
{
    EnterBalance_Add,
    EnterBalance_Edit
};

//BalanceTypes
enum BalanceTypes
{
    BalanceType_TeamFund,
    BalanceType_OtherIncome,
    BalanceType_Expenditure
};

//Dateformat
#define def_JSONDateformat @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
#define def_MatchDateformat @"yyyy.MM.dd"
#define def_MatchTimeformat @"HH:mm"
#define def_MatchDateAndTimeformat @"YYYY-MM-dd HH:mm"

//Global variables
UserInfo *myUserInfo;