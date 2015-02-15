//
//  StatsGraphicTableViewCell.m
//  GoalTracker
//
//  Created by Marcos Garcia on 2/7/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "StatsGraphicTableViewCell.h"

@implementation StatsGraphicTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)shareAction:(id)sender {
    //Get screenshot of the graphic
    CGRect rect = [self.viewGraphic bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.viewGraphic.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [delegate shareWeekActivity:capturedImage];
}

@end
