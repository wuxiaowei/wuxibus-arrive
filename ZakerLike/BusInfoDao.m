//
//  BusInfoDao.m
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-22.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import "BusInfoDao.h"

@implementation BusInfoDao
-(id)init{
    self=[super init];
    if (self) {
        db=[DBConn busInfoDB];
        [db open];
    }
    return self;
}
-(BusLine *)busLineRow:(NSInteger)row{
    //[db open];
    NSString *sql=@"select * from bus_line where _ID=?";
    FMResultSet *rs=[db executeQuery:sql,[NSNumber numberWithInt:row]];
    BusLine *busLine=[[BusLine alloc]init];
    if ([rs next]) {
        busLine.lineId=[rs stringForColumn:@"line_id"];
        busLine.lineName=[rs stringForColumn:@"line_name"];
        busLine.lineInfo=[rs stringForColumn:@"line_info"];
    }
    //[db close];
    return busLine;
    
}

-(int)countBusLine{
   // [db open];
    NSString *sql=@"select count(*) from bus_line";
    FMResultSet *rs=[db executeQuery:sql];
    int count=0;
    if ([rs next]) {
        count=[rs intForColumnIndex:0];
    }
   // [db close];
    return count;
    
}

-(int)countBusLineWithSearchText:(NSString *)condition{
  //  [db open];
    //NSString * sql=@"select count(*) from bus_line where line_name like \'%?%\'";
    NSString *sql=[NSString stringWithFormat:@"select count(*) from bus_line where line_name like '%%%@%%'",condition];
    
    FMResultSet *rs=[db executeQuery:sql];
    int count=0;
    if ([rs next]) {
        count=[rs intForColumnIndex:0];
    }
  //  [db close];
    return  count;
    
    
}

-(NSMutableArray *)busLineByName:(NSString *)name{
    NSMutableArray *busLineArray=[[NSMutableArray alloc]init];
    NSString *sql=[NSString stringWithFormat:@"select * from bus_line where line_name like '%%%@%%'",name];
    FMResultSet *rs=[db executeQuery:sql];
    while([rs next]) {
        BusLine *busLine=[[BusLine alloc]init];
        busLine.lineId=[rs stringForColumn:@"line_id"];
        busLine.lineName=[rs stringForColumn:@"line_name"];
        busLine.lineInfo=[rs stringForColumn:@"line_info"];
        [busLineArray addObject:busLine];
    }
    return busLineArray;
}

-(NSMutableArray *)segmentsByLineId:(NSString *)lineId{
    NSMutableArray *segmentArray=[[NSMutableArray alloc]init];
    NSString *sql=[NSString stringWithFormat:@"select * from bus_segment where line_id='%@'",lineId];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        BusSegment *busSegment=[[BusSegment alloc]init];
        busSegment.lineId=lineId;
        busSegment.segmentId=[rs stringForColumn:@"segment_id"];
        busSegment.segmentName=[rs stringForColumn:@"segment_name"];
        [segmentArray addObject:busSegment];
    }
    
    return segmentArray;
}

-(NSMutableArray *)stationByLineId:(NSString *)lineId bySegmentId:(NSString *)segmentId{
    NSMutableArray *stationsArray=[[NSMutableArray alloc]init];
    NSString *sql=[NSString stringWithFormat:@"select station_num,station_name from bus_station s,bus_stationinfo i where s.station_id=i.station_id and s.line_id='%@' and s.segment_id='%@' order by s.station_num",lineId,segmentId];
    FMResultSet *rs=[db executeQuery:sql];
    while ([rs next]) {
        BusStation *busStation=[[BusStation alloc]init];
        busStation.lineId=lineId;
        busStation.segmentId=segmentId;
        busStation.stationNum=[rs intForColumn:@"station_num"];
        busStation.stationName=[rs stringForColumn:@"station_name"];
        [stationsArray addObject:busStation];
    }
    
    return stationsArray;
}
@end
