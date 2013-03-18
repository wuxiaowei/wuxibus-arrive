//
//  BusStation.m
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-23.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import "BusStation.h"

@implementation BusStation
@synthesize lineId;
@synthesize segmentId;
@synthesize stationNum;
@synthesize stationName;
@synthesize lineName;
@synthesize segmentName;
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:lineId forKey:@"lineId"];
    [aCoder encodeObject:segmentId forKey:@"segmentId"];
    [aCoder encodeInteger:stationNum forKey:@"stationNum"];
    [aCoder encodeObject:stationName forKey:@"stationName"];
    [aCoder encodeObject:lineName forKey:@"lineName"];
    [aCoder encodeObject:segmentName forKey:@"segmentName"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if (self) {
        self.lineId=[aDecoder decodeObjectForKey:@"lineId"];
        self.segmentId=[aDecoder decodeObjectForKey:@"segmentId"];
        self.stationNum=[aDecoder decodeIntegerForKey:@"stationNum"];
        self.stationName=[aDecoder decodeObjectForKey:@"stationName"];
        self.lineName=[aDecoder decodeObjectForKey:@"lineName"];
        self.segmentName=[aDecoder decodeObjectForKey:@"segmentName"];
    }
    return self;
}
@end
