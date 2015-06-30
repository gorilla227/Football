//
//  StadiumDetails.m
//  Soccer
//
//  Created by Andy Xu on 14-7-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "StadiumDetails.h"

@interface StadiumDetails ()
@property IBOutlet MKMapView *stadiumMap;
@property IBOutlet UILabel *stadiumNameLabel;
@property IBOutlet UILabel *stadiumAddressLabel;
@property IBOutlet UILabel *stadiumPhoneLabel;
@property IBOutlet UILabel *stadiumPriceLabel;
@property IBOutlet UILabel *stadiumCommentLabel;
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *homeStadiumSetButton;
@property IBOutlet UIBarButtonItem *contactStadiumButton;
@end

@implementation StadiumDetails{
    JSONConnect *connection;
}
@synthesize stadium, stadiumMap, stadiumNameLabel, stadiumAddressLabel, stadiumPhoneLabel, stadiumPriceLabel, stadiumCommentLabel, actionBar, homeStadiumSetButton, contactStadiumButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)bgImage];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setToolbarItems:actionBar.items];
    [self actionButtonInitialization];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [stadiumMap showAnnotations:@[stadium] animated:YES];
    [stadiumMap selectAnnotation:stadium animated:YES];
    [stadiumNameLabel setText:stadium.stadiumName];
    [stadiumAddressLabel setText:stadium.address];
    [stadiumPhoneLabel setText:stadium.phoneNumber];
    [stadiumPriceLabel setText:[NSString stringWithFormat:@"%li", (long)stadium.price]];
    [stadiumCommentLabel setText:stadium.comment];
    
    CGRect mapFrame = CGRectMake(0, 0, windowSize.width, self.tableView.bounds.size.height - self.tableView.contentSize.height - self.navigationController.navigationBar.bounds.size.height - self.navigationController.toolbar.bounds.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height);
    [stadiumMap setFrame:mapFrame];
    [self.tableView setTableHeaderView:stadiumMap];
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionButtonInitialization {
    if (gMyUserInfo.team) {
        if (gMyUserInfo.team.homeStadium.stadiumId == stadium.stadiumId) {
            [homeStadiumSetButton setEnabled:NO];
            [homeStadiumSetButton setTitle:[gUIStrings objectForKey:@"UI_HomeStadiumSetButtonOwnTitle"]];
        }
        else {
            [homeStadiumSetButton setEnabled:gMyUserInfo.userType];
            [homeStadiumSetButton setTitle:[gUIStrings objectForKey:@"UI_HomeStadiumSetButtonTitle"]];
        }
    }
    else {
        [homeStadiumSetButton setEnabled:NO];
        [homeStadiumSetButton setTitle:[gUIStrings objectForKey:@"UI_HomeStadiumSetButtonTitle"]];
    }
    
    [contactStadiumButton setEnabled:stadium.phoneNumber];
}

- (IBAction)contactStadiumButtonOnClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", stadium.phoneNumber]]];
}

- (IBAction)homeStadiumSetButtonOnClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[gUIStrings objectForKey:@"UI_HomeStadiumSetConfirmationMessage"]
                                                       delegate:self
                                              cancelButtonTitle:[gUIStrings objectForKey:@"UI_HomeStadiumSetCancel"]
                                              otherButtonTitles:[gUIStrings objectForKey:@"UI_HomeStadiumSetConfirm"], nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        Team *updateTeam = [gMyUserInfo.team copy];
        [updateTeam setHomeStadium:stadium];
        [connection updateTeamProfile:[updateTeam dictionaryForUpdate:gMyUserInfo.team withPlayer:gMyUserInfo.userId]];
    }
}

- (void)updateTeamProfileSuccessfully {
    [gMyUserInfo.team setHomeStadium:stadium];
    [self actionButtonInitialization];
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
