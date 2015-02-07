//
//  weekDaysCell.h
//  GoalTracker
//
//  Created by Marcos Garcia on 1/29/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface weekDaysCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDayName;
@property (weak, nonatomic) IBOutlet UILabel *lblDayNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblSchedule;
@property (weak, nonatomic) IBOutlet UIImageView *imgOctagon;
@property (weak, nonatomic) IBOutlet UILabel *lblComplete;


@end
