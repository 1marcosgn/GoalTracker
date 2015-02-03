//
//  DetailTableViewController.m
//  GoalTracker
//
//  Created by Marcos Garcia on 1/29/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "DetailTableViewController.h"
#import "classCell.h"

@interface DetailTableViewController (){
    int elementSelected;
}

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"classCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellClass"];
    
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
    cell.completedTag.text = [self.activitiesCompletedModel objectAtIndex:indexPath.row];
    cell.classSchedule.text = [diccTmpClass valueForKey:@"class_schedule"];
    
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
