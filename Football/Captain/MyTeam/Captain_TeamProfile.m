//
//  Captain_TeamProfile.m
//  Football
//
//  Created by Andy on 14-4-6.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_TeamProfile.h"

@interface Captain_TeamProfile ()

@end

@implementation Captain_TeamProfile
@synthesize teamIcon, teamName, averageAge, activityRegion, pronouncement;
@synthesize qqTwoDimensionalCode, wechatTwoDimensionalCode;
@synthesize recruitSwitch, recruitComment;
@synthesize totalMatches, winMatchesAndRate, totalGoal, totalLost;

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
    //Set menu button
    [self.navigationItem setLeftBarButtonItem:self.navigationController.navigationBar.topItem.leftBarButtonItem];
    
//    [teamIcon setImage:[UIImage imageNamed:@"TeamIcon.jpg"]];
    [teamIcon.layer setBorderWidth:2.0f];
    [teamIcon.layer setBorderColor:[UIColor grayColor].CGColor];
    [teamIcon.layer setCornerRadius:teamIcon.bounds.size.width/2];
    [teamIcon.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
