//
//  Starting.m
//  Football
//
//  Created by Andy Xu on 14-6-9.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Starting.h"

@interface Starting ()

@end

@implementation Starting{
    UIActivityIndicatorView *busyIndicator;
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
    UIImage *backgroundImage = [UIImage imageNamed:@"soccer_grass_bg@2x.png"];
    [self.view.layer setContents:(id)backgroundImage.CGImage];
    
    //Get UIStrings
    NSString *fileNameOfUIStrings = [[NSBundle mainBundle] pathForResource:@"UIStrings" ofType:@"plist"];
    gUIStrings = [NSDictionary dictionaryWithContentsOfFile:fileNameOfUIStrings];
    
    //Set busyIndicator
    busyIndicator = [[UIActivityIndicatorView alloc] init];
    [busyIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [busyIndicator setColor:[UIColor blackColor]];
    [busyIndicator setCenter:self.view.center];
    [busyIndicator setHidesWhenStopped:YES];
    [self.view addSubview:busyIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//BusyIndicatorDelegate
-(void)lockView
{
    [self.view.window setUserInteractionEnabled:NO];
//    [self.view bringSubviewToFront:busyIndicator];
    [busyIndicator startAnimating];
}

-(void)unlockView
{
    [self.view.window setUserInteractionEnabled:YES];
    [busyIndicator stopAnimating];
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
