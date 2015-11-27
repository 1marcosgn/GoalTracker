//
//  AverageFirstTableViewCell.m
//  GoalTracker
//
//  Created by Marcos Garcia on 2/8/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "AverageFirstTableViewCell.h"

@implementation AverageFirstTableViewCell

- (void)awakeFromNib
{
    self.lblActivities.text = NSLocalizedString(@"ACTIVITIES", nil);
    self.lblThisWeek.text = NSLocalizedString(@"THIS_WEEK", nil);
    self.lblDaysLeft.text = NSLocalizedString(@"DAYS_LEFT", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
