//
//  SignUpViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "Color.h"

@interface SignUpViewController ()
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *confirmPWTextField;
@property (nonatomic, strong) UITapGestureRecognizer *tapper;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.navigationItem.title = @"Sign Up";
	if ([self.usernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
		self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]}];
	}
	if ([self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
		self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]}];
	}
	if ([self.confirmPWTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
		self.confirmPWTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]}];
	}
	
	self.tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:self.tapper];
	self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
}

- (void)hideKeyboard {
	[self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//[[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signupPressed {
	if (![self.confirmPWTextField.text isEqualToString:self.passwordTextField.text]) {
		[self alertWithTitle:@"Password Mismatch" andMessage:@"The passwords do not match."];
		return;
	}
	
	[SVProgressHUD showWithStatus:@"Signing Up..."];
	PFUser *user = [PFUser user];
	user.username = [self.usernameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	user.password = [self.passwordTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];;
	user[@"startTime"] = [NSDate date];
	user[@"endTime"] = [NSDate date];
	user[@"weight"] = @(0);
	user[@"activities"] = @[];
	user[@"intensities"] = @[];
	user[@"friends"] = @[];
	user[@"name"] = @"";
	
	[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		[SVProgressHUD dismiss];
		
		if (!error) {   // Hooray! Let them use the app now.
			if (self.delegate) {
				[self.delegate signUpViewControllerSucceeded];
			}
		} else {
			[self alertWithTitle:@"Signup Issue" andMessage:@"Sorry, something went wrong with Sign Up. Try again!"];
		}
	}];
}

-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
	[self presentViewController:alert animated:YES completion:nil];
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
