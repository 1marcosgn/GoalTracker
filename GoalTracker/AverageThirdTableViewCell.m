//
//  AverageThirdTableViewCell.m
//  GoalTracker
//
//  Created by Marcos Garcia on 2/8/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "AverageThirdTableViewCell.h"

@implementation AverageThirdTableViewCell

- (void)awakeFromNib {
    
    self.lblThisWeek.text = NSLocalizedString(@"THIS_WEEK", nil);
    self.lblMessage.text = NSLocalizedString(@"Message", nil);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
