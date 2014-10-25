//
//  EditTeamProfile.h
//  Football
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterProtocols.h"

@interface EditTeamProfile_TableView : UITableView
@property id<DismissKeyboard>delegateForDismissKeyboard;
@end

@interface EditTeamProfile : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DismissKeyboard, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, JSONConnectDelegate>
@property enum EditProfileViewSource viewSource;
-(void)fillInitialTeamProfile;
@end
