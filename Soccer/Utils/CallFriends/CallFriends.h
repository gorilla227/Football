//
//  CallFriends.h
//  Soccer
//
//  Created by Andy on 14-5-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MessageUI;

@interface CallFriends : UIActionSheet<MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>
-(id)initWithPresentingViewController:(UIViewController *)viewController;

@end
