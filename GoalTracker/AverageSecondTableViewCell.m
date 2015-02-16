//
//  AverageSecondTableViewCell.m
//  GoalTracker
//
//  Created by Marcos Garcia on 2/8/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "AverageSecondTableViewCell.h"

@implementation AverageSecondTableViewCell

- (void)awakeFromNib {
    
    self.lblCurrent.text = NSLocalizedString(@"CURRENT_DAY", nil);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
