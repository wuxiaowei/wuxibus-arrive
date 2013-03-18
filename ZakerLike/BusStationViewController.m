//
//  BusStationViewController.m
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-23.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import "BusStationViewController.h"

@interface BusStationViewController ()

@end

@implementation BusStationViewController
@synthesize busLine;
@synthesize busSegment;
@synthesize busInfoDao;
@synthesize segmentsArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"line_id %@",busLine.lineId);
    NSLog(@"line_name %@",busLine.lineName);
    segmentsArray=[busInfoDao segmentsByLineId:busLine.lineId];
    if ([segmentsArray count]==1) {
        [busSegment removeSegmentAtIndex:1 animated:NO];
    }
    
    for (BusSegment *s in segmentsArray) {
        NSLog(@"segment id %@",s.segmentId);
        NSLog(@"segment name %@",s.segmentName);
        [busSegment setTitle:s.segmentName forSegmentAtIndex:[segmentsArray indexOfObject:s]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSInteger index=[[self busSegment]selectedSegmentIndex];
    BusSegment *segment=[segmentsArray objectAtIndex:index];
    tempStationsArray=[busInfoDao stationByLineId:busLine.lineId bySegmentId:segment.segmentId];
    if (tableView==self.tableView) {
        return [tempStationsArray count];
    }
  //  NSPredicate *pre=[NSPredicate predicateWithFormat:@"stationName contains[cd] %@",self.searchDisplayController.searchBar.text];
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"stationName contains[cd] %@",@"张"];
    tempSearchArray=[tempStationsArray filteredArrayUsingPredicate:pre];
    return [tempSearchArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView==self.tableView) {
        BusStation *station=[tempStationsArray objectAtIndex:[indexPath row]];
        cell.textLabel.text=station.stationName;
        return cell;
    }
    BusStation *station=[tempSearchArray objectAtIndex:[indexPath row]];
    cell.textLabel.text=station.stationName;
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    BusStation *station=[tempStationsArray objectAtIndex:[indexPath row]];
    DetailViewController *flipViewController=[[DetailViewController alloc]init];
    station.lineName=busLine.lineName;
    station.segmentName=[busSegment titleForSegmentAtIndex:[busSegment selectedSegmentIndex]];
    flipViewController.busStation=station;
    [self.navigationController pushViewController:flipViewController animated:YES];
    
}
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     return self.busSegment;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.0;
}
 */

/*
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.busSegment;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45.0;
}
 */

- (IBAction)changSegment:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}
@end
