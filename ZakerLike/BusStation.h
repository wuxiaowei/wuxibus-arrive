//
//  BusStation.h
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-23.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStation : NSObject<NSCoding>
@property (strong,nonatomic) NSString *lineId;
@property (strong,nonatomic) NSString *segmentId;
@property (nonatomic) NSInteger stationNum;
@property (strong,nonatomic) NSString *stationName;
@property (strong,nonatomic) NSString *lineName;
@property (strong,nonatomic) NSString *segmentName;
@end
