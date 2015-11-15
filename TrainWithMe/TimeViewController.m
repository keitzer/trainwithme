//
//  TimeViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/15/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "TimeViewController.h"
#import "Color.h"

@interface TimeViewController ()
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@property (nonatomic, weak) IBOutlet UIDatePicker *startPicker;
@property (nonatomic, weak) IBOutlet UIDatePicker *endPicker;
@end

@implementation TimeViewController

-(id)initWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	self = [storyboard instantiateViewControllerWithIdentifier:@"timeVC"];
	self.startTime = startTime;
	self.endTime = endTime;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.startPicker.date = self.startTime;
	self.endPicker.date = self.endTime;
	self.navigationController.navigationBar.barTintColor = [UIColor colorTeal];
	[self.startPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
	[self.endPicker setValue:[UIColor whiteColor] forKey:@"textColor"];
	self.navigationItem.title = @"Select Time";
}

-(IBAction)savePressed {
	self.startTime = self.startPicker.date;
	self.endTime = self.endPicker.date;
	
	if (self.delegate) {
		[self.delegate timeVCTimesSaved:self.startTime endTime:self.endTime];
	}
}

-(IBAction)cancelPressed {
	if (self.delegate) {
		[self.delegate timeVCTimesCancelled];
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
