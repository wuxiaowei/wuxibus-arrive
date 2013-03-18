//
//  ViewController.m
//  SOAPTest
//
//  Created by wu xiaowei on 13-2-19.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import "DetailViewController.h"
#import "BusComInfo.h"
#import "StationStore.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
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
@synthesize busStation;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   // UINavigationItem *navItem
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    count=0;
    UILabel *label=(UILabel *)[frontView viewWithTag:1];
    label.text=[NSString stringWithFormat:@"%d",count];
    label=(UILabel *)[backView viewWithTag:1];
    label.text=[NSString stringWithFormat:@"%d",count+1];
    
    [fullTickerView setFrontView:frontView];
    [fullTickerView setBackView:backView];
    [fullTickerView setDuration:0.9];
    [self doQuery:nil];
    timer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(doQuery:) userInfo:nil repeats:YES];
}

-(void)dismiss{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
}
- (IBAction)doQuery:(id)sender {
    NSString *busSoapMsg=[NSString stringWithFormat:@"<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:tem=\"http://tempuri.org/\"><soap:Header/><soap:Body><tem:getBusALStationInfoCommon><tem:routeid>%@</tem:routeid><tem:segmentid>%@</tem:segmentid><tem:stationseq>%d</tem:stationseq><tem:fdisMsg/></tem:getBusALStationInfoCommon></soap:Body></soap:Envelope>",busStation.lineId,busStation.segmentId,busStation.stationNum];
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
  //  GDataXMLDocument *doc=[GDataXMLDocument alloc]init
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
        [fullTickerView tick:0 animated:YES completion:nil];
         
        stationFound=FALSE;
        timeFound=FALSE;
        numFound=FALSE;
        busComInfo=nil;
        [xmlParser abortParsing];
    }else if([elementName isEqualToString:@"fdisMsg"]){
      
        
        
         UILabel* label=(UILabel *)[[fullTickerView backView]viewWithTag:1];
        label.text=[NSString stringWithFormat:@"%@",busComInfo.fdisMsg];
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
   
    UILabel* label=(UILabel *)[[fullTickerView backView]viewWithTag:1];
    count+=1;
    label.text=[NSString stringWithFormat:@"%d",count];
    [fullTickerView tick:(sender.tag) animated:YES completion:nil];

}

-(void)asyncDoQuery:(id)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self doQuery:nil];
    });
}

- (IBAction)addStation:(id)sender {
    [[StationStore defaultStore]addStation:busStation];
}
@end
