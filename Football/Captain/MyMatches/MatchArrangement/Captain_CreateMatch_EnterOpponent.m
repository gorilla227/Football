//
//  Captain_CreateMatch_EnterOpponent.m
//  Football
//
//  Created by Andy on 14-4-21.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_CreateMatch_EnterOpponent.h"

@interface Captain_CreateMatch_EnterOpponent ()

@end

@implementation Captain_CreateMatch_EnterOpponent{
    HintTextView *hintView;
    NSArray *inviteOpponentMenuList;
}
@synthesize matchStarted, delegate, selectedTeamName;
@synthesize inviteOpponentButton, teamMarketButton, toolBar, matchOpponent, saveButton;

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    hintView = [[HintTextView alloc] init];
    [self.view addSubview:hintView];
    [matchOpponent setText:selectedTeamName];
    [saveButton setEnabled:[matchOpponent hasText]];
    
    if (matchStarted) {
        //Match started
        [toolBar setItems:@[def_flexibleSpace, inviteOpponentButton, def_flexibleSpace]];
        
        //Show hint
        [hintView settingHintWithTextKey:@"EnterOpponent_MatchStarted" underView:matchOpponent wantShow:YES];
    }
    else {
        //Match not started
        if (selectedTeamName.length != 0) {
            //Opponent Team is not in system
            [toolBar setItems:@[def_flexibleSpace, inviteOpponentButton, def_flexibleSpace]];

            //Show hint
            [hintView settingHintWithTextKey:@"EnterOpponent_MatchStarted" underView:matchOpponent wantShow:YES];
        }
        else {
            //No opponent selected
            [toolBar setItems:@[def_flexibleSpace, inviteOpponentButton, def_flexibleSpace, def_flexibleSpace, teamMarketButton, def_flexibleSpace]];

            //Show hint
            [hintView settingHintWithTextKey:@"EnterOpponent_MatchNotStarted_Subpage" underView:matchOpponent wantShow:YES];
        }
    }
    
    //Initial inviteOpponentMenuList
    NSString *menuListFile = [[NSBundle mainBundle] pathForResource:@"ActionSheetMenu" ofType:@"plist"];
    inviteOpponentMenuList = [[[NSDictionary alloc] initWithContentsOfFile:menuListFile] objectForKey:@"InviteOpponentMenu"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)opponentValueChanged:(id)sender
{
    [saveButton setEnabled:[matchOpponent hasText]];
}
-(IBAction)saveOpponent:(id)sender
{
    [delegate receiveNewOpponent:matchOpponent.text];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [matchOpponent resignFirstResponder];
}

-(IBAction)inviteOpponentButtonOnClicked:(id)sender
{
    UIActionSheet *inviteActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSDictionary *menuItem in inviteOpponentMenuList) {
        [inviteActionSheet addButtonWithTitle:[menuItem objectForKey:@"Title"]];
        [[inviteActionSheet.subviews lastObject] setImage:[UIImage imageNamed:[menuItem objectForKey:@"Icon"]] forState:UIControlStateNormal];
    }
    [inviteActionSheet setCancelButtonIndex:[inviteActionSheet addButtonWithTitle:@"取消"]];
    
    [inviteActionSheet showFromBarButtonItem:inviteOpponentButton animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < inviteOpponentMenuList.count) {
        NSLog(@"%@", [[inviteOpponentMenuList objectAtIndex:buttonIndex] objectForKey:@"Title"]);
    }
    else {
        NSLog(@"取消");
    }
}

#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"TeamMarket"]) {
        Captain_CreateMatch_TeamMarket *teamMarket = segue.destinationViewController;
        [teamMarket setDelegate:(id)delegate];
    }
}


@end
