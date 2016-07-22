//
//  APP_SETTINGS.h
//  MPP
//
//  Created by xxcao on 16/7/7.
//  @property(nonatomic,copy)right © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APP_SETTINGS : NSObject

@property(nonatomic,copy) NSString *current_app_version;
@property(nonatomic,copy) NSString *current_iPhone_OS;
@property(nonatomic,copy) NSString *current_iPhone_type;
@property(nonatomic,copy) NSString *current_server_address;
@property(nonatomic,copy) NSString *current_server_port;
@property(nonatomic,copy) NSString *last_login_user_id;
@property(nonatomic,copy) NSString *last_login_date;
@property(nonatomic,copy) NSString *last_login_user_name;
@property(nonatomic,copy) NSString *last_login_user_pwd;
@property(nonatomic,copy) NSString *current_login_user_id;
@property(nonatomic,copy) NSString *current_login_date;
@property(nonatomic,copy) NSString *current_login_user_name;
@property(nonatomic,copy) NSString *current_login_user_pwd;

@end
