//
//  BusComInfo.m
//  SOAPTest
//
//  Created by wu xiaowei on 13-2-19.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import "BusComInfo.h"

@implementation BusComInfo
@synthesize stationname;
@synthesize actdatetime;
@synthesize stationnum;
@synthesize fdisMsg;

-(id)init{
    self=[super init];
    if (self) {
        stationname=[[NSMutableString alloc]init];
        actdatetime=[[NSMutableString alloc]init];
        stationnum=[[NSMutableString alloc]init];
        fdisMsg=[[NSMutableString alloc]init];
    }
    
    return self;
}
@end
