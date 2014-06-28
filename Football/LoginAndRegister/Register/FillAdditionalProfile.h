//
//  FillAdditionalProfile.h
//  Football
//
//  Created by Andy on 14-6-10.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallFriends.h"

@interface FillAdditionalProfile_Cell : UICollectionViewCell

@end

@interface FillAdditionalProfile : UICollectionViewController<UIActionSheetDelegate>
@property NSInteger roleCode;
@end
