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
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    [swAutoLogin setOn:[[gSettings objectForKey:@"isRememberAccount"] boolValue]];
    [lbVersion setText:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)swAutoLoginValueChanged:(id)sender {
    NSArray *sandBoxPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *settingFile = [[sandBoxPaths firstObject] stringByAppendingPathComponent:@"Setting.plist"];
    
    [gSettings setObject:[NSNumber numberWithBool:swAutoLogin.isOn] forKey:@"isRememberAccount"];
    [gSettings writeToFile:settingFile atomically:YES];
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
