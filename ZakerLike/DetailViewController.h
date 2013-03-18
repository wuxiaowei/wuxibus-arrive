//
//  ViewController.h
//  SOAPTest
//
//  Created by wu xiaowei on 13-2-19.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BusComInfo;
#import "SBTickerView.h"
#import "BusStation.h"
@interface DetailViewController : UIViewController<NSXMLParserDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>
{
    int count;
    NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
- (IBAction)doQuery:(id)sender;
- (IBAction)tick:(UIButton *)sender;
-(IBAction)asyncDoQuery:(id)sender;
@property (strong,nonatomic) NSMutableData *webData;
@property (strong,nonatomic) NSMutableString *soapReults;
@property (strong,nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong,nonatomic) NSString *matchingElement;
@property (strong,nonatomic) NSURLConnection *conn;
@property (strong,nonatomic) BusComInfo *busComInfo;
@property (nonatomic) BOOL stationFound;
@property (nonatomic) BOOL timeFound;
@property (nonatomic) BOOL numFound;
@property (nonatomic) BOOL fdisFound;
@property (strong,nonatomic) IBOutlet SBTickerView *fullTickerView;
@property (strong,nonatomic) IBOutlet UIView *frontView;
@property (strong,nonatomic) IBOutlet UIView *backView;
- (IBAction)addStation:(id)sender;
@property (strong,nonatomic) BusStation *busStation;
-(void)dismiss;
@end
