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
@class BJGridItem;
@interface InnerViewController : UIViewController<NSXMLParserDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>
{
    int count;
  //  NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
- (IBAction)doQuery:(id)sender;
- (IBAction)tick:(UIButton *)sender;
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
@property (nonatomic,weak) BJGridItem *girdItem;
@property (strong,nonatomic) IBOutlet SBTickerView *fullTickerView;
@property (strong,nonatomic) IBOutlet UIView *frontView;
@property (strong,nonatomic) IBOutlet UIView *backView;
@property(nonatomic) BOOL movable;
@property (strong,nonatomic) UIButton *button,*button2,*deleteButton,*deleteButton2;
-(id)initWithGirdItem:(BJGridItem *)aGridItem;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) BusStation *busStation;
@end
