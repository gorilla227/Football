//
//  FillTeamProfile.h
//  Football
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterProtocols.h"
#import "UITextFieldForActivityRegion.h"

@interface FillTeamProfile_TableView : UITableView
@property id<DismissKeyboard>delegateForDismissKeyboard;
@end

@interface FillTeamProfile : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DismissKeyboard, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, JSONConnectDelegate>
-(void)fillInitialTeamProfile;
@end
