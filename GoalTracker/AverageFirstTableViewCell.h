//
//  AverageFirstTableViewCell.h
//  GoalTracker
//
//  Created by Marcos Garcia on 2/8/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AverageFirstTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDays;
@property (weak, nonatomic) IBOutlet UILabel *lblRestDays;
@property (weak, nonatomic) IBOutlet UILabel *lblActivities;
@property (weak, nonatomic) IBOutlet UILabel *lblThisWeek;
@property (weak, nonatomic) IBOutlet UILabel *lblDaysLeft;

@end
