//
//  StatsTableViewController.m
//  GoalTracker
//
//  Created by Marcos Garcia on 2/7/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "StatsTableViewController.h"
#import <CoreData/CoreData.h>
#import <Social/Social.h>
#import "AverageTableViewController.h"

@interface StatsTableViewController ()
{
    NSMutableArray *arrElements;
    NSMutableArray *modelDaysCompleted;
    NSManagedObject *managedGlobal;
    UIImage *imageGlobal;
}

@end

@implementation StatsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    modelDaysCompleted = [[NSMutableArray alloc]initWithCapacity:7];
    for (int i = 0; i<7; i++) {
        [modelDaysCompleted addObject:@"nocomplete"];
    }
    arrElements = [[NSMutableArray alloc]initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Perspective", nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsDayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"statsDayCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsGraphicTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"perspectiveCell"];
    [self setViewItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setViewItems
{
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"statsBackGrnd.png"]];
    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Stats", nil);
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    UIColor *topBarColor = [UIColor colorWithRed:169.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = topBarColor;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    UIBarButtonItem *avgButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Average", nil) style:UIBarButtonItemStylePlain target:self action:@selector(gotoAverage)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FM College Team" size:30], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [cancelButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [avgButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = avgButton;
    [self getValues];
}

-(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)getValues
{
    //Fetch the information
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"WeekInfo"];
    NSMutableArray *arrDevices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
    if ([arrDevices count] > 0)
    {
        NSManagedObject *device = [arrDevices objectAtIndex:0];
        managedGlobal = device;
    }
}

-(void)gotoAverage
{
    AverageTableViewController *averageView = [[AverageTableViewController alloc]initWithNibName:@"AverageTableViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:averageView];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)shareWeekActivity:(UIImage *)imageShare
{
    imageGlobal = imageShare;
    NSString *actionSheetTitle = @"Share";
    NSString *twitter = @"Twitter";
    NSString *facebook = @"Facebook";
    NSString *cancelSheet = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:actionSheetTitle delegate:self cancelButtonTitle:cancelSheet destructiveButtonTitle:nil otherButtonTitles:twitter, facebook, nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Twiter
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSString *tweet;
    //Facebook
    SLComposeViewController *faceSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    NSString *face;
    
    //Alert..
    UIAlertView *alert;
    switch (buttonIndex) {
        case 0:
            //Share on twitter..
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                tweet = @"This is my week activity so far with my @GoalTracker Check it out! #GoalTracker";
                [tweetSheet setInitialText:tweet];
                [tweetSheet addImage:imageGlobal];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else{
                alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please configure an account for you device" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        case 1:
            //Post on facebook...
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                face = @"This is my week activity so far with my @GoalTracker Check it out! #GoalTracker";
                [faceSheet setInitialText:face];
                [faceSheet addImage:imageGlobal];
                [self presentViewController:faceSheet animated:YES completion:nil];
            }
            else{
                alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please configure an account for you device" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrElements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row <= 6) {
        //Day cell
        StatsDayTableViewCell *statsDayCell = (StatsDayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"statsDayCell" forIndexPath:indexPath];
        statsDayCell.lblNameDay.text = NSLocalizedString([arrElements objectAtIndex:indexPath.row], nil);
        
        if ([[managedGlobal valueForKey:[[arrElements objectAtIndex:indexPath.row] lowercaseString]] isEqualToString:@"complete"]) {
            statsDayCell.lblStatus.text = NSLocalizedString(@"Complete_Upper", nil);
            [statsDayCell.lblStatus setBackgroundColor:[UIColor blackColor]];
            statsDayCell.lblStatus.textColor = [UIColor whiteColor];
        }
        else{
            statsDayCell.lblStatus.text = NSLocalizedString(@"NoComplete_Upper", nil);
        }
        
        [statsDayCell.lblStatus setFont:[UIFont fontWithName:@"Wagner Modern" size:14.0]];
        [statsDayCell.lblStatus.layer setCornerRadius:2.0];
        [statsDayCell.lblStatus.layer setMasksToBounds:YES];
        cell = statsDayCell;
    }
    else{
        //Perspective cell
        StatsGraphicTableViewCell *statsGraphicCell = (StatsGraphicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"perspectiveCell" forIndexPath:indexPath];
        
        if ([[managedGlobal valueForKey:@"sunday"] isEqualToString:@"complete"]) {
            statsGraphicCell.imgSunday.image = [UIImage imageNamed:@"completeDay.png"];
        }
        if ([[managedGlobal valueForKey:@"monday"] isEqualToString:@"complete"]){
            statsGraphicCell.imgMonday.image = [UIImage imageNamed:@"completeDay.png"];
        }
        if ([[managedGlobal valueForKey:@"tuesday"] isEqualToString:@"complete"]){
            statsGraphicCell.imgTuesday.image = [UIImage imageNamed:@"completeDay.png"];
        }
        if ([[managedGlobal valueForKey:@"wednesday"] isEqualToString:@"complete"]){
            statsGraphicCell.imgWednesday.image = [UIImage imageNamed:@"completeDay.png"];
        }
        if ([[managedGlobal valueForKey:@"thursday"] isEqualToString:@"complete"]){
            statsGraphicCell.imgThursday.image = [UIImage imageNamed:@"completeDay.png"];
        }
        if ([[managedGlobal valueForKey:@"friday"] isEqualToString:@"complete"]){
            statsGraphicCell.imgFriday.image = [UIImage imageNamed:@"completeDay.png"];
        }
        if ([[managedGlobal valueForKey:@"saturday"] isEqualToString:@"complete"]){
            statsGraphicCell.imgSaturday.image = [UIImage imageNamed:@"completeDay.png"];
        }
        statsGraphicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [statsGraphicCell setDelegate:self];
        cell = statsGraphicCell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        return 204.0;
    }
    else{
        return 58.0;
    }
}

@end
