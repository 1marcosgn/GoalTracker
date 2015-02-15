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
#import "BlockViewController.h"
#import <CoreData/CoreData.h>
#import "StatsTableViewController.h"

@interface MainTableViewController (){
    NSMutableArray *arrTemporal;
    UIView *blockView;
    NSMutableArray *arrWeekDays;
    NSMutableArray *arrDayElements;
    NSManagedObject *managedGlobal;
    NSMutableArray *modelDaysCompleted;
}
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    modelDaysCompleted = [[NSMutableArray alloc]initWithCapacity:7];
    for (int i = 0; i<7; i++) {
        [modelDaysCompleted addObject:@"nocomplete"];
    }
    arrTemporal = [[NSMutableArray alloc]init];
    arrWeekDays = [[NSMutableArray alloc] initWithObjects:@"sunday", @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", nil];
    [self connectToService];
    [self setViewItems];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getValues];
    [self.tableView reloadData];
    [self clearDb];
}

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)getValues{
    //Fetch the information
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"WeekInfo"];
    NSMutableArray *arrDevices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    if ([arrDevices count] > 0) {
        NSManagedObject *device = [arrDevices objectAtIndex:0];
        managedGlobal = device;
        if ([[managedGlobal valueForKey:@"sunday"] isEqualToString:@"complete"]) {
            [modelDaysCompleted insertObject:[managedGlobal valueForKey:@"sunday"] atIndex:0];
        }
        else if ([[managedGlobal valueForKey:@"monday"] isEqualToString:@"complete"]){
            [modelDaysCompleted insertObject:[managedGlobal valueForKey:@"monday"] atIndex:1];
        }
        else if ([[managedGlobal valueForKey:@"tuesday"] isEqualToString:@"complete"]){
            [modelDaysCompleted insertObject:[managedGlobal valueForKey:@"tuesday"] atIndex:2];
        }
        else if ([[managedGlobal valueForKey:@"wednesday"] isEqualToString:@"complete"]){
            [modelDaysCompleted insertObject:[managedGlobal valueForKey:@"wednesday"] atIndex:3];
        }
        else if ([[managedGlobal valueForKey:@"thursday"] isEqualToString:@"complete"]){
            [modelDaysCompleted insertObject:[managedGlobal valueForKey:@"thursday"] atIndex:4];
        }
        else if ([[managedGlobal valueForKey:@"friday"] isEqualToString:@"complete"]){
            [modelDaysCompleted insertObject:[managedGlobal valueForKey:@"friday"] atIndex:5];
        }
        else if ([[managedGlobal valueForKey:@"saturday"] isEqualToString:@"complete"]){
            [modelDaysCompleted insertObject:[managedGlobal valueForKey:@"saturday"] atIndex:6];
        }
    }
}

