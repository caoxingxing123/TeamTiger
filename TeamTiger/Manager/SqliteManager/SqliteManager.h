//
//  SqliteManager.h
//
//  Created by xxcao on 16/7/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//  数据库管理类
//  一个APP 一个SYSTEM数据库（名字：SYSYTEM） n个用户数据库（名字：user_id）
//  通过- (void)setDataBasePath:(NSString *)dbName方法切换不同的数据库
//  由isNeedUpdate 布尔值决定是否更新数据库、数据表
//  由isUser 布尔值决定是否更新系统数据库（SYSYTEM）或者用户数据库（user）
//  建表过程分为两步：1.onUpgradeVersion方法 2.创建对应model（同时不要忘记定义常量）

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define  SQLITEMANAGER   [SqliteManager sharedInstance]

@interface SqliteManager : NSObject {
    sqlite3 *db;
}

+ (instancetype)sharedInstance;

//step 1
- (void)setDataBasePath:(NSString *)dbName;

//step 2
- (BOOL)createDataBaseIsNeedUpdate:(BOOL)isNeedUpdate isForUser:(BOOL)isUser;

- (BOOL)executeSql:(NSString *)sql;

- (NSArray *)selectDatasSql:(NSString *)sql Class:(NSString *)objClass;

- (int)caculateCountOrSumSql:(NSString *)sql;


@end
