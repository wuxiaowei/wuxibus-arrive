//
//  BusLineViewController.m
//  SQLiteTest
//
//  Created by wu xiaowei on 13-2-22.
//  Copyright (c) 2013年 wu xiaowei. All rights reserved.
//

#import "BusLineViewController.h"
#import "BusStationViewController.h"
@interface BusLineViewController ()

@end

@implementation BusLineViewController

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
    /*
    FMDatabase *db=[DBConn busInfoDB];
    [db open];
    
    FMResultSet *rs=[db executeQuery:@"select * from bus_line"];
    while ([rs next]) {
        NSLog(@"%@ %@  %@",[rs stringForColumn:@"line_id"],[rs stringForColumn:@"line_name"],[rs stringForColumn:@"line_info"]);
    }
    [db close];
    */
    busInfoDao=[[BusInfoDao alloc]init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tableView) {
        int count=[busInfoDao countBusLine];
        return count;
    }
    
    int coun=[busInfoDao countBusLineWithSearchText:self.searchDisplayController.searchBar.text];
    return coun;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BusLineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView==self.tableView) {
        BusLine *busLine;
        busLine=[busInfoDao busLineRow:[indexPath row]+1];
        cell.textLabel.text=busLine.lineName;
        // Configure the cell...
        return cell;
    }
    temBusLineArray=[busInfoDao busLineByName:self.searchDisplayController.searchBar.text];
        BusLine *busLine;
        busLine=(BusLine *)[temBusLineArray objectAtIndex:[indexPath row]];
        cell.textLabel.text=busLine.lineName;
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
    if (tableView==self.tableView) {
        BusLine *busLine;
        busLine=[busInfoDao busLineRow:[indexPath row]+1];
        BusStationViewController *busStationViewController=[[BusStationViewController alloc]init];
        busStationViewController.busLine=busLine;
        busStationViewController.busInfoDao=busInfoDao;
        [self.navigationController pushViewController:busStationViewController animated:YES];
        return;
    }
    
    BusLine *busLine;
    busLine=(BusLine *)[temBusLineArray objectAtIndex:[indexPath row]];
    BusStationViewController *busStationViewController=[[BusStationViewController alloc]init];
    busStationViewController.busLine=busLine;
    busStationViewController.busInfoDao=busInfoDao;
    [self.navigationController pushViewController:busStationViewController animated:YES];
    
    
}

-(void)dismiss{
    [self dismissModalViewControllerAnimated:YES];
}
@end
