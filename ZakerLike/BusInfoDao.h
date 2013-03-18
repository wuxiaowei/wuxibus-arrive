//
//  BusInfoDao.h
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-22.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConn.h"
#import "BusLine.h"
#import "BusSegment.h"
#import "BusStation.h"
@interface BusInfoDao : NSObject
{
    FMDatabase *db;
}
-(NSMutableArray *)busLineByName:(NSString *)name;
-(BusLine *)busLineRow:(NSInteger)row;
-(int)countBusLine;
-(int)countBusLineWithSearchText:(NSString *)condition;
-(NSMutableArray *)segmentsByLineId:(NSString *)lineId;
-(NSMutableArray *)stationByLineId:(NSString *)lineId bySegmentId:(NSString *)segmentId;

@end
