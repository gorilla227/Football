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

@implementation Captain_CreateMatch_EnterOpponent
@synthesize matchStarted, delegate;
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
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    if (matchStarted) {
        //Match started
        [toolBar setItems:@[flexibleSpace, inviteOpponentButton, flexibleSpace]];
    }
    else {
        //Match not started
        [toolBar setItems:@[flexibleSpace, inviteOpponentButton, flexibleSpace, flexibleSpace, teamMarketButton, flexibleSpace]];
    }
//    [matchOpponent addTarget:self action:@selector(test) forControlEvents:UIControlEventValueChanged];
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
    [delegate receiveOpponent:matchOpponent.text];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [matchOpponent resignFirstResponder];
}
/*
#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
