//
//  classCell.h
//  GoalTracker
//
//  Created by Marcos Garcia on 1/29/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface classCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *classSchedule;
@property (weak, nonatomic) IBOutlet UILabel *completedTag;
@property (weak, nonatomic) IBOutlet UIImageView *imgCellIcon;


@end
