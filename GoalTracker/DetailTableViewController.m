//
//  DetailTableViewController.m
//  GoalTracker
//
//  Created by Marcos Garcia on 1/29/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "DetailTableViewController.h"
#import "classCell.h"
#import <CoreData/CoreData.h>

@interface DetailTableViewController (){
    int elementSelected;

}

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"classCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellClass"];
    
    
    if (self.dayIdentifier != [self getNumberofWeek]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"You can't complete any activity for this day because is not the current day" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
    [self setViewItems];
    
}


-(int)getNumberofWeek{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    return (int)weekday;
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setViewItems{
    
    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"CLASS SCHEDULE";
    self.navigationItem.titleView = label;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    //UIColor *topBarColor = [UIColor colorWithRed:217.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FM College Team" size:30], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [cancelButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    
    self.activitiesCompletedModel = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [self.arrClasses count]; i++) {
        [self.activitiesCompletedModel addObject:@"No Completed"];
    }
    
    self.activitiesCurrentClassImage = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [self.arrClasses count]; i++) {
        [self.activitiesCurrentClassImage addObject:@"no_image"];
    }
    
    
    if ([self.arrClasses count] == 0) {
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
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:recognizer];
    
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
    return [self.arrClasses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    classCell *cell = (classCell *) [tableView dequeueReusableCellWithIdentifier:@"cellClass" forIndexPath:indexPath];
    
    NSMutableDictionary *diccTmpClass = [NSMutableDictionary dictionary];
    diccTmpClass = [self.arrClasses objectAtIndex:[indexPath row]];
    
    cell.className.text = [diccTmpClass valueForKey:@"class_name"];
    cell.classSchedule.text = [diccTmpClass valueForKey:@"class_schedule"];
    cell.completedTag.text = [self.activitiesCompletedModel objectAtIndex:indexPath.row];
    
    //Tag color...
    if ([cell.completedTag.text isEqualToString:@"Completed"]) {
        [cell.completedTag setBackgroundColor:[UIColor blackColor]];
        [cell.completedTag setTextColor:[UIColor whiteColor]];
    }
    else{
        [cell.completedTag setBackgroundColor:[UIColor clearColor]];
        [cell.completedTag setTextColor:[UIColor grayColor]];
    }
    
    [cell.completedTag setFont:[UIFont fontWithName:@"Wagner Modern" size:14.0]];
    [cell.completedTag.layer setCornerRadius:2.0];
    [cell.completedTag.layer setMasksToBounds:YES];
    
    //imageCell - current class (use data model)
    //cell.imgCellIcon.image = [UIImage imageNamed:[self.activitiesCurrentClassImage objectAtIndex:indexPath.row]];
    if (self.dayIdentifier == [self getNumberofWeek]) {
        
        //cell.imgCellIcon.image = [UIImage imageNamed:@"currentClass.png"];
        
    }
    
    [cell.imgCellIcon setHidden:YES];
    
    if (self.dayIdentifier == [self getNumberofWeek]) {
        cell.userInteractionEnabled = YES;
    }
    else{
        cell.userInteractionEnabled = NO;
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 123.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    UILabel *lblDates = [[UILabel alloc]initWithFrame:CGRectMake(30, 22, 320, 45)];
    [lblDates setTextAlignment:NSTextAlignmentCenter];
    [lblDates setFont:[UIFont fontWithName:@"Wagner Modern" size:44.0]];
    lblDates.text = self.nameDay;
    [lblDates setTextColor:[UIColor whiteColor]];
    [headerView setBackgroundColor:[UIColor blackColor]];
    [headerView addSubview:lblDates];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    elementSelected = (int)indexPath.row;
    [self showActionSheet];
}

-(void)showActionSheet{
    
    NSString *actionTitle = @"Did you finish the activity??";
    NSString *doneButton = @"I'm Done";
    NSString *cancelButton = @"No, I want to continue";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:actionTitle delegate:self cancelButtonTitle:cancelButton destructiveButtonTitle:nil otherButtonTitles:doneButton, nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self setActivityDone];
            break;
        //case 1:
            //[self selectPicture];
          //  break;
        default:
            break;
    }
}

-(void)setActivityDone{
    
    [self.activitiesCompletedModel replaceObjectAtIndex:elementSelected withObject:@"Completed"];
    [self.tableView reloadData];
    [self saveData];
    
}


-(void)saveData{
    //Validation
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"WeekInfo"];
    NSMutableArray *arrDevices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
    if ([arrDevices count] > 0) {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *device = [arrDevices objectAtIndex:0];
        [device setValue:@"complete" forKey:[self.nameDay lowercaseString]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error here...");
        }else{
            NSLog(@"success");
        }
    }
    else{
        NSManagedObjectContext *context = [self managedObjectContext];
        //Create a new managed object
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"WeekInfo" inManagedObjectContext:context];
        [newDevice setValue:@"complete" forKey:[self.nameDay lowercaseString]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error here...");
        }else{
            NSLog(@"success");
        }
    }
}
     
-(void)checkCurrentClass{
    
    //If its the current day
    if (self.dayIdentifier == [self getNumberofWeek]) {
        [self.activitiesCurrentClassImage replaceObjectAtIndex:0 withObject:@"currentClass.png"];
        [self.tableView reloadData];
    }
}


#pragma mark - Core Data Implementation
-(NSManagedObjectContext *)managedObjectContext{
    
    NSManagedObjectContext *context;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
    
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
