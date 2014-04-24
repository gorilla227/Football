//
//  HintTextView.h
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HintTextView : UITextView
@property UIView *boundedView;
- (id)initWithTextKey:(NSString *)keyOfHintText underView:(UIView *)dockView;
@end
