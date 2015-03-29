//
//  Captain_CreateMatch_EnterScore.m
//  Football
//
//  Created by Andy Xu on 14-5-3.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch_EnterScore.h"

@implementation Captain_CreateMatch_EnterScoreTableView_Cell
@synthesize goalPlayerName, assistPlayerName;
@synthesize playersCandidateList;

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [goalPlayerName setTintColor:[UIColor clearColor]];
    [assistPlayerName setTintColor:[UIColor clearColor]];
}

#pragma playerPicker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return playersCandidateList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UserInfo *candidatePlayer = [playersCandidateList objectAtIndex:row];
    return candidatePlayer.nickName;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UserInfo *candidatePlayer = [playersCandidateList objectAtIndex:row];
    switch (component) {
        case 0:
            [goalPlayerName setText:candidatePlayer.nickName];
            break;
        case 1:
            [assistPlayerName setText:candidatePlayer.nickName];
            break;
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [goalPlayerName resignFirstResponder];
    [assistPlayerName resignFirstResponder];
}
@end

@implementation Captain_CreateMatch_EnterScore{
    HintTextView *hintView;
    UIPickerView *scorePicker;
    JSONConnect *connection;
    NSArray *playersCandidateList;
    UITextField *pickingPlayerTextField;
}
@synthesize delegate, summaryView, homeTeamLabel, awayTeamLabel, homeTeamScoreTextField, awayTeamScoreTextField, scoreDetailsTableView, matchScore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    hintView = [[HintTextView alloc] init];
    [self.view addSubview:hintView];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [hintView settingHintWithTextKey:@"EnterScore" underView:summaryView wantShow:YES];
    
    //Fill score if already have score
//    [homeTeamLabel setText:matchScore.home.teamName];
//    [awayTeamLabel setText:matchScore.awayTeamName];
//    [homeTeamScoreTextField setText:matchScore.homeScore.stringValue];
//    [awayTeamScoreTextField setText:matchScore.awayScore.stringValue];
    
    //Set tableview
    [scoreDetailsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    //Initial UIPicker for score
    scorePicker = [[UIPickerView alloc] init];
    [scorePicker setDataSource:self];
    [scorePicker setDelegate:self];
    [homeTeamScoreTextField setInputView:scorePicker];
    [awayTeamScoreTextField setInputView:scorePicker];
    [homeTeamScoreTextField setTintColor:[UIColor clearColor]];
    [awayTeamScoreTextField setTintColor:[UIColor clearColor]];
    
    //Initial playersCandidateList
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
//    [connection requestPlayersByTeamId:matchScore.home.teamId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receivePlayers:(NSArray *)players
{
    playersCandidateList = players;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.restorationIdentifier isEqualToString:@"GoalPlayerCandidate"] || [textField.restorationIdentifier isEqualToString:@"AssistPlayerCandidate"]) {
        pickingPlayerTextField = textField;
    }
    else {
        if (![homeTeamScoreTextField hasText]) {
            [homeTeamScoreTextField setText:[NSString stringWithFormat:@"%li", [scorePicker selectedRowInComponent:0]]];
        }
        if (![awayTeamScoreTextField hasText]) {
            [awayTeamScoreTextField setText:[NSString stringWithFormat:@"%li", [scorePicker selectedRowInComponent:1]]];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:homeTeamScoreTextField]) {
//        [matchScore setHomeScore:[NSNumber numberWithInteger:homeTeamScoreTextField.text.integerValue]];
    }
////    else if ([textField isEqual:awayTeamScoreTextField]) {
////        [matchScore setAwayScore:[NSNumber numberWithInteger:awayTeamScoreTextField.text.integerValue]];
////    }
    [scoreDetailsTableView reloadData];
}

#pragma scoreDetailTable
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
//    return matchScore.homeScore.integerValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MatchScoreCell";
    Captain_CreateMatch_EnterScoreTableView_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setPlayersCandidateList:playersCandidateList];
    UIPickerView *playerPicker = [[UIPickerView alloc] init];
    [playerPicker setDataSource:cell];
    [playerPicker setDelegate:cell];
    [cell.goalPlayerName setInputView:playerPicker];
    [cell.assistPlayerName setInputView:playerPicker];
    return cell;
}

-(IBAction)saveButtonOnClicked:(id)sender
{
//    matchScore.homeScore = [NSNumber numberWithInteger:homeTeamScoreTextField.text.integerValue];
//    matchScore.awayScore = [NSNumber numberWithInteger:awayTeamScoreTextField.text.integerValue];
//    NSMutableArray *goalPlayers = [[NSMutableArray alloc] init];
//    NSMutableArray *assistPlayers = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < matchScore.homeScore.integerValue; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        Captain_CreateMatch_EnterScoreTableView_Cell *cell = (Captain_CreateMatch_EnterScoreTableView_Cell *)[scoreDetailsTableView cellForRowAtIndexPath:indexPath];
//        for (UserInfo *player in playersCandidateList) {
////            NSLog(@"%@,%@,%@", player.name, cell.goalPlayerName.text, cell.assistPlayerName.text);
//            if ([player.nickName isEqualToString:cell.goalPlayerName.text]) {
//                [goalPlayers addObject:player];
//            }
//            if ([player.nickName isEqualToString:cell.assistPlayerName.text]) {
//                [assistPlayers addObject:player];
//            }
//        }
//    }
//    matchScore.goalPlayers = goalPlayers;
//    matchScore.assistPlayers = assistPlayers;
    
    [delegate receiveScore:matchScore];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [homeTeamScoreTextField resignFirstResponder];
    [awayTeamScoreTextField resignFirstResponder];
    [pickingPlayerTextField resignFirstResponder];
}

#pragma ScorePicker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 30;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%li", row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            [homeTeamScoreTextField setText:[NSString stringWithFormat:@"%li", row]];
            break;
        case 1:
            [awayTeamScoreTextField setText:[NSString stringWithFormat:@"%li", row]];
            break;
        default:
            break;
    }
}
@end
