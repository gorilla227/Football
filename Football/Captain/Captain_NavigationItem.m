//
//  Captain_NavigationItem.m
//  Football
//
//  Created by Andy on 14-4-19.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_NavigationItem.h"

@implementation Captain_NavigationItem
@synthesize delegateOfMenuAppearance;

-(IBAction)menuButtonOnClicked:(id)sender
{
    if (delegateOfMenuAppearance) {
        [delegateOfMenuAppearance menuSwitch];
    }
}
@end
