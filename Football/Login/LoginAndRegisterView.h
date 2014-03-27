//
//  LoginAndRegisterView.h
//  Football
//
//  Created by Andy on 14-3-23.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginAndRegisterView <NSObject>
-(void)presentLoginView;
-(void)presentRegisterView;
-(void)keyboardWillShow;
-(void)keyboardWillHide;
@end

@protocol DismissKeyboard <NSObject>
-(void)dismissKeyboard;
@end

@protocol DismissCallFriendsMenu <NSObject>
-(void)dismissCallFriendsMenu;
@end
