//
//  Captain_CreateMatch.h
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pre_Define.h"
#import "TintTextView.h"

@interface Captain_CreateMatch : UIViewController<UITextFieldDelegate>
@property IBOutlet UITextField *matchTime;
-(void)matchTimeSelected;
-(void)initialMatchTime;
@end
