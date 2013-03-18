//
//  ViewController.m
//  SOAPTest
//
//  Created by wu xiaowei on 13-2-19.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import "InnerViewController.h"
//#import "GDataXMLNode.h"
#import "BusComInfo.h"
#import "BJGridItem.h"
@interface InnerViewController ()

@end

@implementation InnerViewController
@synthesize girdItem;
@synthesize webData;
@synthesize soapReults;
@synthesize xmlParser;
@synthesize elementFound;
@synthesize matchingElement;
@synthesize conn;
@synthesize phoneNumber;
@synthesize busComInfo;
@synthesize stationFound;
@synthesize timeFound;
@synthesize numFound;
@synthesize fdisFound;
@synthesize fullTickerView;
@synthesize frontView;
@synthesize backView;
@synthesize movable;
@synthesize button,button2,deleteButton,deleteButton2;
@synthesize timer;
@synthesize busStation;
-(id)initWithGirdItem:(BJGridItem *)aGridItem{
    self=[super init];
    if (self) {
        self.girdItem=aGridItem;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    frontView.frame=self.view.bounds;
    backView.frame=self.view.bounds;
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:frontView.bounds];
    
    [button setBackgroundColor:[UIColor clearColor]];
    
    [button addTarget:girdItem action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    button2=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [button2 setFrame:frontView.bounds];
    
    [button2 setBackgroundColor:[UIColor clearColor]];
    
    [button2 addTarget:girdItem action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [frontView addSubview:button];
    [backView addSubview:button2];
    if (self.movable) {
       deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        float w = 20;
        float h = 20;
        
        [deleteButton setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, w, h)];
        [deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor clearColor];
        [deleteButton addTarget:girdItem action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setHidden:YES];
        deleteButton2=[UIButton buttonWithType:UIButtonTypeCustom];
        
        
        [deleteButton2 setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, w, h)];
        [deleteButton2 setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
        deleteButton2.backgroundColor = [UIColor clearColor];
        [deleteButton2 addTarget:girdItem action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton2 setHidden:YES];;
        [frontView addSubview:deleteButton];
        [backView addSubview:deleteButton2];
    }
    [fullTickerView setFrontView:frontView];
    [fullTickerView setBackView:backView];
    [fullTickerView setDuration:1.];
    
   
}
/*

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!timer) {
         timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(doQuery:) userInfo:nil repeats:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doQuery:(id)sender {
        
   NSString *busSoapMsg=[NSString stringWithFormat:@"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:tem=\"http://tempuri.org/\"><soap:Header/><soap:Body><tem:getBusALStationInfoCommon><tem:routeid>%@</tem:routeid><tem:segmentid>%@</tem:segmentid><tem:stationseq>%d</tem:stationseq><tem:fdisMsg/></tem:getBusALStationInfoCommon></soap:Body></soap:Envelope>",busStation.lineId,busStation.segmentId,busStation.stationNum];
   // NSLog(@"%@",soapMsg);
    NSLog(@"%@",busSoapMsg);
    NSURL *busUrl=[NSURL URLWithString:@"http://218.90.160.85:9090/BusTravelGuideWebService/bustravelguide.asmx"];
    
   
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:busUrl];
  
    NSString *busMsgLength=[NSString stringWithFormat:@"%d",[busSoapMsg length]];
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  
    [req addValue:busMsgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];

    [req setHTTPBody:[busSoapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    conn=[[NSURLConnection alloc]initWithRequest:req delegate:self];
    if (conn) {
        webData=[NSMutableData data];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [webData appendData:data];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    conn=nil;
    webData=nil;
    NSLog(@"%@",error);
   
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *theXML=[[NSString alloc]initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];

    NSLog(@"%@",theXML);
    
    xmlParser=[[NSXMLParser alloc]initWithData:webData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    
    if ([elementName isEqualToString:@"stationname"]) {
        if (!busComInfo) {
            busComInfo=[[BusComInfo alloc]init];
            
        }
        stationFound=YES;
    }

    if([elementName isEqualToString:@"actdatetime"]){
        timeFound=YES;
    }

    if([elementName isEqualToString:@"stationnum"]){
        numFound=YES;
    }

    if([elementName isEqualToString:@"fdisMsg"]){
        if (!busComInfo) {
            busComInfo=[[BusComInfo alloc]init];
            
        }
        fdisFound=YES;
        
    }

}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if (stationFound) {
        [busComInfo.stationname appendString:string];
        NSLog(@"%@",busComInfo.stationname);
    }
    if (timeFound) {
        [busComInfo.actdatetime appendString:string];
    }
    if (numFound) {
        [busComInfo.stationnum appendString:string];
    }
    if (fdisFound) {
        [busComInfo.fdisMsg appendString:string];
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"stationname"]) {
        stationFound=FALSE;
    }
    if ([elementName isEqualToString:@"actdatetime"]) {
        timeFound=FALSE;
    }
    if ([elementName isEqualToString:@"stationnum"]) {
       
       
        
        UILabel* label=(UILabel *)[[fullTickerView backView]viewWithTag:1];
        label.text=[NSString stringWithFormat:@"Bus Route 10 has arrived in %@ at time %@,from here %@ station",busComInfo.stationname,busComInfo.actdatetime,busComInfo.stationnum];
        NSInteger num=[busComInfo.stationnum integerValue];
        if (num<=2) {
            [[fullTickerView backView] setBackgroundColor:[UIColor redColor]];
        }
        if (num>2&&num<=5) {
            [[fullTickerView backView]setBackgroundColor:[UIColor yellowColor]];
        }
        
        if (num>5) {
            [[fullTickerView backView]setBackgroundColor:[UIColor greenColor]];
        }
        [fullTickerView tick:0 animated:YES completion:nil];
         
        stationFound=FALSE;
        timeFound=FALSE;
        numFound=FALSE;
        busComInfo=nil;
        [xmlParser abortParsing];
    }else if([elementName isEqualToString:@"fdisMsg"]){
    
        
         UILabel* label=(UILabel *)[[fullTickerView backView]viewWithTag:1];
        label.text=[NSString stringWithFormat:@"%@",busComInfo.fdisMsg];
        [[fullTickerView backView]setBackgroundColor:[UIColor grayColor]];
        [fullTickerView tick:0 animated:YES completion:nil];
         
        fdisFound=FALSE;
        busComInfo=nil;
        [xmlParser abortParsing];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    if (busComInfo.stationname||busComInfo.fdisMsg) {
        busComInfo=nil;
    }
}


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if (busComInfo.stationname||busComInfo.fdisMsg) {
        busComInfo=nil;
    }
}

- (IBAction)tick:(UIButton *)sender {
   
    [fullTickerView tick:(sender.tag) animated:YES completion:nil];

}



@end
