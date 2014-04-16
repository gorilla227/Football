//
//  WebUtils.h
//  Football
//
//  Created by Andy on 14-4-13.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WebUtils;
@protocol WebUtilsDelegate <NSObject>

-(void)retrieveData:(NSData *)data forSelector:(SEL)selector;

@end

@interface WebUtils : NSObject
@property id<WebUtilsDelegate>delegate;
-(id)initWithServerURL:(NSString *)serverURLString andDelegate:(id)delegateOfData;
-(void)configServerURL:(NSString *)serverURLString;
-(void)requestData:(NSString *)suffix forSelector:(SEL)selector;
@end
