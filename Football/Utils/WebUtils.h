//
//  WebUtils.h
//  Football
//
//  Created by Andy on 14-4-13.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WebUtils;
@protocol DataReady <NSObject>

-(void)retrievalData:(NSData *)data;

@end

@interface WebUtils : NSObject
@property id<DataReady>delegate;
-(id)initWithServerURL:(NSString *)serverURLString andDelegate:(id)delegateOfData;
-(void)configServerURL:(NSString *)serverURLString;
-(BOOL)checkURLAvailable;
-(void)requestData:(NSString *)suffix;
@end
