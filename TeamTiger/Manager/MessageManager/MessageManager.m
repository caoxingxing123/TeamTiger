//
//  MessageManager.m
//  TeamTiger
//
//  Created by xxcao on 16/7/22.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "MessageManager.h"

@implementation MessageManager

static MessageManager *singleton = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[[self class] alloc] init];
        }
    });
    return singleton;
}

- (void)handleOneMessage:(id)msgObj {
    //do a message
}

@end
