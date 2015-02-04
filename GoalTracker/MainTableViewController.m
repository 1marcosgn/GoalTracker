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
    
    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"WEEK SCHEDULE";
    self.navigationItem.titleView = label;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    //UIColor *topBarColor = [UIColor colorWithRed:217.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Stats" style:UIBarButtonItemStylePlain target:self action:@selector(goToStadistics)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FM College Team" size:30], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [editButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = editButton;
    [self.tableView registerNib:[UINib nibWithNibName:@"weekDaysCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weekday"];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
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
    UILabel *lblDates = [[UILabel alloc]initWithFrame:CGRectMake(18, 6, 320, 45)];
    [lblDates setTextAlignment:NSTextAlignmentCenter];
    lblDates.text = @"  02/04/2015 - 02/10/2015";
    [lblDates setTextColor:[UIColor whiteColor]];
    [lblDates setFont:[UIFont fontWithName:@"Wagner Modern" size:24.0]];
    [headerView setBackgroundColor:[UIColor blackColor]];
    //[headerView setBackgroundColor:[UIColor colorWithRed:217.0/256.0 green:44.0/256.0 blue:44.0/256.0 alpha:1.0]];
    [headerView addSubview:lblDates];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
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
    
    
    if ([dictionaryContent count] == 0) {
        
        [self someTroubles];
        
    }
    else{
        
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
    
    
    [self someTroubles];
    
    
    
}


-(void)someTroubles{
    
    UIView *backView = [[UIView alloc]initWithFrame:self.tableView.frame];
    [backView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageBlank = [[UIImageView alloc]initWithFrame:CGRectMake(142, 212, 76, 76)];
    [imageBlank setImage:[UIImage imageNamed:@"failGloves.png"]];
    [imageBlank setAlpha:0.8];
    [backView addSubview:imageBlank];
    
    UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(41, 300, 291, 69)];
    lblMessage.text = @"Unable to load. Please try again or contact support@goaltracker.com if the issue persists.";
    lblMessage.numberOfLines = 3;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.textColor = [UIColor colorWithRed:139.0/256.0 green:139.0/256.0 blue:139.0/256.0 alpha:1.0];
    lblMessage.font = [UIFont fontWithName:@"Helvetica Neue" size:17.0];
    
    [backView addSubview:lblMessage];
    
    [self.tableView setUserInteractionEnabled:NO];
    [self.tableView setBackgroundView:backView];

    
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
