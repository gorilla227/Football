//
//  CallFriendsMenu.m
//  Football
//
//  Created by Andy on 14-3-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "CallFriendsMenu.h"

@interface CallFriendsMenu ()

@end

@implementation CallFriendsMenu{
    id<DismissCallFriendsMenu>delegate;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonOnClicked:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    switch (senderButton.tag) {
        case 0:
            NSLog(@"微信");
            break;
        case 1:
            NSLog(@"QQ");
            break;
        case 2:
            NSLog(@"通讯录");
            break;
        default:
            break;
    }
    delegate = (id)self.parentViewController;
    [delegate dismissCallFriendsMenu];
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
