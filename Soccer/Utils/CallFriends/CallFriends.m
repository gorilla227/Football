//
//  CallFriends.m
//  Soccer
//
//  Created by Andy on 14-5-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "CallFriends.h"

@implementation CallFriends{
    NSArray *callFriendsMenuList;
    UIViewController *presentingViewController;
}

- (id)initWithPresentingViewController:(UIViewController *)viewController {
    self = [super initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if (self) {
        presentingViewController = viewController;
        NSString *callFriendsMenuListFile = [[NSBundle mainBundle] pathForResource:@"ActionSheetMenu" ofType:@"plist"];
        callFriendsMenuList = [[[NSDictionary alloc] initWithContentsOfFile:callFriendsMenuListFile] objectForKey:@"CallFriendsMenu"];
        
        for (NSDictionary *menuItem in callFriendsMenuList) {
            [self addButtonWithTitle:[menuItem objectForKey:@"Title"]];
            [[self.subviews lastObject] setImage:[UIImage imageNamed:[menuItem objectForKey:@"Icon"]] forState:UIControlStateNormal];
        }
        [self setCancelButtonIndex:[self addButtonWithTitle:[gUIStrings objectForKey:@"UI_CallFriends_Cancel"]]];
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        //MFMessage
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            NSString *messageTemplateFile = [[NSBundle mainBundle] pathForResource:@"MessageTemplate" ofType:@"plist"];
            NSDictionary *messageTemplate = [NSDictionary dictionaryWithContentsOfFile:messageTemplateFile];
            [messageController setMessageComposeDelegate:(id)self];
            [messageController setBody:[messageTemplate objectForKey:@"SMS_InviteFriends"]];
            [presentingViewController presentViewController:messageController animated:YES completion:nil];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Unsupported"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    UIAlertView *alertView;
    switch (result) {
        case MessageComposeResultCancelled:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Cancelled"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
            break;
        case MessageComposeResultFailed:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Failed"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
            break;
        case MessageComposeResultSent:
            alertView = [[UIAlertView alloc] initWithTitle:nil message:[gUIStrings objectForKey:@"UI_SMS_Successful"] delegate:self cancelButtonTitle:[gUIStrings objectForKey:@"UI_AlertView_OnlyKnown"] otherButtonTitles:nil];
        default:
            break;
    }
    [alertView show];
    [controller dismissViewControllerAnimated:NO completion:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