-(void)setViewItems{
    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"";
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    UIColor *topBarColor = [UIColor colorWithRed:169.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = topBarColor;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stats", nil) style:UIBarButtonItemStylePlain target:self action:@selector(goToStadistics)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FM College Team" size:30], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [editButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = editButton;
    [self.tableView registerNib:[UINib nibWithNibName:@"weekDaysCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weekday"];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Reset", nil) style:UIBarButtonItemStylePlain target:self action:@selector(gotoClear)];
    
    [cancelButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

-(void)gotoClear{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Delete_LocalDB", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"NO", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self clearDb];
    }
}

-(void)clearDb{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    //Week End Date
    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsEnd = [gregorianEnd components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    int Enddayofweek = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:today] weekday];
    [componentsEnd setDay:([componentsEnd day]+(7-Enddayofweek))];
    
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatCurrent = [[NSDateFormatter alloc]init];
    [dateFormatCurrent setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormat stringFromDate:todaysDate];
    NSDate *weekDay = [dateFormatCurrent dateFromString:currentDate];
    
    NSDate *EndOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"yyyy-MM-dd"];
    NSString *dateEndPrev = [dateFormat stringFromDate:EndOfWeek];
    NSDate *weekEndPrev = [dateFormat_End dateFromString:dateEndPrev];
    
    NSString *stringFromDate1 = [dateFormat_End stringFromDate:weekDay];
    NSString *stringFromDate2 = [dateFormat_End stringFromDate:weekEndPrev];
    
    if ([stringFromDate1 isEqualToString:stringFromDate2]) {
#warning uncomment this line
        //[self deleteLocalData];
    }
}

-(void)deleteLocalData{
    //clear data base here...
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"WeekInfo"];
    NSMutableArray *arrDevices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
    if ([arrDevices count] > 0) {
        NSManagedObject *device = [arrDevices objectAtIndex:0];
        [managedObjectContext deleteObject:device];
        [managedObjectContext deleteObject:managedGlobal];
        NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Couldn't save: %@", error);
        }
        [self.tableView reloadData];
    }
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
    StatsTableViewController *stadisticsView = [[StatsTableViewController alloc]initWithNibName:@"StatsTableViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:stadisticsView];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrDayElements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dictionaryTemporal = [NSMutableDictionary dictionary];
    dictionaryTemporal = [arrDayElements objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    UITableViewCell *cell;
    weekDaysCell *theCell = (weekDaysCell *) [tableView dequeueReusableCellWithIdentifier:@"weekday" forIndexPath:indexPath];
    //theCell.lblDayName.text = [dictionaryTemporal valueForKey:@"day_name"]; // <-- Localize this string

    theCell.lblDayName.text = NSLocalizedString([dictionaryTemporal valueForKey:@"day_name"], nil);
    
    theCell.lblDayNumber.text = [NSString stringWithFormat:@"%@ #%ld.", NSLocalizedString(@"Day", nil), indexPath.row + 1];
    theCell.lblDayNumber.layer.cornerRadius = 2.0;
    theCell.lblDayNumber.layer.masksToBounds = YES;
    
    //theCell.lblSchedule.text = [NSString stringWithFormat:@"Open from %@ to %@", [dictionaryTemporal valueForKey:@"open_time"], [dictionaryTemporal valueForKey:@"close_time"]];
    
    theCell.lblSchedule.text = [NSString stringWithFormat:NSLocalizedString(@"Open from %@ to %@", nil), [dictionaryTemporal valueForKey:@"open_time"], [dictionaryTemporal valueForKey:@"close_time"]];
    
    //Cell color
    if (indexPath.row + 1 == [self getNumberofWeek]) {
        [theCell.imgOctagon setImage:[UIImage imageNamed:@"yellowOctagon.png"]];
    }
    else if (indexPath.row + 1 < [self getNumberofWeek]){
        [theCell.imgOctagon setImage:[UIImage imageNamed:@"redOctagon.png"]];
    }
    else{
        [theCell.imgOctagon setImage:[UIImage imageNamed:@"orangeOctagon.png"]];
    }
    
    NSString *nameday_ = [[dictionaryTemporal valueForKey:@"day_name"] lowercaseString];
    
    if ([[managedGlobal valueForKey:nameday_] isEqualToString:@"complete"]) {
        theCell.lblComplete.transform = CGAffineTransformMakeRotation(M_PI / -4);
        [theCell.lblComplete setText:NSLocalizedString(@"Complete", nil)];
        [theCell.imgOctagon setImage:[UIImage imageNamed:@"greenOctagon.png"]];
    }
    else{
        [theCell.lblComplete setText:@""];
    }
    cell = theCell;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel *lblDates = [[UILabel alloc]initWithFrame:CGRectMake(18, 6, 320, 45)];
    [lblDates setTextAlignment:NSTextAlignmentCenter];
    lblDates.text = [self getStartandEndofWeek];
    [lblDates setTextColor:[UIColor whiteColor]];
    [lblDates setFont:[UIFont fontWithName:@"Wagner Modern" size:24.0]];
    [headerView setBackgroundColor:[UIColor blackColor]];
    [headerView addSubview:lblDates];
    return headerView;
}

-(NSString *)getStartandEndofWeek{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];// you can use your format.

    //Week Start Date
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    
    int dayofweek = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:today] weekday];// this will give you current day of week
    
    [components setDay:([components day] - ((dayofweek) - 1))];// for beginning of the week.
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    NSDate *weekstartPrev = [dateFormat_first dateFromString:dateString2Prev];
    NSString *stringFromDate = [dateFormat_first stringFromDate:weekstartPrev];
    stringFromDate = [stringFromDate stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    
    //Week End Date
    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsEnd = [gregorianEnd components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:today];
    int Enddayofweek = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:today] weekday];// this will give you current day of week
    [componentsEnd setDay:([componentsEnd day]+(7-Enddayofweek))];// for end day of the week
    NSDate *EndOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"yyyy-MM-dd"];
    NSString *dateEndPrev = [dateFormat stringFromDate:EndOfWeek];
    NSDate *weekEndPrev = [dateFormat_End dateFromString:dateEndPrev];
    NSString *stringFromDate2 = [dateFormat_End stringFromDate:weekEndPrev];
    stringFromDate2 = [stringFromDate2 stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    return [NSString stringWithFormat:@"%@ - %@", stringFromDate, stringFromDate2];
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
    return 196.0;
}

#pragma mark - Methods
-(int)getNumberofWeek{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    return (int)weekday;
}

-(void)connectToService{
    BlockViewController *connection = [[BlockViewController alloc]init];
    [connection setDelegate:self];
    [self.view insertSubview:connection.view atIndex:[[self.view subviews]count]];
    [connection start];
    NSURL *url = [NSURL URLWithString:@"http://myfumbles.com/goaltracker/ufc_json_test.json"];
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:url];
    [connection connect:[req mutableCopy]];
}

#pragma mark - Connection Delegates
-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name{
    
    if ([JSONObject count] == 0 || success == NO) {
        [self someTroubles];
    }
    else{
        //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        arrDayElements = [[NSMutableArray alloc]initWithCapacity:7];
        [arrDayElements insertObject:[JSONObject objectForKey:@"sunday"] atIndex:0];
        [arrDayElements insertObject:[JSONObject objectForKey:@"monday"] atIndex:1];
        [arrDayElements insertObject:[JSONObject objectForKey:@"tuesday"] atIndex:2];
        [arrDayElements insertObject:[JSONObject objectForKey:@"wednesday"] atIndex:3];
        [arrDayElements insertObject:[JSONObject objectForKey:@"thursday"] atIndex:4];
        [arrDayElements insertObject:[JSONObject objectForKey:@"friday"] atIndex:5];
        [arrDayElements insertObject:[JSONObject objectForKey:@"saturday"] atIndex:6];
        //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        NSMutableArray *arrDays = [[NSMutableArray alloc]init];
        NSMutableDictionary *tmpDictionay = [NSMutableDictionary dictionary];
        for (id object in JSONObject) {
            NSMutableDictionary *diccHelp = [NSMutableDictionary dictionary];
            diccHelp = [JSONObject objectForKey:object];
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

@end
