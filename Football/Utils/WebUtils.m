//
//  WebUtils.m
//  Football
//
//  Created by Andy on 14-4-13.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "WebUtils.h"

@implementation WebUtils{
    NSString *serverURL;
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
    serverURL = serverURLString;
}

-(void)requestData:(NSString *)suffix forSelector:(SEL)selector
{
    if (!serverURL) {
        return;
    }
    NSURL *requestURL = [NSURL URLWithString:[serverURL stringByAppendingPathComponent:suffix]];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    NSURLSession *requestSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [requestSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(error.localizedDescription);
        }
        else {
            NSLog(@"Data Retrieved");
            [dataTask cancel];
            [delegate retrieveData:data forSelector:selector];
        }
    }];
    [dataTask resume];
}
@end
