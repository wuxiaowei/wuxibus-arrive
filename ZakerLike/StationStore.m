//
//  StationStore.m
//  ZakerLike
//
//  Created by wu xiaowei on 13-2-25.
//  Copyright (c) 2013年 Wuxi Smart Sencing Star. All rights reserved.
//

#import "StationStore.h"

@implementation StationStore
+(StationStore *)defaultStore{
    static StationStore *defaultStore=nil;
    if (!defaultStore) {
        defaultStore = [[super allocWithZone:nil] init];
    }
    return defaultStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init
{
    self = [super init];
    if(self) {
        NSString *path = [self itemArchivePath];
        allStations = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if(!allStations)
            allStations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"stations.archive"];
}

- (BOOL)saveChanges
{
    // returns success or failure
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allStations
                                       toFile:path];
}

-(void)removeStation:(BusStation *)station{
    [allStations removeObjectIdenticalTo:station];
}

-(NSArray *)allStations{
    return allStations;
}

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to
{
    if (from == to) {
        return;
    }
    // Get pointer to object being moved so we can re-insert it
    BusStation *p = [allStations objectAtIndex:from];
    
    // Remove p from array
    [allStations removeObjectAtIndex:from];
    
    // Insert p in array at new location
    [allStations insertObject:p atIndex:to];
}


- (BusStation *)createStation
{
    BusStation *p = [[BusStation alloc] init];
    
    [allStations addObject:p];
    
    return p;
}

-(void)addStation:(BusStation *)station{
    [allStations addObject:station];
}

-(void)removeAllStations{
    [allStations removeAllObjects];
}

-(void)removeStationAtIndex:(NSInteger)aIndex{
    [allStations removeObjectAtIndex:aIndex];
}

-(void)exchangeStationAtIndex:(NSInteger)oldIndex withStationAtIndex:(NSInteger)newIndex{
    [allStations exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
}
-(BusStation *)lastStation{
    return [allStations lastObject];
}
@end
