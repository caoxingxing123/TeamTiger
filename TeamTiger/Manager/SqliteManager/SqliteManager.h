//
//  SqliteManager.h
//  MPP
//
//  Created by xxcao on 16/7/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

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
