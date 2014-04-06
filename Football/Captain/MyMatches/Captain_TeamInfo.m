//
//  Captain_TeamInfo.m
//  Football
//
//  Created by Andy on 14-3-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_TeamInfo.h"

@interface Captain_TeamInfo ()

@end

@implementation Captain_TeamInfo
@synthesize teamIcon;
@synthesize teamName;
@synthesize numberOfTeamMembers;

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
    //Set the default Team Icon
    UIImage *teamIconImage = [UIImage imageNamed:@"TeamIcon.jpg"];
    [teamIcon setImage:teamIconImage];
    [teamIcon.layer setBorderColor:[UIColor whiteColor].CGColor];
    [teamIcon.layer setBorderWidth:1.0f];
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
