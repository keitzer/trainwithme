//
//  ViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "ViewController.h"
#import "WelcomeViewController.h"
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

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		// do stuff with the user
	} else {
		// show the signup or login screen
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		WelcomeViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"welcomeVC"];
		UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
		
		[self presentViewController:navBar animated:YES completion:nil];
	}
	
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
