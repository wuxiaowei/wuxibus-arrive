//
//  StationStore.h
//  ZakerLike
//
//  Created by wu xiaowei on 13-2-25.
//  Copyright (c) 2013年 Wuxi Smart Sencing Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusStation.h"
@interface StationStore : NSObject
{
    NSMutableArray *allStations;
}
+(StationStore *)defaultStore;
- (NSString *)itemArchivePath;
- (BOOL)saveChanges;
-(void)removeStation:(BusStation *)station;
-(NSArray *)allStations;
- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;
- (BusStation *)createStation;
-(void)addStation:(BusStation *)station;
-(void)removeAllStations;
-(void)removeStationAtIndex:(NSInteger)aIndex;
-(void)exchangeStationAtIndex:(NSInteger)oldIndex withStationAtIndex:(NSInteger)newIndex;
-(BusStation *)lastStation;
@end
