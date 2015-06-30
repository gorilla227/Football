//
//  Settings.m
//  Soccer
//
//  Created by Andy on 15/5/10.
//  Copyright (c) 2015年 Xinyi Xu. All rights reserved.
//

#import "Settings.h"

@interface Settings ()
@property IBOutlet UISwitch *swAutoLogin;
@property IBOutlet UILabel *lbVersion;
@end

@implementation Settings
@synthesize swAutoLogin, lbVersion;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)bgImage];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    [swAutoLogin setOn:[[gSettings objectForKey:@"isRememberAccount"] boolValue]];
    [lbVersion setText:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swAutoLoginValueChanged:(id)sender {
    [gSettings setObject:[NSNumber numberWithBool:swAutoLogin.isOn] forKey:@"isRememberAccount"];
    if (!swAutoLogin.isOn) {
        [gSettings removeObjectForKey:@"accountName"];
        [gSettings removeObjectForKey:@"passwordMD5"];
    }
    [gSettings writeToFile:gSettingsFile atomically:YES];
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
