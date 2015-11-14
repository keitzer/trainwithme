//
//  ViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.nameLabel.text = @"Alex";
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	PFObject *gym = [PFObject objectWithClassName:@"Gym"];
	gym[@"Name"] = textField.text;
	[gym saveInBackground];
	
	return YES;
}

@end
