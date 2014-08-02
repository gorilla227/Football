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
@synthesize teamLogo, teamName, averageAge, activityRegion, pronouncement;
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
//    [teamLogo setImage:[UIImage imageNamed:@"teamLogo.jpg"]];
    [teamLogo.layer setBorderWidth:2.0f];
    [teamLogo.layer setBorderColor:[UIColor grayColor].CGColor];
    [teamLogo.layer setCornerRadius:teamLogo.bounds.size.width/2];
    [teamLogo.layer setMasksToBounds:YES];
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
