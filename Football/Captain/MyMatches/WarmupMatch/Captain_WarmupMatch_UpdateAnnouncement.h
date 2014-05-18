//
//  Captain_WarmupMatch_UpdateAnnouncement.h
//  Football
//
//  Created by Andy Xu on 14-5-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UpdateAnnouncement <NSObject>
-(void)updateAnnouncement:(NSString *)announcement;
@end

@interface Captain_WarmupMatch_UpdateAnnouncement : UIViewController<UITextViewDelegate>
@property id<UpdateAnnouncement>delegate;
@property NSString *announcementText;
@property IBOutlet UITextView *announcementTextView;
@property IBOutlet UIBarButtonItem *saveButton;

//-(void)announcementViewTextChanged;
@end
