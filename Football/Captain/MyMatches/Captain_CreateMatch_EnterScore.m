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
@end

@implementation Captain_CreateMatch_EnterScore{
    HintTextView *hintView;
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
    [homeTeamLabel setText:matchScore.home.teamName];
    [awayTeamLabel setText:matchScore.awayTeamName];
    [homeTeamScoreTextField setText:matchScore.homeScore.stringValue];
    [awayTeamScoreTextField setText:matchScore.awayScore.stringValue];
    
    //Set tableview
    [scoreDetailsTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:homeTeamScoreTextField]) {
        [matchScore setHomeScore:[NSNumber numberWithInteger:homeTeamScoreTextField.text.integerValue]];
        [scoreDetailsTableView reloadData];
    }
    else if ([textField isEqual:awayTeamScoreTextField]) {
        [matchScore setAwayScore:[NSNumber numberWithInteger:awayTeamScoreTextField.text.integerValue]];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return matchScore.homeScore.integerValue;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MatchScoreCell";
    Captain_CreateMatch_EnterScoreTableView_Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

-(IBAction)saveButtonOnClicked:(id)sender
{
    [delegate receiveScore:matchScore];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [homeTeamScoreTextField resignFirstResponder];
    [awayTeamScoreTextField resignFirstResponder];
}
@end
