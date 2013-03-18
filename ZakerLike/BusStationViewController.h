//
//  BusStationViewController.h
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-23.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusLine.h"
#import "BusInfoDao.h"
#import "DetailViewController.h"
@interface BusStationViewController : UITableViewController{
    NSMutableArray *tempStationsArray;
    NSArray *tempSearchArray;
}
@property (strong,nonatomic) BusInfoDao *busInfoDao;
@property (strong,nonatomic) BusLine *busLine;
@property (strong, nonatomic) IBOutlet UISegmentedControl *busSegment;
- (IBAction)changSegment:(UISegmentedControl *)sender;
@property (strong,nonatomic) NSMutableArray *segmentsArray;
@end
