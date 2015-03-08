//
//  Soccer_BaseNavigationController.m
//  Football
//
//  Created by Andy on 14-4-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Soccer_BaseNavigationController.h"

@interface Soccer_BaseNavigationController ()
@property IBOutlet UIBarButtonItem *menuButton;
@property IBOutlet MessageBarButtonItem *messageButton;
@end

@implementation Soccer_BaseNavigationController{
    MainMenu *mainMenu;
    UIActivityIndicatorView *busyIndicator;
    JSONConnect *connection;
    NSArray *unreadMessageTypes;
    BOOL isMenuShow;
}
@synthesize menuButton, messageButton;

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
    //Set the background image
    UIImage *backgroundImage = [UIImage imageNamed:@"soccer_grass_bg@2x.png"];
    [self.view.layer setContents:(id)backgroundImage.CGImage];

    mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"Captain_MainMenu"];
    [mainMenu setDelegateOfMenuAppearance:self];
    [mainMenu setDelegateOfViewSwitch:self];
    [self.view addSubview:mainMenu.view];
    
    //Set Menu button and Message button;
    [messageButton setDelegate:self];
    [messageButton initBadgeView];
    
    //Set busyIndicator
    busyIndicator = [[UIActivityIndicatorView alloc] init];
    [busyIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [busyIndicator setColor:[UIColor blackColor]];
    [busyIndicator setCenter:self.view.center];
    [busyIndicator setHidesWhenStopped:YES];
    [self.view addSubview:busyIndicator];
    
    //Load the initial view
    [mainMenu initialFirtSelection:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    //Set JSONConnect for request unread message amount repeatly.
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self];
    unreadMessageTypes = [NSArray new];

    NSArray *messageTypes;
    if (gMyUserInfo.userType) {
        messageTypes = [[[gUIStrings objectForKey:@"UI_MessageTypes_ForCaptain"] firstObject] objectForKey:@"TypeGroups"];
    }
    else if (gMyUserInfo.team) {
        messageTypes = [[[gUIStrings objectForKey:@"UI_MessageTypes_ForPlayerWithTeam"] firstObject] objectForKey:@"TypeGroups"];
    }
    else {
        messageTypes = [[[gUIStrings objectForKey:@"UI_MessageTypes_ForPlayerWithoutTeam"] firstObject] objectForKey:@"TypeGroups"];
    }
    for (NSDictionary *messageTypeGroup in messageTypes) {
        unreadMessageTypes = [unreadMessageTypes arrayByAddingObjectsFromArray:[messageTypeGroup objectForKey:@"Types"]];
    }
    
    [self refreshUnreadMessageAmount];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:[[gSettings objectForKey:@"refreshUnreadMessageAmountDuration"] integerValue] target:self selector:@selector(refreshUnreadMessageAmount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)refreshUnreadMessageAmount
{
    [connection requestUnreadMessageAmount:gMyUserInfo messageTypes:unreadMessageTypes];
}

-(void)receiveUnreadMessageAmount:(NSDictionary *)unreadMessageAmount
{
    if (gUnreadMessageAmount) {
        for (NSString *key in unreadMessageAmount.allKeys) {
            [gUnreadMessageAmount setObject:[unreadMessageAmount objectForKey:key] forKey:key];
        }
    }
    else {
        gUnreadMessageAmount = [NSMutableDictionary dictionaryWithDictionary:unreadMessageAmount];
    }
    [messageButton setBadgeNumber:[[gUnreadMessageAmount.allValues valueForKeyPath:@"@sum.self"] integerValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageStatusUpdated" object:nil];
}

-(void)logout
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)menuSwitch
{
    [UIView beginAnimations:@"ShowMenu" context:nil];
    [UIView setAnimationDuration:0.3f];
    CGAffineTransform tShowMenu = CGAffineTransformMakeTranslation(mainMenu.view.bounds.size.width, 0);
    if (isMenuShow) {
        //Hide menu
        for (UIView *view in self.visibleViewController.view.subviews) {
            [view setTransform:CGAffineTransformConcat(view.transform, CGAffineTransformInvert(tShowMenu))];
        }
        [self.toolbar setTransform:CGAffineTransformConcat(self.toolbar.transform, CGAffineTransformInvert(tShowMenu))];
        [self.toolbar setUserInteractionEnabled:YES];
        [self.visibleViewController.view setUserInteractionEnabled:YES];
        [mainMenu.view setTransform:CGAffineTransformConcat(mainMenu.view.transform, CGAffineTransformInvert(tShowMenu))];
        [mainMenu.view setUserInteractionEnabled:NO];
        isMenuShow = NO;
    }
    else {
        //Show menu
        for (UIView * view in self.visibleViewController.view.subviews) {
            [view setTransform:CGAffineTransformConcat(view.transform, tShowMenu)];
        }
        [self.toolbar setTransform:CGAffineTransformConcat(self.toolbar.transform, tShowMenu)];
        [self.toolbar setUserInteractionEnabled:NO];
        [self.visibleViewController.view setUserInteractionEnabled:NO];
        [mainMenu.view setTransform:CGAffineTransformConcat(mainMenu.view.transform, tShowMenu)];
        [mainMenu.view setUserInteractionEnabled:YES];
        [mainMenu resetMenuFolder];
        isMenuShow = YES;
    }
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (isMenuShow) {
        [self menuSwitch];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchSelectMenuView:(NSString *)selectedView
{
    if(![self.visibleViewController.restorationIdentifier isEqualToString:selectedView]) {
        UIViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:selectedView];
        [targetViewController.navigationItem setLeftBarButtonItem:menuButton];
        [targetViewController.navigationItem setRightBarButtonItem:messageButton];
        [self setViewControllers:@[targetViewController] animated:YES];
    }
}

-(IBAction)menuButtonOnClicked:(id)sender
{
    [self menuSwitch];
}

-(void)messageButtonOnClicked
{
    UIViewController *messageCenter = [[UIStoryboard storyboardWithName:@"MessageCenter" bundle:nil] instantiateInitialViewController];
    if (isMenuShow) {
        [self menuSwitch];
    }
    [self pushViewController:messageCenter animated:YES];
}

//BusyIndicatorDelegate
-(void)lockView
{
    [self.view.window setUserInteractionEnabled:NO];
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
