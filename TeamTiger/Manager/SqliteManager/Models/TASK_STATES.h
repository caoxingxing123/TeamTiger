//
//  TASK_STATES.h
//  MPP
//
//  Created by xxcao on 16/7/13.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TASK_STATES : NSObject

@property(nonatomic,copy) NSString *state_description;

@property(nonatomic,assign) NSInteger state_code;

@property(nonatomic,assign) NSInteger task_type;

@end
