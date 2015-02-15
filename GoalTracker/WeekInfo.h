//
//  WeekInfo.h
//  GoalTracker
//
//  Created by Marcos Garcia on 2/4/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WeekInfo : NSManagedObject

@property (nonatomic, retain) NSString * saturday;
@property (nonatomic, retain) NSString * friday;
@property (nonatomic, retain) NSString * thursday;
@property (nonatomic, retain) NSString * wednesday;
@property (nonatomic, retain) NSString * tuesday;
@property (nonatomic, retain) NSString * monday;
@property (nonatomic, retain) NSString * sunday;

@end
