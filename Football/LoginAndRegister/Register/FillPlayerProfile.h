//
//  FillPlayerProfile.h
//  Football
//
//  Created by Andy on 14-6-14.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAndRegisterProtocols.h"
#import "UITextFieldForActivityRegion.h"

@interface FillPlayerProfile_TableView : UITableView
@property id<DismissKeyboard>delegateForDismissKeyboard;
@end

@interface FillPlayerProfile : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DismissKeyboard, UITextFieldDelegate, UIActionSheetDelegate>
-(void)finishDateEditing;
@end
