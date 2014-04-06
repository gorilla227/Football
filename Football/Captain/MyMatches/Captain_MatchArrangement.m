//
//  Captain_MatchArrangement.m
//  Football
//
//  Created by Andy on 14-3-31.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_MatchArrangement.h"

@interface Captain_MatchArrangement ()

@end

@implementation Captain_MatchArrangement{
    Captain_TeamInfo *teamInfo;
}
@synthesize teamInfoView;
@synthesize matchesView;
@synthesize otherInfoView;

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
    for (UIViewController *viewController in self.childViewControllers) {
        if ([viewController.restorationIdentifier isEqualToString: @"TeamInfo"]) {
            teamInfo = (Captain_TeamInfo *)viewController;
        }
    }
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
