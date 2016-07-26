//
//  NetworkManager.m
//  TeamTiger
//
//  Created by xxcao on 16/7/22.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "NetworkManager.h"
#import "LCNetworkConfig.h"
#import "LCProcessFilter.h"

static double const timeOutInterval = 15.0;

@implementation NetworkManager : NSObject

+ (void)configerNetworking {
    LCNetworkConfig *config = [LCNetworkConfig sharedInstance];
    config.mainBaseUrl = @"http://api.zdoz.net/";
    LCProcessFilter *filter = [[LCProcessFilter alloc] init];
    config.processRule = filter;
}

@end

@implementation Api1

- (NSString *)apiMethodName {
    return @"getweather2.aspx";
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

- (NSTimeInterval)requestTimeoutInterval {
    return timeOutInterval;
}

- (BOOL)ignoreUnifiedResponseProcess {
    return YES;
}

- (BOOL)cacheResponse {
//1.return NO; 不需要缓存
    
//2.return such as 需要缓存并设定时长
    if (self.cacheInvalidTime > 0)  {
        return YES;
    }
    return NO;
}

@end

@implementation Api2

- (NSString *)apiMethodName {
    return nil;
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

@end

@implementation Api3

- (NSString *)apiMethodName {
    return nil;
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

@end

@implementation ImageUploadApi

- (NSString *)apiMethodName {
    return nil;
}

- (LCRequestMethod)requestMethod {
    return LCRequestMethodGet;
}

@end

