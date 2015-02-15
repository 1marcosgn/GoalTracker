//
//  AverageTableViewController.m
//  GoalTracker
//
//  Created by Marcos Garcia on 2/7/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "AverageTableViewController.h"
#import "AverageFirstTableViewCell.h"
#import "AverageSecondTableViewCell.h"
#import "AverageThirdTableViewCell.h"
#import "AverageFourTableViewCell.h"
#import <CoreData/CoreData.h>

@interface AverageTableViewController (){
    NSManagedObject *managedGlobal;
    NSMutableArray *arrElements;
    int current, left;
    UIImageView *imgChallenge;
    UIImageView *imgFront;
    NSMutableArray *arrQuotes;
}
@end

@implementation AverageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    current = 0;
    left = 0;
    
    arrQuotes = [[NSMutableArray alloc]initWithObjects:@"firs_Quote", @"second_Quote", @"third_Quote", @"four_Quote", @"five_Quote", @"six_Quote", @"seven_Quote", @"eight_Quote", nil];
    
    arrElements = [[NSMutableArray alloc]initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AverageFirstTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"avgFirst"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AverageSecondTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"avgSecond"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AverageThirdTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"avgThird"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AverageFourTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"avgFour"];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:recognizer];
    [self setViewItems];
}

-(void)setViewItems{
    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Average";
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    UIColor *topBarColor = [UIColor colorWithRed:169.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = topBarColor;//[UIColor redColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FM College Team" size:30], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [cancelButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [self getValues];
    [self setCurrentandLeftDays];
}

-(NSString *)getCurrentDayName{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *date = [NSDate date];
    dateFormatter.dateFormat=@"EEEE";
    NSString * dayString = [[dateFormatter stringFromDate:date] capitalizedString];
    return  dayString;
}

-(void)getValues{
    //Fetch the information
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"WeekInfo"];
    NSMutableArray *arrDevices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    if ([arrDevices count] > 0) {
        NSManagedObject *device = [arrDevices objectAtIndex:0];
        managedGlobal = device;
    }
}

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setCurrentandLeftDays{
    for (int i = 0; i < [arrElements count]; i++) {
        if ([[managedGlobal valueForKey:[arrElements objectAtIndex:i]] isEqualToString:@"complete"]) {
            current = current + 1;
        }
        else{
            left = left + 1;
        }
    }
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        AverageFirstTableViewCell *firstCell = (AverageFirstTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"avgFirst" forIndexPath:indexPath];
        firstCell.lblCurrentDays.text = [NSString stringWithFormat:@"%d", current];
        firstCell.lblRestDays.text = [NSString stringWithFormat:@"%d", left];
        cell = firstCell;
    }
    else if (indexPath.row == 1){
        AverageSecondTableViewCell *secondCell = (AverageSecondTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"avgSecond" forIndexPath:indexPath];
        secondCell.lblNameDay.text = NSLocalizedString([self getCurrentDayName], nil);
        cell = secondCell;
    }
    else if (indexPath.row == 2){
        AverageThirdTableViewCell *thirdCell = (AverageThirdTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"avgThird" forIndexPath:indexPath];
        cell = thirdCell;
    }
    else if (indexPath.row == 3){
        AverageFourTableViewCell *fourCell = (AverageFourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"avgFour" forIndexPath:indexPath];
        fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
        int randNum = rand() % [arrQuotes count];
        
        
        fourCell.lblQoute.text = NSLocalizedString([arrQuotes objectAtIndex:randNum], nil);
        
        
        cell = fourCell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float size = 0.0;
    if (indexPath.row == 0) {
        size = 119.0;
    }
    else if (indexPath.row == 1){
        size = 96.0;
    }
    else if (indexPath.row == 2){
        size = 96.0;
    }
    else if (indexPath.row == 3){
        size = 119.0;
    }
    return size;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headerView setBackgroundColor:[UIColor blackColor]];
    imgChallenge = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"octag.png"]];
    imgChallenge.frame = CGRectMake(0, 0, 380, 185);
    [headerView addSubview:imgChallenge];
    imgFront = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imgTest.png"]];
    imgFront.frame = CGRectMake(140, 30, 90, 90);
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 185.0;
}

#pragma mark - Scrolling
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float scale = 1.0f + fabsf(scrollView.contentOffset.y) / scrollView.frame.size.height;
    scale = MAX(0.0f, scale);
    imgChallenge.transform = CGAffineTransformMakeScale(scale, scale);
    imgFront.transform = CGAffineTransformMakeScale(scale, scale);
}

@end
