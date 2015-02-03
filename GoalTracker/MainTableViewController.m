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
#import "BlockViewController.h"

@interface MainTableViewController (){
    
    NSMutableArray *arrTemporal;
    UIView *blockView;
    NSMutableArray *arrWeekDays;
    
    
    NSMutableArray *arrDayElements;
}

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrTemporal = [[NSMutableArray alloc]init];
    arrWeekDays = [[NSMutableArray alloc] initWithObjects:@"sunday", @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", nil];
    
    [self connectToService];
    
    [self setViewItems];
    
}

-(void)setViewItems{
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Stads" style:UIBarButtonItemStylePlain target:self action:@selector(goToStadistics)];
    self.navigationItem.rightBarButtonItem = editButton;
    [self.tableView registerNib:[UINib nibWithNibName:@"weekDaysCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weekday"];
    
}

-(void)presentLoadView{
    
    self.activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    blockView = [[UIView alloc]initWithFrame:CGRectMake(109, 224, 152, 152)];
    [blockView setBackgroundColor:[UIColor blackColor]];
    [blockView.layer setCornerRadius:8.0];
    [blockView.layer setMasksToBounds:YES];
    [self.activity startAnimating];
    self.activity.frame = CGRectMake(56, 56, self.activity.frame.size.width, self.activity.frame.size.height);
    [blockView addSubview:self.activity];
    [self.view addSubview:blockView];
    
}

-(void)removeLoadView{
    
    [blockView removeFromSuperview];
    [self.activity stopAnimating];
    
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
    //return [arrTemporal count];
    return [arrDayElements count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dictionaryTemporal = [NSMutableDictionary dictionary];
    dictionaryTemporal = [arrDayElements objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    UITableViewCell *cell;
    weekDaysCell *theCell = (weekDaysCell *) [tableView dequeueReusableCellWithIdentifier:@"weekday" forIndexPath:indexPath];
    
    theCell.lblDayName.text = [dictionaryTemporal valueForKey:@"day_name"]; // <-- Localize this string
    theCell.lblDayNumber.text = [NSString stringWithFormat:@"Day #%ld", indexPath.row + 1];
    theCell.lblSchedule.text = [NSString stringWithFormat:@"Open from %@ to %@", [dictionaryTemporal valueForKey:@"open_time"], [dictionaryTemporal valueForKey:@"close_time"]];
    
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
    
    NSMutableDictionary *dictionaryTemporal = [NSMutableDictionary dictionary];
    dictionaryTemporal = [arrDayElements objectAtIndex:[indexPath row]];
    
    DetailTableViewController *detailViewController = [[DetailTableViewController alloc]init];
    detailViewController.dayIdentifier = (int)indexPath.row + 1;
    
    NSMutableArray *arrClassTmp = [dictionaryTemporal objectForKey:@"classes"];
    detailViewController.arrClasses = [[NSMutableArray alloc]initWithArray:arrClassTmp];
    detailViewController.nameDay = [dictionaryTemporal valueForKey:@"day_name"];
    
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

}


-(void)connectToService{
    
    NSURL *url = [NSURL URLWithString:@"http://myfumbles.com/goaltracker/ufc_json_test.json"];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    NSURLConnection *cnn = [[NSURLConnection alloc]initWithRequest:req delegate:self];
    
    [self presentLoadView];
    
    if (cnn) {
        //do something with self.data
        self.dataResponse = [NSMutableData data];
    }
    
}

#pragma mark - Connection Delegates
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [self removeLoadView];
    NSMutableDictionary *dictionaryContent = [NSMutableDictionary dictionary];
    id JSON = [NSJSONSerialization JSONObjectWithData:self.dataResponse options:0 error:nil];
    dictionaryContent = JSON;
    
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    arrDayElements = [[NSMutableArray alloc]initWithCapacity:7];
    [arrDayElements insertObject:[dictionaryContent objectForKey:@"sunday"] atIndex:0];
    [arrDayElements insertObject:[dictionaryContent objectForKey:@"monday"] atIndex:1];
    [arrDayElements insertObject:[dictionaryContent objectForKey:@"tuesday"] atIndex:2];
    [arrDayElements insertObject:[dictionaryContent objectForKey:@"wednesday"] atIndex:3];
    [arrDayElements insertObject:[dictionaryContent objectForKey:@"thursday"] atIndex:4];
    [arrDayElements insertObject:[dictionaryContent objectForKey:@"friday"] atIndex:5];
    [arrDayElements insertObject:[dictionaryContent objectForKey:@"saturday"] atIndex:6];
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    NSMutableArray *arrDays = [[NSMutableArray alloc]init];
    NSMutableDictionary *tmpDictionay = [NSMutableDictionary dictionary];
    
    for (id object in dictionaryContent) {
        NSMutableDictionary *diccHelp = [NSMutableDictionary dictionary];
        diccHelp = [dictionaryContent objectForKey:object];
        
        [tmpDictionay setValue:object forKey:@"day"];
        [tmpDictionay setValue:[diccHelp objectForKey:@"open_time"] forKey:@"open_time"];
        [tmpDictionay setValue:[diccHelp objectForKey:@"close_time"] forKey:@"close_time"];
        
        NSMutableDictionary *dicctExtra = [NSMutableDictionary dictionary];
        
        [dicctExtra setObject:[tmpDictionay mutableCopy] forKey:[diccHelp objectForKey:@"day_name"]];
        [arrDays addObject:[dicctExtra mutableCopy]];
        [tmpDictionay removeAllObjects];
        [dicctExtra removeAllObjects];
        
    }
    
    arrTemporal = [arrDays mutableCopy];
    [self.tableView reloadData];
    

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.dataResponse setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.dataResponse appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self removeLoadView];
    NSLog(@"some troubles here...");
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
