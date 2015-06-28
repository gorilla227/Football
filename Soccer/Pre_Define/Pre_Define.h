//
//  Pre_Define.h
//  Soccer
//
//  Created by Andy on 14-4-15.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

//Keyboard Height
#define def_keyboardHeight 216

//Flexiblespace UIBarButtonItem
#define def_flexibleSpace [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

//Default playerPortrait and teamLogo
#define def_defaultPlayerPortrait [UIImage imageNamed:@"TeamIcon.jpg"]
#define def_defaultTeamLogo [UIImage imageNamed:@"TeamIcon.jpg"]

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
#define def_PlayerDetails_Section @[@"基础数据", @"比赛数据", @"队费数据"]
#define def_PlayerDetails @[@[@"出生年月", @"所在城市", @"活动区域", @"个人风格关键字"], @[@"入队时间", @"比赛出场", @"进球", @"助攻"], @[@"个人队费总额", @"上一次缴费日期", @"上一次缴费金额"]]
#define def_Message_Trail(nickName, myTeamName, matchDate, matchPlace, matchType) [NSString stringWithFormat:@"%@, %@通知您于%@，在%@，进行%@比赛试训。请准时到场，留下美好印象。", nickName, myTeamName, matchDate, matchPlace, matchType]
#define def_Message_Unpaid(teamFundAmount) [NSString stringWithFormat:@"亲，该交队费了！请于下场比赛交纳本期队费%@元。", teamFundAmount]
#define def_Message_UnpaidWithoutAmount @"亲，该交队费了！请于下场比赛交纳本期队费。"
#define def_EnterBalance_Placeholder_TeamFund @"请输入单人金额，总金额自动计算"
#define def_EnterBalance_Placeholder_Other @"请输入金额"
#define def_EnterBalance_Title_Date @"日期"
#define def_EnterBalance_Title_Name @"项目"
#define def_EnterBalance_Title_Amount @"金额"

//Color
#define def_textFieldLeftIconBackground [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define def_textFieldBorderColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
//#define def_navigationBar_background [UIColor colorWithRed: 59/255.0 green: 175/255.0 blue:218/255.0 alpha:1]
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

#define def_navigationBar_background cLightBlue(1)
#define cLightBlue(alphaValue) [UIColor colorWithRed:0/255.0 green:204/255.0 blue:255/255.0 alpha:alphaValue]
#define cRed(alphaValue) [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:alphaValue]
#define cGray(alphaValue) [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:alphaValue]
#define cLightGreen(alphaValue) [UIColor colorWithRed:153/255.0 green:204/255.0 blue:153/255.0 alpha:alphaValue]
#define cMatchCellBG [UIColor colorWithRed:79/255.0 green:193/255.0 blue:233/255.0 alpha:1]
#define cMatchCellNoticeButtonBG [UIColor colorWithRed:36/255.0 green:67/255.0 blue:87/255.0 alpha:1]
#define cMatchCellMatchTimeBG [UIColor colorWithRed:222/255.0 green:251/255.0 blue:255/255.0 alpha:1]
#define cMatchCellMatchTimeFont [UIColor colorWithRed:37/255.0 green:67/255.0 blue:87/255.0 alpha:1]
#define cBalanceTypeCredit [UIColor orangeColor]
#define cBalanceTypeDebit cLightBlue(1.0)
#define cDatePickerBG [UIColor colorWithRed:197.0/255.0 green:209.0/255.0 blue:202.0/255.0 alpha:1.0]

//NotifyPlayers_ViewTypes
enum NotifyPlayers_ViewTypes
{
    NotifyPlayers_MyTeamPlayers,
    NotifyPlayers_Trial,
    NotifyPlayers_Recruit,
    NotifyPlayers_TemporaryFavor,
    NotifyPlayers_UnpaidPlayers
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

//EditPlayerProfile & EditTeamProfile from Register or Main screen
enum EditProfileViewTypes
{
    EditProfileViewType_Default,
    EditProfileViewType_Register
};

//Dateformat
#define def_JSONDateformat @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
#define def_MatchDateformat @"yyyy-MM-dd"
#define def_MatchTimeformat @"HH:mm"
#define def_MatchDateAndTimeformat @"YYYY-MM-dd HH:mm"
#define def_MessageDateformat @"YYYY-MM-dd HH:mm:ss"

//Global variables
UserInfo *gMyUserInfo;
NSArray *gStadiums;
NSDictionary *gUIStrings;
NSMutableDictionary *gUnreadMessageAmount;
NSMutableDictionary *gSettings;
NSString *gSettingsFile;
CGSize windowSize;
UINavigationController *mainNavigationController;