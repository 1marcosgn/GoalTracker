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
}
@end

@implementation AverageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    current = 0;
    left = 0;
    
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
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
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
    // Dispose of any resources that can be recreated.
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
        secondCell.lblNameDay.text = [self getCurrentDayName];
        cell = secondCell;
    }
    else if (indexPath.row == 2){
        AverageThirdTableViewCell *thirdCell = (AverageThirdTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"avgThird" forIndexPath:indexPath];
        cell = thirdCell;
    }
    else if (indexPath.row == 3){
        AverageFourTableViewCell *fourCell = (AverageFourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"avgFour" forIndexPath:indexPath];
        fourCell.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
