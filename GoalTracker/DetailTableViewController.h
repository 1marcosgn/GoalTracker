//
//  DetailTableViewController.h
//  GoalTracker
//
//  Created by Marcos Garcia on 1/29/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewController : UITableViewController <UIActionSheetDelegate>

@property(nonatomic, assign) int dayIdentifier;
@property(nonatomic, strong) NSMutableArray *arrClasses;
@property(nonatomic, assign) NSString *nameDay;
@property(nonatomic, strong) NSMutableArray *activitiesCompletedModel;
@property(nonatomic, strong) NSMutableArray *activitiesCurrentClassImage;

@end
