//
//  BlockViewController.m
//  GoalTracker
//
//  Created by Marcos Garcia on 1/31/15.
//  Copyright (c) 2015 Marcos Garcia. All rights reserved.
//

#import "BlockViewController.h"

@interface BlockViewController ()
@end
@implementation BlockViewController

@synthesize indicator;
@synthesize delegate;
@synthesize webServiceName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.containerLoad.layer setCornerRadius:4.0];
    [self.containerLoad.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Connection Methods
-(void)connect:(NSMutableURLRequest *)req{
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (connection) {
        webData = [NSMutableData data];
    }
}

-(void)start{
    [indicator startAnimating];
}

-(void)finish{
    [indicator stopAnimating];
    [self.view removeFromSuperview];
}

-(void)setPositionFromFrame:(CGRect)frame{
    CGRect frCnx = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    frCnx.origin.x = (frame.size.width - frCnx.size.width)/2.0;
    frCnx.origin.y = (frame.size.height - frCnx.size.height)/2.0;
    [self.view setFrame:frCnx];
}

- (void) errorAlert:(NSString *)title :(NSString *)message
{
    UIAlertView *alertStatus = [[UIAlertView alloc]initWithTitle:title
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil, nil];
    [alertStatus show];
}

#pragma mark - Connection Delegates
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self finish];
    
    //Get schedules from a file (ufc_json_test.json)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ufc_json_test" ofType:@"json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [delegate connectionFinish:json succes:YES serviceName:webServiceName];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSMutableDictionary *dictionaryContent = [NSMutableDictionary dictionary];
    id JSON = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    dictionaryContent = JSON;
    [self finish];
    if (dictionaryContent != NULL) {
        [delegate connectionFinish:dictionaryContent succes:YES serviceName:webServiceName];
    }
    else{
        [delegate connectionFinish:dictionaryContent succes:NO serviceName:webServiceName];
    }
}

#pragma mark - View Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

@end
