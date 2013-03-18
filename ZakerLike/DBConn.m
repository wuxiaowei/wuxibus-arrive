//
//  DBConn.m
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-22.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import "DBConn.h"
static FMDatabase *db;
@implementation DBConn
+(FMDatabase *)busInfoDB{
    if (!db) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"wuxitraffic" ofType:@"db"];
        db=[FMDatabase databaseWithPath:path];
    }
    return db;
}
@end
