//
//  StatsGraphicTableViewCell.h
//  GoalTracker
//
//  Created by Marcos Garcia on 2/7/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol shareProtocol <NSObject>
@required
-(void)shareWeekActivity:(UIImage *)imageShare;
@end

@interface StatsGraphicTableViewCell : UITableViewCell{
    id<shareProtocol> delegate;
}

@property (nonatomic, strong) id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgSunday;
@property (weak, nonatomic) IBOutlet UIImageView *imgMonday;
@property (weak, nonatomic) IBOutlet UIImageView *imgTuesday;
@property (weak, nonatomic) IBOutlet UIImageView *imgWednesday;
@property (weak, nonatomic) IBOutlet UIImageView *imgThursday;
@property (weak, nonatomic) IBOutlet UIImageView *imgFriday;
@property (weak, nonatomic) IBOutlet UIImageView *imgSaturday;
@property (weak, nonatomic) IBOutlet UIView *viewGraphic;

- (IBAction)shareAction:(id)sender;

@end
