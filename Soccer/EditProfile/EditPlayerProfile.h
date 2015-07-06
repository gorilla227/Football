//
//  EditPlayerProfile.h
//  Soccer
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterProtocols.h"

@interface EditPlayerProfile_TableView : UITableView
@property id<DismissKeyboard>delegateForDismissKeyboard;
@end

@interface EditPlayerProfile : UITableViewController<UIImagePickerControllerDelegate, DismissKeyboard, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, JSONConnectDelegate>
@property enum EditProfileViewTypes viewType;
-(void)finishDateEditing;
-(void)fillInitialPlayerProfile;
@end
