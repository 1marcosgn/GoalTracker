//
//  MainTableViewController.m
//  GoalTracker
//
//  Created by Marcos Garcia on 1/29/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "MainTableViewController.h"
#import "weekDaysCell.h"
#import "DetailTableViewController.h"
#import "StadisticsViewController.h"

@interface MainTableViewController (){
    
    NSMutableArray *arrTemporal;
    
}

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setViewItems];
    
}

-(void)setViewItems{
    
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Stads" style:UIBarButtonItemStylePlain target:self action:@selector(goToStadistics)];
    

    self.navigationItem.rightBarButtonItem = editButton;
        
    
    arrTemporal = [[NSMutableArray alloc]initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday",nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"weekDaysCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weekday"];
    
}

-(void)goToStadistics{
    
    
    //StadisticsViewController *stadisticsView = [[StadisticsViewController alloc]init];
    //[self presentViewController:stadisticsView animated:YES completion:nil];
    
    StadisticsViewController *stadisticsView = [[StadisticsViewController alloc]initWithNibName:@"StadisticsViewController" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:stadisticsView];
    
    [self presentViewController:navController animated:YES completion:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrTemporal count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    // Configure the cell...
    weekDaysCell *theCell = (weekDaysCell *) [tableView dequeueReusableCellWithIdentifier:@"weekday" forIndexPath:indexPath];
    
    theCell.lblDayName.text = [arrTemporal objectAtIndex:indexPath.row];
    theCell.lblDayNumber.text = [NSString stringWithFormat:@"Day #%ld", indexPath.row + 1];
    
    //Cell color
    if (indexPath.row + 1 == [self getNumberofWeek]) {
        
        [theCell setBackgroundColor:[UIColor yellowColor]];
        
    }
    else if (indexPath.row + 1 < [self getNumberofWeek]){
        [theCell setBackgroundColor:[UIColor redColor]];
    }
    else{
        [theCell setBackgroundColor:[UIColor orangeColor]];
    }
    
    
    cell = theCell;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel *lblDates = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 320, 30)];
    [lblDates setTextAlignment:NSTextAlignmentCenter];
    lblDates.text = @"01/28/2015 = 02/03/2015";
    [lblDates setTextColor:[UIColor whiteColor]];
    [headerView setBackgroundColor:[UIColor redColor]];
    [headerView addSubview:lblDates];
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailTableViewController *detailViewController = [[DetailTableViewController alloc]init];
    detailViewController.dayIdentifier = (int)indexPath.row + 1;

    //This information depends of the day of the week...
    detailViewController.arrClasses = [[NSMutableArray alloc]initWithObjects:@"Boxing", @"Kickboxing", nil];
    detailViewController.nameDay = [arrTemporal objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 134.0;
    
}

#pragma mark - Methods
-(int)getNumberofWeek{
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    
    return (int)weekday;
    
    
    //CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
    //CFTimeZoneRef tz = CFTimeZoneCopySystem();
    //SInt32 WeekdayNumber = CFAbsoluteTimeGetDayOfWeek(at, tz);
    
    //return [WeekdayNumber intValue];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
