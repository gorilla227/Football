//
//  TintTextView.h
//  Football
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TintTextView : UITextView
@property UIView *boundedView;
- (id)initWithTextKey:(NSString *)keyOfTintText underView:(UIView *)dockView;
@end
