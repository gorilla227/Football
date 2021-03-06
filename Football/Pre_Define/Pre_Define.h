//
//  Pre_Define.h
//  Football
//
//  Created by Andy on 14-4-15.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

//Main Menu Frame
#define def_mainMenuFrame CGRectMake(-150, 64, 150, 504)

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

//Color
#define def_navigationBar_background [UIColor colorWithRed: 59/255.0 green: 175/255.0 blue:218/255.0 alpha:1]
#define def_backgroundColor_BeforeMatch [UIColor colorWithRed:78/255.0 green:191/255.0 blue:231/255.0 alpha:1]
#define def_backgroundColor_AfterMatch [UIColor colorWithRed:57/255.0 green:174/255.0 blue:218/255.0 alpha:1]
#define def_backgroundColor_FilledDetail [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1]
#define def_actionButtonColor_BeforeMatch [UIColor colorWithRed:57/255.0 green:174/255.0 blue:218/255.0 alpha:1]
#define def_actionButtonColor_AfterMatch [UIColor colorWithRed:78/255.0 green:191/255.0 blue:231/255.0 alpha:1]
#define def_actionButtonColor_FilledDetail [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1]

//Selected Opponent Type
enum SelectedOpponentType
{
    None,
    Existed,
    New
};

//Dateformat
#define def_JSONDateformat @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
#define def_MatchDateformat @"yyyy-MM-dd"
#define def_MatchTimeformat @"HH:mm"
#define def_MatchDateAndTimeformat @"YYYY-MM-dd HH:mm"

//Global variables
UserInfo *myUserInfo;