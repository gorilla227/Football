//
//  UITextFieldForMatchDetailScore.m
//  Football
//
//  Created by Andy on 15/3/21.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "UITextFieldForMatchDetailScore.h"

@implementation UITextFieldForMatchDetailScore {
    MatchAttendancePickerView *matchAttendancePickerView;
    UILabel *goalPlayerLabel;
    UILabel *assistPlayerLabel;
    NSArray *matchAttendanceList;
    Match *matchData;
    MatchScore *matchScore;
}
@synthesize delegateForScoreDetail;

- (void)initialTextFieldForMatchDetailScore:(MatchScore *)score withMatchAttendance:(NSArray *)matchAttendance forMatch:(Match *)match {
    matchData = match;
    matchScore = score;
    if (!matchScore) {
        matchScore = (id)[NSNull null];
    }
    matchAttendanceList = matchAttendance;
    
    if (!matchAttendancePickerView) {
        matchAttendancePickerView = [MatchAttendancePickerView new];
        [matchAttendancePickerView setDelegate:self];
        [matchAttendancePickerView setDataSource:self];
        [self setInputView:matchAttendancePickerView];
        [self setTintColor:[UIColor clearColor]];
    }
    if (!goalPlayerLabel) {
        goalPlayerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height)];
        [goalPlayerLabel setTextAlignment:NSTextAlignmentCenter];
        [goalPlayerLabel setBackgroundColor:[UIColor whiteColor]];
        [self setLeftView:goalPlayerLabel];
    }
    if (!assistPlayerLabel) {
        assistPlayerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height)];
        [assistPlayerLabel setTextAlignment:NSTextAlignmentCenter];
        [assistPlayerLabel setBackgroundColor:[UIColor whiteColor]];
        [self setRightView:assistPlayerLabel];
    }
    
    //Initial Data
    if (![matchScore isEqual:[NSNull null]]) {
        [self setLeftViewMode:UITextFieldViewModeAlways];
        [self setRightViewMode:UITextFieldViewModeAlways];
        [self setPlaceholder:nil];
        
        if (matchScore.goalPlayerId == 0) {
            [goalPlayerLabel setText:[gUIStrings objectForKey:@"UI_MatchScoreDetails_OwnGoal"]];
            [assistPlayerLabel setText:[gUIStrings objectForKey:@"UI_MatchScoreDetails_None"]];
            [matchAttendancePickerView setGoalPlayerIndex:0];
            [matchAttendancePickerView setAssistPlayerIndex:0];
        }
        else {
            for (UserInfo *goalPlayer in matchAttendanceList) {
                if (goalPlayer.userId == matchScore.goalPlayerId) {
                    [goalPlayerLabel setText:goalPlayer.nickName];
                    [matchAttendancePickerView setGoalPlayerIndex:[matchAttendanceList indexOfObject:goalPlayer] + 1];
                    
                    if (matchScore.assistPlayerId == 0) {
                        [assistPlayerLabel setText:[gUIStrings objectForKey:@"UI_MatchScoreDetails_None"]];
                        [matchAttendancePickerView setAssistPlayerIndex:0];
                        break;
                    }
                    else {
                        NSMutableArray *assistAttendanceList = [NSMutableArray arrayWithArray:matchAttendanceList];
                        [assistAttendanceList removeObject:goalPlayer];
                        for (UserInfo *assistPlayer in assistAttendanceList) {
                            if (assistPlayer.userId == matchScore.assistPlayerId) {
                                [assistPlayerLabel setText:assistPlayer.nickName];
                                [matchAttendancePickerView setAssistPlayerIndex:[assistAttendanceList indexOfObject:assistPlayer] + 1];
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    else {
        [self setLeftViewMode:UITextFieldViewModeNever];
        [self setRightViewMode:UITextFieldViewModeNever];
        [self setPlaceholder:[gUIStrings objectForKey:@"UI_MatchScoreDetails_Placeholder"]];
    }
}

//UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return matchAttendanceList.count + 1;
        case 1:
            return ([pickerView selectedRowInComponent:0] == 0)?0:matchAttendanceList.count;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        if (row == 0) {
            return [gUIStrings objectForKey:@"UI_MatchScoreDetails_OwnGoal"];
        }
        else {
            UserInfo *player = [matchAttendanceList objectAtIndex:row - 1];
            return player.nickName;
        }
    }
    else {
        if (row == 0) {
            return [gUIStrings objectForKey:@"UI_MatchScoreDetails_None"];
        }
        else {
            NSMutableArray *assistList = [NSMutableArray arrayWithArray:matchAttendanceList];
            [assistList removeObject:[assistList objectAtIndex:[pickerView selectedRowInComponent:0] - 1]];
            UserInfo *player = [assistList objectAtIndex:row - 1];
            return player.nickName;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([matchScore isEqual:[NSNull null]]) {
        matchScore = [MatchScore new];
        if (matchData) {
            [matchScore setMatchId:matchData.matchId];
            [matchScore setTeamId:gMyUserInfo.team.teamId];
        }
    }
    if (component == 0) {
        if (row == 0) {
            [goalPlayerLabel setText:[gUIStrings objectForKey:@"UI_MatchScoreDetails_OwnGoal"]];
            [matchScore setGoalPlayerId:0];
        }
        else {
            UserInfo *player = [matchAttendanceList objectAtIndex:row - 1];
            [goalPlayerLabel setText:player.nickName];
            [matchScore setGoalPlayerId:player.userId];
        }
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [assistPlayerLabel setText:[gUIStrings objectForKey:@"UI_MatchScoreDetails_None"]];
        [matchScore setAssistPlayerId:0];
    }
    else {
        if (row == 0) {
            [assistPlayerLabel setText:[gUIStrings objectForKey:@"UI_MatchScoreDetails_None"]];
            [matchScore setAssistPlayerId:0];
        }
        else {
            NSMutableArray *assistList = [NSMutableArray arrayWithArray:matchAttendanceList];
            [assistList removeObject:[assistList objectAtIndex:[pickerView selectedRowInComponent:0] - 1]];
            UserInfo *player = [assistList objectAtIndex:row - 1];
            [assistPlayerLabel setText:player.nickName];
            [matchScore setAssistPlayerId:player.userId];
        }
    }
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self setPlaceholder:nil];
    if (delegateForScoreDetail) {
        [delegateForScoreDetail didScoreDetailChanged:matchScore forIndex:self.tag];
    }
}

@end

@implementation MatchAttendancePickerView
@synthesize goalPlayerIndex, assistPlayerIndex;

- (void)drawRect:(CGRect)rect {
    [self selectRow:goalPlayerIndex inComponent:0 animated:NO];
    [self reloadComponent:1];
    [self selectRow:assistPlayerIndex inComponent:1 animated:NO];
}

@end