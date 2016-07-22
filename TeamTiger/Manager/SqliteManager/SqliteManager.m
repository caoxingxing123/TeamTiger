//
//  SqliteManager.m
//  MPP
//
//  Created by xxcao on 16/7/7.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "SqliteManager.h"
#import <objc/runtime.h>

@interface SqliteManager ()

@property (copy, nonatomic)NSString *dbPath;

@end

@implementation SqliteManager

static SqliteManager *singleton = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[[self class] alloc] init];
        }
    });
    return singleton;
}

- (void)setDataBasePath:(NSString *)dbName{
    if (!dbName) {
        NSAssert(!dbName, @"please must fill db name");
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbDir = [paths[0] stringByAppendingFormat:@"/database"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dbDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    self.dbPath = [NSString stringWithFormat:@"%@/%@.db",dbDir,dbName];
    
    if ([self.dbPath containsString:@"SYSTEM"]) {
        NSLog(@"Current System DB Path: %@",self.dbPath);
    } else {
        NSLog(@"Current User DB Path: %@",self.dbPath); 
    }
}


- (BOOL)createDataBaseIsNeedUpdate:(BOOL)isNeedUpdate isForUser:(BOOL)isUser{
    @synchronized (self) {
        if (!self.dbPath){
            NSAssert(YES, @"database path can not be nil");
            return NO;
        }
        
        if (sqlite3_open([self.dbPath UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
            return NO;
        }
        //是否要更新检查表
        if (isNeedUpdate) {
            [self onUpgradeVersion:db isForUser:isUser];
        }
        
//        UserDefaultsSave(AppVersion, @"Key_Last_Version");
        sqlite3_close(db);
        return YES;
    }
}

- (BOOL)executeSql:(NSString *)sql {
    @synchronized (self) {
        if (sqlite3_open([self.dbPath UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
            return NO;
        }
        char *err;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库操作数据失败!");
            return NO;
        }
        sqlite3_close(db);
        return YES;
    }
}

- (NSArray *)selectDatasSql:(NSString *)sql Class:(NSString *)objClass {
    @synchronized (self) {
        if (sqlite3_open([self.dbPath UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
            return nil;
        }
        
        NSMutableArray *resutArray = nil;
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            int column_count = sqlite3_column_count(statement);
            while (sqlite3_step(statement) == SQLITE_ROW) {

                NSObject *object = [[NSClassFromString(objClass) alloc] init];

                for (int i = 0; i < column_count; i++) {
                    const char *column_name = sqlite3_column_name(statement, i);
                    NSString *key = [NSString stringWithFormat:@"%s", column_name];

                    const char *column_decltype = sqlite3_column_decltype(statement, i);
                    NSString *obj_column_decltype = [[NSString stringWithUTF8String:column_decltype] lowercaseString];

                    id column_value = nil;
                    NSData *column_data = nil;
                    
                    if ([obj_column_decltype isEqualToString:@"text"]) {
                        const unsigned char *value = sqlite3_column_text(statement, i);
                        if (value != NULL) {
                            column_value = [NSString stringWithUTF8String: (const char *)value];
                            if (column_value) {
                                [object setValue:column_value forKey:key];
                            }
                        }
                    }
                    else if ([obj_column_decltype isEqualToString:@"integer"]) {
                        int value = sqlite3_column_int(statement, i);
                        column_value = [NSNumber numberWithLongLong: value];
                        [object setValue:column_value forKey:key];
                    }
                    else if ([obj_column_decltype isEqualToString:@"real"]) {
                        double value = sqlite3_column_double(statement, i);
                        column_value = [NSNumber numberWithDouble:value];
                        [object setValue:column_value forKey:key];
                    }
                    else if ([obj_column_decltype isEqualToString:@"blob"]) {
                        const void *databyte = sqlite3_column_blob(statement, i);
                        if (databyte != NULL) {
                            int dataLenth = sqlite3_column_bytes(statement, i);
                            column_data = [NSData dataWithBytes:databyte length:dataLenth];
                            [object setValue:column_data forKey:key];
                        }
                    }
                    else {
                        const unsigned char *value = sqlite3_column_text(statement, i);
                        if (value != NULL) {
                            column_value = [NSString stringWithUTF8String: (const char *)value];
                            [object setValue:column_value forKey:key];
                        }
                    }
                }
                
                if (!resutArray) {
                    resutArray = [[NSMutableArray alloc] initWithObjects:object, nil];
                } else {
                    [resutArray addObject:object];
                }
            }
        }
        sqlite3_finalize(statement);
        statement = nil;
        sqlite3_close(db);
        return resutArray;
    }
}


/**
 *	计算count(*)或 sum (*)
 */
- (int)caculateCountOrSumSql:(NSString *)sql {
    @synchronized(self){
        if (sqlite3_open([self.dbPath UTF8String], &db) != SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"数据库打开失败");
            return -1;
        }
        sqlite3_stmt *stmt;
        int count = 0;
        int tmpRet = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
        if (tmpRet == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                count = sqlite3_column_int(stmt, 0);
            }
        }
        sqlite3_finalize(stmt);
        stmt = nil;
        sqlite3_close(db);
        return count;
    }
}


#pragma -mark
-(void)checkTable:(sqlite3*)database
        tableName:(NSString*)tableName
        allFields:(NSMutableArray*)allFields
    allFieldTypes:(NSMutableArray*)allFieldTypes
      primaryKeys:(NSMutableArray*)primaryKeys
isFieldTypeChanged:(BOOL)isFieldTypeChanged
{
    if(!database||!tableName||
       allFields==nil||allFields.count<=0||
       allFieldTypes==nil||allFieldTypes.count<=0||
       allFields.count!=allFieldTypes.count) return;
    
    NSString* sql=[NSString stringWithFormat:@"select * from %@ where (1=0)", tableName];
    sqlite3_stmt *stmt;
    NSString* newTableName=[NSString stringWithFormat:@"%@_tmp", tableName];
    NSString* tempText1, *tempText2;
    const char * columnName=nil;
    NSHashTable* hash=[[NSHashTable alloc] init];
    int tmpRet = sqlite3_prepare_v2(database, [sql UTF8String], -1, &stmt, NULL);
    if (tmpRet == SQLITE_OK)
    {
        int column_count = sqlite3_column_count(stmt);
        //array=[[NSMutableArray alloc] init];
        for(int i=0;i<column_count;i++)
        {
            columnName= sqlite3_column_name(stmt, i);
            NSString* nsColumnName=[NSString stringWithUTF8String:columnName];
            [hash addObject:nsColumnName];
        }
        
        for(int i=0;i<allFields.count;i++)
        {
            tempText1=[allFields objectAtIndex:i];
            tempText2=[allFieldTypes objectAtIndex:i];
            if(![hash containsObject:tempText1]){
                sql=[NSString stringWithFormat:@"alter table %@ add column %@ %@", tableName, tempText1,tempText2];
                [[SqliteManager sharedInstance] executeSql:sql];
            }
        }
        
        if(isFieldTypeChanged)
        {
            [self onCreateTable:database tableName:newTableName allFields:allFields allFieldTypes:allFieldTypes primaryKeys:primaryKeys];
            [self onMoveTable:database tableName:tableName newTableName:newTableName allFields:allFields allFieldTypes:allFieldTypes hasKDbIdColumnInNewTable:YES];
            sql=[NSString stringWithFormat:@"drop table %@",tableName];
            [[SqliteManager sharedInstance] executeSql:sql];
            sql=[NSString stringWithFormat:@"alter table %@ rename to %@", newTableName, tableName];
            [[SqliteManager sharedInstance] executeSql:sql];
        }
    }
    else{
        [self onCreateTable:database tableName:tableName allFields:allFields allFieldTypes:allFieldTypes primaryKeys:primaryKeys];
    }
}

- (void)onMoveTable:(sqlite3*)database
         tableName:(NSString*)tableName
      newTableName:(NSString*)newTableName
         allFields:(NSMutableArray*)allFields
     allFieldTypes:(NSMutableArray*)allFieldTypes
hasKDbIdColumnInNewTable:(BOOL)hasKDbIdColumnInNewTable
{
    NSInteger index = [allFields indexOfObject:@"__id__"];
    
    NSMutableString* sb=[[NSMutableString alloc] init];
    [sb appendString:@"insert into "];
    [sb appendString:newTableName];
    [sb appendString:@"("];
    
    for(int i=0;i<allFields.count;i++)
        if(index<0||i==index)
        {
            [sb appendString:[allFields objectAtIndex:i]];
            [sb appendString:@","];
        }
    NSRange range;
    range.location=sb.length-1;
    range.length=1;
    [sb deleteCharactersInRange:range];
    [sb appendString:@") select "];
    
    for(int i=0;i<allFields.count;i++)
        if(index<0||i==index)
        {
            [sb appendString:[allFields objectAtIndex:i]];
            [sb appendString:@","];
        }
    [sb deleteCharactersInRange:range];
    [sb appendString:@" from "];
    [sb appendString:tableName];
    [[SqliteManager sharedInstance] executeSql:sb];
}

- (void)onCreateTable:(sqlite3*)database
           tableName:(NSString*)tableName
           allFields:(NSMutableArray*)allFields
       allFieldTypes:(NSMutableArray*)allFieldTypes
         primaryKeys:(NSMutableArray*)primaryKeys
{
    NSMutableString* sb=[[NSMutableString alloc] init];
    [sb appendString:@"create table "];
    [sb appendString:tableName];
    [sb appendString:@"("];
    for(int i=0;i<allFields.count;i++)
    {
        [sb appendString:[allFields objectAtIndex:i]];
        [sb appendString:@" "];
        [sb appendString:[allFieldTypes objectAtIndex:i]];
        [sb appendString:@","];
    }
    NSRange range;
    range.location=sb.length-1;
    range.length=1;
    [sb deleteCharactersInRange:range];
    [sb appendString:@")"];
    [[SqliteManager sharedInstance] executeSql:sb];
    
    //create the unique index for primary keys
    //for we already create the __id__ as the primary key
    if(primaryKeys&&primaryKeys.count>0)
    {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSString *uniqueIndex = [[[uuid stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString] substringToIndex:20];
        sb=[[NSMutableString alloc] init];
        [sb appendString:@"create unique index INDEX_"];
        [sb appendString:uniqueIndex];
        [sb appendString:@" on "];
        [sb appendString:tableName];
        [sb appendString:@"("];
        for(int i=0;i<primaryKeys.count;i++)
        {
            [sb appendString:[primaryKeys objectAtIndex:i]];
            [sb appendString:@","];
        }
        range.location=sb.length-1;
        [sb deleteCharactersInRange:range];
        [sb appendString:@")"];
        [[SqliteManager sharedInstance] executeSql:sb];
    }
}


- (void)preparePredefineDatas:(sqlite3 *)database
                     commands:(NSMutableArray *)commands {
    for (NSString *sql in commands) {
        @try {
            [[SqliteManager sharedInstance] executeSql:sql];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        @finally {
            
        }
    }
}



#pragma -mark
#pragma -mark 更新表
-(BOOL)onUpgradeVersion:(sqlite3*)database isForUser:(BOOL)isUser
{
    if (isUser) {
        //T_APP_USERS
        [self checkTable:database
               tableName:@"APP_USERS"
               allFields:@[@"name",@"age",@"title"].mutableCopy
           allFieldTypes:@[@"NVARCHAR",@"INT",@"NVARCHAR"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
    } else {
        //T_APP_SETTINGS
        [self checkTable:database
               tableName:@"APP_SETTINGS"
               allFields:@[@"current_app_version",@"current_iPhone_OS",@"current_iPhone_type",@"current_server_address",@"current_server_port",@"last_login_user_id",@"last_login_date",@"last_login_user_name",@"last_login_user_pwd",@"current_login_user_id",@"current_login_date",@"current_login_user_name",@"current_login_user_pwd"].mutableCopy
           allFieldTypes:@[@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR",@"NVARCHAR"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];
        
        //T_TASK_STATES
        [self checkTable:database
               tableName:@"TASK_STATES"
               allFields:@[@"state_description",@"state_code",@"task_type"].mutableCopy
           allFieldTypes:@[@"NVARCHAR",@"INT",@"INT"].mutableCopy
             primaryKeys:nil
      isFieldTypeChanged:NO
         ];

        //
        //    //add preparePredefineDatas
        //    [SqliteManager preparePredefineDatas:database commands:
        //     [@[
        //
        //
        //
        //        @"delete from T_APP_APPLICATION_MSG",
        //        @"INSERT INTO T_APP_APPLICATION_MSG(__id__,application_msg_id, application_id, content, is_valid, is_visit) VALUES(1,'cf3ca900804743fc9334c5a8a4c4fc72','092ad3c991374d7a83ca62cb3f01c837','项目组已报批9月6日全网检修票。',1,1)",
        //        ]mutableCopy] userId:userId];
        
    }
    return YES;
}

@end
