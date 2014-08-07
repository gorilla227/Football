//
//  MessageBarButtonItem.h
//  Football
//
//  Created by Andy on 14-7-16.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define bBadgeViewSize 16

@protocol MessageBarButtonDelegate <NSObject>
-(void)messageButtonOnClicked;
@end

@interface MessageBarButtonItem : UIBarButtonItem
@property id<MessageBarButtonDelegate>delegate;
@property (nonatomic)NSInteger badgeNumber;
-(void)initBadgeView;
@end
