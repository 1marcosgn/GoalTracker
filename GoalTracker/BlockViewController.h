//
//  BlockViewController.h
//  GoalTracker
//
//  Created by Marcos Garcia on 1/31/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocol for connection
@protocol ConnectionDelegate <NSObject>

-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name;

@end

@interface BlockViewController : UIViewController <NSURLConnectionDataDelegate>{
    NSMutableData *webData;
    NSURLConnection *connection;
    NSString *webServiceName;
    id<ConnectionDelegate> delegate;
}

@property (nonatomic, retain) id <ConnectionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSString *webServiceName;
@property (weak, nonatomic) IBOutlet UIView *containerLoad;


-(void)connect:(NSMutableURLRequest *)req;
-(void)executeService:(NSString *)nameWebService withData:(NSData *)jsonData type:(NSString *)type headers:(NSMutableDictionary *)headers;
-(void)start;
-(void)finish;
-(void)setPositionFromFrame:(CGRect)frame;
-(void)errorAlert:(NSString *)title :(NSString *)message;

@end
