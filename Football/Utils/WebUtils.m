//
//  WebUtils.m
//  Football
//
//  Created by Andy on 14-4-13.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "WebUtils.h"

@implementation WebUtils{
    NSURL *serverURL;
}
@synthesize delegate;

-(id)initWithServerURL:(NSString *)serverURLString andDelegate:(id)delegateOfData
{
    self = [super init];
    [self setDelegate:delegateOfData];
    [self configServerURL:serverURLString];
    return self;
}

-(void)configServerURL:(NSString *)serverURLString
{
    serverURL = [NSURL URLWithString:serverURLString];
}

-(BOOL)checkURLAvailable
{
    NSError *err;
    if (!serverURL) {
        return NO;
    }
    if ([serverURL checkResourceIsReachableAndReturnError:&err]) {
        return YES;
    }
    else {
        NSLog([err localizedDescription]);
        return NO;
    }
}

-(void)requestData:(NSString *)suffix
{
    if (!serverURL) {
        return;
    }
    NSURL *requestURL = [serverURL URLByAppendingPathComponent:suffix];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    NSURLSession *requestSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [requestSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(error.localizedDescription);
        }
        else {
            NSLog(@"拿到数据了");
            [delegate retrievalData:data];
        }
    }];
    [dataTask resume];
}
@end
