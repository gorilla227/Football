//
//  LaunchScreen.m
//  Soccer
//
//  Created by Andy on 15/5/12.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "LaunchScreen.h"
@import CoreLocation;

@interface LaunchScreen ()
@property IBOutlet UIActivityIndicatorView *aiLoading;
@end

@implementation LaunchScreen {
    JSONConnect *connection;
    CLLocationManager *locationManager;
}
@synthesize aiLoading;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Get Settings
    NSArray *sandBoxPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    gSettingsFile = [[sandBoxPaths firstObject] stringByAppendingPathComponent:@"Setting.plist"];
    NSString *defaultSettingFile = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSDictionary *defaultSetting = [[NSDictionary alloc] initWithContentsOfFile:defaultSettingFile];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:gSettingsFile] || [[defaultSetting objectForKey:@"clearSettingWhileLaunch"] boolValue]) {
//        NSError *error;
//        [[NSFileManager defaultManager] copyItemAtPath:defaultSettingFile toPath:gSettingsFile error:&error];
        [defaultSetting writeToFile:gSettingsFile atomically:YES];
    }
    
    gSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:gSettingsFile];
    if (![[gSettings objectForKey:@"isDebug"] isEqualToNumber:[defaultSetting objectForKey:@"isDebug"]]) {
        [gSettings setObject:[defaultSetting objectForKey:@"isDebug"] forKey:@"isDebug"];
        [gSettings writeToFile:gSettingsFile atomically:YES];
    }
    
    //Get UIStrings
    NSString *fileNameOfUIStrings = [[NSBundle mainBundle] pathForResource:@"UIStrings" ofType:@"plist"];
    gUIStrings = [NSDictionary dictionaryWithContentsOfFile:fileNameOfUIStrings];
    
    //Initialize JSONConnect
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self];
    
    //Grant Location Authrization
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:(id)self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [connection requestAllStadiums];
}

- (void)enterMainScreen:(BOOL)isAutoLogin {
    UIViewController *starting = [self.storyboard instantiateViewControllerWithIdentifier:@"Starting"];
    UIStoryboard *captainStoryboard = [UIStoryboard storyboardWithName:@"Soccer" bundle:nil];
    UIViewController *mainController = [captainStoryboard instantiateInitialViewController];
    
    CATransition *transition = [CATransition animation];
    [transition setDuration:2.0f];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [transition setType:kCATransitionFade];
    [transition setDelegate:self];
    [transition setRemovedOnCompletion:YES];
    
    [self.view.window.layer addAnimation:transition forKey:@"Fade"];
    [self presentViewController:starting animated:NO completion:^{
        if (isAutoLogin) {
             [starting presentViewController:mainController animated:YES completion:nil];
        }
    }];
}

//JSONConnect
- (void)loginVerificationSuccessfully:(NSInteger)userId {
    [connection requestUserInfo:userId withTeam:YES withReference:nil];
}

- (void)loginVerificationFailed {
    UIAlertView *loginFailedAlertView = [[UIAlertView alloc] initWithTitle:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Title"]
                                                                   message:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Message"]
                                                                  delegate:self
                                                         cancelButtonTitle:[gUIStrings objectForKey:@"UI_LoginView_VerificationFailed_Cancel"] otherButtonTitles:nil];
    [loginFailedAlertView show];
}

- (void)receiveUserInfo:(UserInfo *)userInfo withReference:(id)reference {
    gMyUserInfo = userInfo;
    [self enterMainScreen:YES];
}

- (void)receiveAllStadiums:(NSArray *)stadiums {
    gStadiums = stadiums;
    
    if ([[gSettings objectForKey:@"isRememberAccount"] boolValue] && [gSettings objectForKey:@"accountName"] && [gSettings objectForKey:@"passwordMD5"]) {
        [connection loginVerification:[gSettings objectForKey:@"accountName"] password:[gSettings objectForKey:@"passwordMD5"]];
    }
    else {
        [self enterMainScreen:NO];
    }
}

//BusyIndicatorDelegate
- (void)lockView {
    [self.view.window setUserInteractionEnabled:NO];
    [aiLoading startAnimating];
}

- (void)unlockView {
    [self.view.window setUserInteractionEnabled:YES];
    [aiLoading stopAnimating];
}

//Location
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
    else if (status == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[gUIStrings objectForKey:@"UI_LocationDisableWarning_Title"] message:[gUIStrings objectForKey:@"UI_LocationDisableWarning_Message"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
        [alertView show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
