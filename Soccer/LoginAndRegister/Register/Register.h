//
//  Register.h
//  Soccer
//
//  Created by Andy Xu on 14-6-8.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FillAdditionalProfile.h"
#import "LoginAndRegisterProtocols.h"

@interface Register_TableView : UITableView
@property id<DismissKeyboard>delegateForDismissKeyboard;
@end

@interface Register : UITableViewController<UITextFieldDelegate, DismissKeyboard, UIAlertViewDelegate, JSONConnectDelegate>
-(void)refreshRegisterButtonEnable;
@end
