//
//  BusLineViewController.h
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-22.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusInfoDao.h"
#import "BusLine.h"
@interface BusLineViewController : UITableViewController
{
    BusInfoDao *busInfoDao;
    NSMutableArray *temBusLineArray;
}
-(void)dismiss;
@end
